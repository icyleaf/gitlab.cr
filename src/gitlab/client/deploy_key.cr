module Gitlab
  class Client
    # Defines methods related to deploy key.
    #
    # See [http://docs.gitlab.com/ce/api/deploy_keys.html](http://docs.gitlab.com/ce/api/deploy_keys.html)
    module DeployKey
      # Gets a list deploy keys in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of issues under a project.
      #
      # ```
      # client.deploy_keys(1)
      # client.deploy_keys(1, {"per_page" => "10"})
      # ```
      def deploy_keys(project_id : Int32, params : Hash? = nil)
        JSON.parse get("/projects/#{project_id}/keys", params: params).body
      end

      # Get a deploy key in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] key_id The ID of a deploy key.
      # - return [Hash] Information about the deploy key in a project.
      #
      # ```
      # client.deploy_key(1, 1)
      # ```
      def deploy_key(project_id : Int32, key_id : Int32)
        JSON.parse get("/projects/#{project_id}/keys/#{key_id}").body
      end

      # Create a deploy key in a project.
      #
      # If the deploy key already exists in another project, it will be joined
      # to current project only if original one was is accessible by the same user.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] title The title of new deploy key.
      # - param  [String] key New deploy key.
      # - return [Hash] Information about the created deploy key in a project.
      #
      # ```
      # client.create_deploy_key(1, "deploy server", "ssh-rsa xxx")
      # ```
      def create_deploy_key(project_id : Int32, title : String, key : String)
        JSON.parse post("/projects/#{project_id}/keys", form: {
          "title" => title,
          "key"   => key,
        }.merge(params)).body
      end

      # Delete a deploy key in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] key_id The name of a deploy key.
      # - return [Hash] Information about the deleted deploy key.
      #
      # ```
      # client.remove_deploy_key(4, 3)
      # ```
      def remove_deploy_key(project_id : Int32, key_id : Int32)
        JSON.parse delete("/projects/#{project_id}/keys/#{key_id}").body
      end
    end
  end
end
