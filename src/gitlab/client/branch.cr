module Gitlab
  class Client
    # Defines methods related to branch.
    #
    # See [http://docs.gitlab.com/ce/api/branches.html](http://docs.gitlab.com/ce/api/branches.html)
    module Branch
      # Gets a list of branches in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of branches under a project.
      #
      # ```
      # client.branches(1)
      # client.branches(1, {"per_page" => "10"})
      # ```
      def branches(project_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/branches", params: params).body
      end

      # Get single branch in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] branch The name of a branch.
      # - return [Hash] Information about the branch in a project.
      #
      # ```
      # client.branch(1, "master")
      # ```
      def branch(project_id : Int32, branch : String) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/branches/#{branch}").body
      end

      # Create branch in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] branch The name of a branch.
      # - param  [String] ref The branch name or commit SHA to create branch from.
      # - return [Hash] Information about the created branch in a project.
      #
      # ```
      # client.create_branch(1, "develop", "master")
      # client.create_branch(1, "hotfix/xxx", "9dff773")
      # ```
      def create_branch(project_id : Int32, branch : String, ref : String) : JSON::Any
        JSON.parse post("/projects/#{project_id}/repository/branches", form: {
          "branch_name" => branch,
          "ref"         => ref,
        }).body
      end

      # Delete a branch.
      #
      # - param  [Int32] project_id The ID of a project
      # - param  [String] branch The name of a branch.
      # - return [Hash] Information about the deleted branch.
      #
      # ```
      # client.delete_branch(4, 2)
      # ```
      def delete_branch(project_id : Int32, branch : String) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/repository/branches/#{branch}").body
      end

      # Protect branch in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] branch The name of a branch.
      # - param  [String] ref The branch name or commit SHA to create branch from.
      # - return [Hash] Information about protected branch in a project
      #
      # ```
      # client.branch(1, "master")
      # ```
      def protect_branch(project_id : Int32, branch : String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/repository/branches/#{branch}/protect").body
      end

      # Unprotect branch in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] branch The name of a branch.
      # - return [Hash] Information about unprotected branch in a project
      #
      # ```
      # client.branch(1, "master")
      # ```
      def protect_branch(project_id : Int32, branch : String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/repository/branches/#{branch}/unprotect").body
      end
    end
  end
end
