module Gitlab
  class Client
    # Defines methods related to project.
    #
    # ## Project visibility level
    #
    # Project in GitLab has be either private, internal or public. You can determine it by visibility_level field in project.
    #
    # Constants for project visibility levels are next:
    #
    # - Private. visibility_level is 0. Project access must be granted explicitly for each user.
    #
    # - Internal. visibility_level is 10. The project can be cloned by any logged in user.
    #
    # - Public. visibility_level is 20. The project can be cloned without any authentication.
    #
    # See [http://docs.gitlab.com/ce/api/projects.html](http://docs.gitlab.com/ce/api/projects.html)
    #
    module Project

      # Gets a list of projects owned by the authenticated user.
      #
      # Alias to `projects`({ "scope" => "owned" })
      #
      # ```
      # client.owned_projects
      # client.owned_projects({ "order_by" => "last_activity_at", "sort" => "desc"})
      # client.owned_projects({ "search" => "keyword" })
      # ```
      def owned_projects(params : Hash? = {} of String => String)
        projects({ "scope" => "owned" }.merge(params))
      end

      # Gets a list of projects starred by the authenticated user.
      #
      # Alias to `projects`({ "scope" => "starred" })
      #
      # ```
      # client.starred_projects
      # client.starred_projects({ "order_by" => "last_activity_at", "sort" => "desc"})
      # client.starred_projects({ "search" => "keyword" })
      # ```
      def starred_projects(params : Hash = {} of String => String)
        projects({ "scope" => "starred" }.merge(params))
      end

      # Gets a list of projects by the authenticated user (admin only).
      #
      # Alias to `projects`({ "scope" => "all" })
      #
      # ```
      # client.all_projects
      # client.all_projects({ "order_by" => "last_activity_at", "sort" => "desc"})
      # client.all_projects({ "search" => "keyword" })
      # ```
      def all_projects(params : Hash = {} of String => String)
        projects({ "scope" => "all" }.merge(params))
      end

      # Gets a list of projects by the authenticated user.
      #
      # - params  [Hash] options A customizable set of options.
      # - option params [String] :scope Scope of projects. "owned" for list of projects owned by the authenticated user, "starred" for list of projects starred by the authenticated user, "all" to get all projects (admin only)
      # - option params [String] :archived if passed, limit by archived status.
      # - option params [String] :visibility if passed, limit by visibility public, internal, private.
      # - option params [String] :order_by Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at.
      # - option params [String] :sort Return requests sorted in asc or desc order. Default is desc.
      # - option params [String] :search Return list of authorized projects according to a search criteria.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [Array<Hash>]
      #
      # ```
      # client.projects
      # client.projects({ "order_by" => "last_activity_at", "sort" => "desc"})
      # client.projects({ "scope" => "starred", "search" => "keyword" })
      # ```
      def projects(params : Hash = {} of String => String)
        scopes = %w(owned starred all)
        uri = if params.has_key?("scope") && scopes.includes?(params["scope"])
          "/projects/#{params["scope"]}"
        else
          "/projects"
        end

        get(uri, params).body
      end

      # Gets information about a project.
      #
      # - params  [Int32] project_id The ID of a project.
      # - return [Hash]
      #
      # ```
      # client.project("gitlab")
      # ```
      def project(project_id : Int32)
        get("/projects/#{project_id.to_s}").body
      end

      # Gets information about a project.
      #
      # - params  [String] project_id The ID of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [Hash]
      #
      # ```
      # client.project("gitlab")
      # ```
      def project(project_name : String)
        get("/projects/#{project_name}").body
      end

      # Gets a list of project events.
      #
      # - params  [Int32] project The ID of a project.
      # - params  [Hash] options A customizable set of options.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [Array<Hash>]
      #
      # ```
      # client.project_events(42)
      # ```
      def project_events(project_id : Int32, params : Hash? = nil)
        get("/projects/#{project_id.to_s}/events", params).body
      end

      # Gets a list of project events.
      #
      # - params  [String] project The NAMESPACE/PROJECT_NAME of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - params  [Hash] options A customizable set of options.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [Array<Hash>]
      #
      # ```
      # client.project_events(42)
      # ```
      def project_events(project_name : String, params : Hash? = nil)
        get("/projects/#{project_name}/events", params).body
      end

      # Creates a new project for a user.
      #
      # Alias to `create_project`(params : Hash = {} of String => String)
      #
      # ```
      # client.create_project(1, "gitlab")
      # client.create_project(1, "gitlab", { "description: => "Awesome project" })
      # ```
      def create_project(user_id : Int32, name : String, params : Hash = {} of String => String)
        create_project(name, {"user_id" => user_id.to_s }.merge(params))
      end

      # Creates a new project.
      #
      # - params  [String] name The name of a project.
      # - params  [Hash] options A customizable set of options.
      # - option params [String] :description The description of a project.
      # - option params [String] :default_branch The default branch of a project.
      # - option params [String] :namespace_id The namespace in which to create a project.
      # - option params [String] :wiki_enabled The wiki integration for a project (0 = false, 1 = true).
      # - option params [String] :wall_enabled The wall functionality for a project (0 = false, 1 = true).
      # - option params [String] :issues_enabled The issues integration for a project (0 = false, 1 = true).
      # - option params [String] :snippets_enabled The snippets integration for a project (0 = false, 1 = true).
      # - option params [String] :merge_requests_enabled The merge requests functionality for a project (0 = false, 1 = true).
      # - option params [String] :public The setting for making a project public (0 = false, 1 = true).
      # - option params [String] :user_id The user/owner id of a project.
      # - return [Hash] Information about created project.
      #
      # ```
      # client.create_project("gitlab")
      # client.create_project("viking", { "description: => "Awesome project" })
      # client.create_project("Red", { "wall_enabled" => "false" })
      # ```
      def create_project(name, params : Hash = {} of String => String)
        uri = if params.has_key?("user_id") && params["user_id"]
          "/projects/user/#{params[:user_id]}"
        else
          "/projects"
        end

        post(uri, { "name" => name }.merge(params)).body
      end

      # Updates an existing project.
      #
      # - params  [Int32] project The ID of a project.
      # - params  [Hash] options A customizable set of options.
      # - option params [String] :name The name of a project
      # - option params [String] :path The name of a project
      # - option params [String] :description The name of a project
      # - return [Hash] Information about the edited project.
      #
      # ```
      # client.edit_project(42)
      # client.edit_project(42, { "name" => "project_name" })
      # ```
      def edit_project(project_id, prams : Hash = {} of String  => String)
        put("/projects/#{project_id.to_s}", prams).body
      end

      # Forks a project into the user namespace.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] options A customizable set of options.
      # @option options [String] :sudo The username the project will be forked for
      # - return [Hash] Information about the forked project.
      #
      # ```
      # client.create_fork(42)
      # client.create_fork(42, { "sudo" => "another_username" })
      # ```
      def fork_project(project_id : Int32, params : Hash = {} of String  => String)
        post("/projects/fork/#{project_id.to_s}", params).body
      end

      # Star a project for the authentication user.
      #
      # - param  [Int32] project_id The ID of a project.
      # - return [Hash] Information about the starred project.
      #
      # ```
      # client.star_project(42)
      # ```
      def star_project(project_id : Int32)
        post("/projects/#{project_id.to_s}/star").body
      end

      # Unstar a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - return [Hash] Information about the unstar project.
      #
      # ```
      # client.unstar_project(42)
      # ```
      def unstar_project(project_id : Int32)
        delete("/projects/#{project_id.to_s}/star").body
      end

      # Archive a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - return [Hash] Information about the unstar project.
      #
      # ```
      # client.archive_project(42)
      # ```
      def archive_project(project_id : Int32)
        delete("/projects/#{project_id.to_s}/archive").body
      end

      # Unarchive a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - return [Hash] Information about the unstar project.
      #
      # ```
      # client.unarchive_project(42)
      # ```
      def unarchive_project(project_id : Int32)
        delete("/projects/#{project_id.to_s}/unarchive").body
      end

      # Deletes a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - return [Hash] Information about the unstar project.
      #
      # ```
      # client.delete_project(42)
      # ```
      def delete_project(project_id : Int32)
        delete("/projects/#{project_id.to_s}").body
      end

    end
  end
end
