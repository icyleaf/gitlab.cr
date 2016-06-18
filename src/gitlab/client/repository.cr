module Gitlab
  class Client
    # Defines methods related to repository.
    #
    # See [http://docs.gitlab.com/ce/api/repositories.html](http://docs.gitlab.com/ce/api/repositories.html)
    module Repository
      # Get a list of repository files and directories in a project.
      #
      # @param  [Int32] project The ID of a project.
      # @param  [Hash] params A customizable set of params.
      # @option params [String] :path The path inside repository. Used to get contend of subdirectories.
      # @option params [String] :ref_name The name of a repository branch or tag or if not given the default branch
      # @return [Hash]
      #
      # ```
      # client.tree(42)
      # client.tree(42, { path: 'Gemfile' })
      # ```
      def tree(project_id : Int32, params : Hash? = nil)
        get("/projects/#{project_id}/repository/tree", params).body.parse_json
      end
    end
  end
end