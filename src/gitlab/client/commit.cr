module Gitlab
  class Client
    # Defines methods related to branch.
    #
    # See [http://docs.gitlab.com/ce/api/commits.html](http://docs.gitlab.com/ce/api/commits.html)
    module Commit
      # Gets a list of commits in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :ref_name The name of a repository branch or tag or if not given the default branch.
      # - option params [String] :since Only commits after or in this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ.
      # - option params [String] :until Only commits before or in this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of commits.
      #
      # ```
      # client.commits(1)
      # client.commits(1, {"per_page" => "10"})
      # ```
      def commits(project_id : Int32, params : Hash? = nil)
        JSON.parse get("/projects/#{project_id}/repository/commits", params: params).body
      end

      # Get single commit in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] commit_id The ID of a commit.
      # - return [Hash] Information about the commit.
      #
      # ```
      # client.commit(1, 10)
      # ```
      def commit(project_id : Int32, commit_id : Int32)
        JSON.parse get("/projects/#{project_id}/repository/commits/#{commit_id}").body
      end

      # Get the diff of a commit in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] sha The name of a repository branch or tag or if not given the default branch.
      # - return [Hash] Information about the commit diff.
      #
      # ```
      # client.commit_diff(1, "daff23c")
      # ```
      def commit_diff(project_id : Int32, sha : String)
        JSON.parse get("/projects/#{project_id}/repository/commits/#{sha}/diff").body
      end

      # Get the comments of a commit in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] sha The name of a repository branch or tag or if not given the default branch.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20.
      # - return [Array<Hash>] List of comments in a commit.
      #
      # ```
      # client.commit_comments(1, "daff23c")
      # ```
      def commit_comments(project_id : Int32, sha : String, params : Hash = {} of String => String)
        JSON.parse get("/projects/#{project_id}/repository/commits/#{sha}/comments", params: params).body
      end

      # Create comment of commit in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] sha The commit SHA or name of a repository branch or tag.
      # - param  [String] note The text of the comment.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :path The file path relative to the repository.
      # - option params [String] :line The line number where the comment should be placed.
      # - option params [String] :line_type The line type. Takes new or old as arguments.
      # - return [Hash] Information about the created commet of commit in a project.
      #
      # ```
      # client.create_commit_comment(1, "daff23c", "awesome!")
      # client.create_commit_comment(1, "daff23c", "+1", {"line" => "29"})
      # ```
      def create_commit_comment(project_id : Int32, sha : String, note : String, params : Hash = {} of String => String)
        JSON.parse post("/projects/#{project_id}/repository/commits/#{sha}/comments", form: {
          "note" => note,
        }.merge(params)).body
      end

      # Get the statuses of a commit in a project.
      #
      # Since GitLab 8.1, this is the new commit status API.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] sha The commit hash.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :ref Filter by ref name, it can be branch or tag.
      # - option params [String] :stage Filter by stage.
      # - option params [String] :name Filer by status name, eg. jenkins.
      # - option params [String] :all The flag to return all statuses, not only latest ones.
      #
      # ```
      # client.commit_status(42, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
      # client.commit_status(42, "6104942438c14ec7bd21c6cd5bd995272b3faff6", {"name" => "jenkins"})
      # client.commit_status(42, "6104942438c14ec7bd21c6cd5bd995272b3faff6", {"name" => "jenkins", "all" => "true"})
      # ```
      def commit_status(project_id : Int32, sha : String, params : Hash = {} of String => String)
        JSON.parse get("/projects/#{project_id}/repository/commits/#{sha}/statuses", params: params).body
      end

      # Adds or updates a status of a commit.
      #
      # Since GitLab 8.1, this is the new commit status API.
      #
      # - param  [Integer] project_id The ID of a project.
      # - param  [String] sha The commit hash.
      # - param  [String] state of the status. Can be: pending, running, success, failed, canceled.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :ref The ref (branch or tag) to which the status refers.
      # - option params [String] :name Filer by status name, eg. jenkins.
      # - option params [String] :target_url The target URL to associate with this status.
      # - option params [String] :description The short description of the status.
      #
      # ```
      # client.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'success')
      # client.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'failed', { name: 'jenkins' })
      # client.update_commit_status(42, '6104942438c14ec7bd21c6cd5bd995272b3faff6', 'canceled', { name: 'jenkins', target_url: 'http://example.com/builds/1' })
      # ```
      def update_commit_status(project_id : Int32, sha : String, state : String, params : Hash = {} of String => String)
        JSON.parse post("/projects/#{project_id}/statuses/#{sha}", form: {
          "state" => state,
        }.merge(params)).body
      end
    end
  end
end
