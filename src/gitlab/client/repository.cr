module Gitlab
  class Client
    # Defines methods related to repository.
    #
    # See [http://docs.gitlab.com/ce/api/repositories.html](http://docs.gitlab.com/ce/api/repositories.html)
    module Repository
      # Get a list of repository files and directories in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :path The path inside repository. Used to get contend of subdirectories.
      # - option params [String] :ref_name The name of a repository branch or tag or if not given the default branch
      # - return [JSON::Any]
      #
      # ```
      # client.tree(42)
      # client.tree(42, { path: 'Gemfile' })
      # ```
      def tree(project_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/tree", params: params).body
      end

      # Get the raw file contents for a blob by blob SHA.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] sha The id of a commit sha.
      # - return [String] The raw file contents
      #
      # ```
      # client.blow_contents(1, "74bbc1b7")
      # client.blow_contents(1, "a5c805f456f46b44e270f342330b06e06c53cbcc")
      # ```
      def blob(project_id : Int32, sha = "HEAD", params : Hash? = nil) : String
        get("/projects/#{project_id}/repository/blobs/#{sha}", params: params).body
      end

      # Get an archive of the repository.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] sha The commit SHA to download defaults to the tip of the default branch.
      # - return [Gitlab::FileResponse, JSON::Any] The archive file.
      #
      # ```
      # file = client.repo_archive(1)
      # file = client.repo_archive(1, "a5c805f456f46b44e270f342330b06e06c53cbcc")
      # ```
      def repo_archive(project_id : Int32, sha = "HEAD") : Gitlab::FileResponse | JSON::Any
        mime_type = "application/octet-stream"
        response = get("/projects/#{project_id}/repository/archive", params: {
          "sha" => sha,
        }, headers: {
          "Accept" => mime_type,
        })

        if response.headers["Content-Type"] == mime_type
          Gitlab::FileResponse.new(IO::Memory.new(response.body), response.headers)
        else
          # Error with json response
          JSON.parse(response.body)
        end
      end

      # Compare branches, tags or commits.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] from the commit SHA or branch name.
      # - param  [String] to the commit SHA or branch name.
      # - return [String] List a compare between from and to.
      #
      # ```
      # client.compare(1, "master", "develop")
      # client.compare(1, "a5c805f4", "v1.0.0")
      # ```
      def compare(project_id : Int32, from : String, to : String) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/compare", params: {
          "from" => from,
          "to"   => to,
        }).body
      end

      # Get repository contributors list
      #
      # - param  [Int32] project The ID of a project.
      # - params  [Hash] options A customizable set of options.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [JSON::Any] List of projects of the authorized user.
      #
      # ```
      # client.contributors(1)
      # client.contributors(1, {"per_page" => "10"})
      # ```
      def contributors(project_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/contributors", params: params)
      end
    end
  end
end
