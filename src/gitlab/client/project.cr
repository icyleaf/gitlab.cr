module Gitlab
  class Client
    # Defines methods related to project.
    #
    # ### Project visibility level
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
      # client.owned_projects({"order_by" => "last_activity_at", "sort" => "desc"})
      # client.owned_projects({"search" => "keyword"})
      # ```
      def owned_projects(params : Hash? = {} of String => String) : JSON::Any
        projects({"scope" => "owned"}.merge(params))
      end

      # Gets a list of projects starred by the authenticated user.
      #
      # Alias to `projects`({ "scope" => "starred" })
      #
      # ```
      # client.starred_projects
      # client.starred_projects({"order_by" => "last_activity_at", "sort" => "desc"})
      # client.starred_projects({"search" => "keyword"})
      # ```
      def starred_projects(params : Hash = {} of String => String) : JSON::Any
        projects({"scope" => "starred"}.merge(params))
      end

      # Gets a list of projects by the authenticated user (admin only).
      #
      # Alias to `projects`({ "scope" => "all" })
      #
      # ```
      # client.all_projects
      # client.all_projects({"order_by" => "last_activity_at", "sort" => "desc"})
      # client.all_projects({"search" => "keyword"})
      # ```
      def all_projects(params : Hash = {} of String => String) : JSON::Any
        projects({"scope" => "all"}.merge(params))
      end

      # Gets single issue in the project.
      #
      # - params  [Hash] params A customizable set of params.
      # - option params [String] :scope Scope of projects. "owned" for list of projects owned by the authenticated user, "starred" for list of projects starred by the authenticated user, "all" to get all projects (admin only)
      # - option params [String] :archived if passed, limit by archived status.
      # - option params [String] :visibility if passed, limit by visibility public, internal, private.
      # - option params [String] :order_by Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at.
      # - option params [String] :sort Return requests sorted in asc or desc order. Default is desc.
      # - option params [String] :search Return list of authorized projects according to a search criteria.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [JSON::Any] List of projects of the authorized user.
      #
      # ```
      # client.projects
      # client.projects({"order_by" => "last_activity_at", "sort" => "desc"})
      # client.projects({"scope" => "starred", "search" => "keyword"})
      # ```
      def projects(params : Hash = {} of String => String) : JSON::Any
        scopes = %w(owned starred all)
        uri = if params.has_key?("scope") && scopes.includes?(params["scope"])
                "projects/#{params["scope"]}"
              else
                "projects"
              end

        get(uri, params: params).parse
      end

      # Gets information about a project.
      #
      # - params  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about project.
      #
      # ```
      # client.project("gitlab")
      # ```
      def project(project : Int32 | String) : JSON::Any
        get("projects/#{project}").parse
      end

      # Gets a list of project events.
      #
      # - params  [Int32, String] project The ID of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - params  [Hash] options A customizable set of options.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [JSON::Any] List of events under a project.
      #
      # ```
      # client.project_events(42)
      # ```
      def project_events(project : Int32 | String, params : Hash? = nil) : JSON::Any
        get("projects/#{project}/events", params: params).parse
      end

      # Creates a new project for a user.
      #
      # Alias to `create_project`(params : Hash = {} of String => String)
      #
      # ```
      # client.create_project(1, "gitlab")
      # client.create_project(1, "gitlab", { "description: => "Awesome project" })
      # ```
      def create_project(user_id : Int32, name : String, params : Hash = {} of String => String) : JSON::Any
        create_project(name, {"user_id" => user_id.to_s}.merge(params))
      end

      # Creates a new project.
      #
      # - params [String] name The name of a project.
      # - params [Hash] form A customizable set of options.
      # - option form [String] :description The description of a project.
      # - option form [String] :default_branch The default branch of a project.
      # - option form [String] :namespace_id The namespace in which to create a project.
      # - option form [String] :wiki_enabled The wiki integration for a project (0 = false, 1 = true).
      # - option form [String] :wall_enabled The wall functionality for a project (0 = false, 1 = true).
      # - option form [String] :issues_enabled The issues integration for a project (0 = false, 1 = true).
      # - option form [String] :snippets_enabled The snippets integration for a project (0 = false, 1 = true).
      # - option form [String] :merge_requests_enabled The merge requests functionality for a project (0 = false, 1 = true).
      # - option form [String] :public The setting for making a project public (0 = false, 1 = true).
      # - option form [String] :user_id The user/owner id of a project.
      # - return [JSON::Any] Information about created project.
      #
      # ```
      # client.create_project("gitlab")
      # client.create_project("viking", { "description: => "Awesome project" })
      # client.create_project("Red", { "wall_enabled" => "false" })
      # ```
      def create_project(name : String, form : Hash = {} of String => String) : JSON::Any
        uri = if user_id = form["user_id"]?
                "projects/user/#{user_id}"
              else
                "projects"
              end

        post(uri, form: form.merge({"name" => name})).parse
      end

      # Updates an existing project.
      #
      # - params [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - params [Hash] form A customizable set of options.
      # - option form [String] :name The name of a project.
      # - option form [String] :path The name of a project.
      # - option form [String] :description The name of a project.
      # - return [JSON::Any] Information about the edited project.
      #
      # ```
      # client.edit_project(42)
      # client.edit_project(42, {"name" => "project_name"})
      # ```
      def edit_project(project : Int32 | String, form : Hash = {} of String => String) : JSON::Any
        put("projects/#{project}", form: form).parse
      end

      # Forks a project into the user namespace.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] form A customizable set of options.
      # - option form [String] :sudo The username the project will be forked for.
      # - return [JSON::Any] Information about the forked project.
      #
      # ```
      # client.create_fork(42)
      # client.create_fork(42, {"sudo" => "another_username"})
      # ```
      def fork_project(project : Int32 | String, form : Hash = {} of String => String) : JSON::Any
        post("projects/#{project}/fork", form: form).parse
      end

      # Star a project for the authentication user.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about the starred project.
      #
      # ```
      # client.star_project(42)
      # ```
      def star_project(project : Int32 | String) : JSON::Any
        post("projects/#{project}/star").parse
      end

      # Unstar a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about the unstar project.
      #
      # ```
      # client.unstar_project(42)
      # ```
      def unstar_project(project : Int32 | String) : JSON::Any
        delete("projects/#{project}/star").parse
      end

      # Archive a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about the archive project.
      #
      # ```
      # client.archive_project(42)
      # ```
      def archive_project(project : Int32 | String) : JSON::Any
        delete("projects/#{project}/archive").parse
      end

      # Unarchive a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about the unarchive project.
      #
      # ```
      # client.unarchive_project(42)
      # ```
      def unarchive_project(project : Int32 | String) : JSON::Any
        delete("projects/#{project}/unarchive").parse
      end

      # Share a project with a group.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] options A customizable set of options.
      # - option options [String] :sudo The username the project will be forked for.
      # - return [JSON::Any] Information about the share project.
      #
      # ```
      # client.share_project(2, 1)
      # client.share_project(2, 1, {"group_access" => "50"})
      # ```
      def share_project(project : Int32 | String, group_id : Int32, group_access = nil) : JSON::Any
        form = {"group_id" => group_id}
        form["group_access"] = group_access if group_access

        post("projects/#{project}/share", form: form).parse
      end

      # Search for project by name
      #
      # - param  [String] query A string to search for in group names and paths.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :per_page Number of projects to return per page.
      # - option params [String] :page The page to retrieve.
      # - option params [String] :order_by Return requests ordered by id, name, created_at or last_activity_at fields.
      # - option params [String] :sort Return requests sorted in asc or desc order.
      # - return [JSON::Any] List of projects under search qyery.
      #
      # ```
      # client.project_search("gitlab")
      # client.project_search("gitlab", {"per_page" => 50})
      # ```
      def project_search(query, params : Hash = {} of String => String) : JSON::Any
        get("projects", params: params.merge({"search" => query})).parse
      end

      # Deletes a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about the deleted project.
      #
      # ```
      # client.delete_project(42)
      # ```
      def delete_project(project : Int32 | String) : JSON::Any
        delete("projects/#{project}").parse
      end

      # Get a list of a project's team members.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] options A customizable set of options.
      # - option options [String] :query The search query.
      # - option options [Int32] :page The page number.
      # - option options [Int32] :per_page The number of results per page.
      # - return [JSON::Any] List of team members under a project.
      #
      # ```
      # client.project_members(42)
      # client.project_members('gitlab')
      # ```
      def project_members(project : Int32 | String, params : Hash = {} of String => String) : JSON::Any
        get("projects/#{project}/members", params: params).parse
      end

      # Gets a project team member.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] user_id The ID of a project team member.
      # - return [JSON::Any] Information about member under a project.
      #
      # ```
      # client.project_member(1, 2)
      # ```
      def project_member(project : Int32 | String, user_id : Int32) : JSON::Any
        get("projects/#{project}/members/#{user_id}").parse
      end

      # Adds a user to project team.
      #
      # - param  [Int32, String] project_id The ID or name of a project.
      # - param  [Int32] user_id The ID of a user.
      # - param  [Int32] access_level The access level to project.
      # - return [JSON::Any] Information about added team member.
      #
      # ```
      # client.add_project_member('gitlab', 2, 40)
      # ```
      def add_project_member(project : Int32 | String, user_id : Int32, access_level : Int32) : JSON::Any
        post("projects/#{project}/members", form: {
          "user_id"      => user_id.to_s,
          "access_level" => access_level.to_s,
        }).parse
      end

      # Updates a team member's project access level.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] user_id The ID of a user.
      # - param  [Int32] access_level The access level to project.
      # - return [JSON::Any] Information about updated team member.
      #
      # ```
      # client.edit_project_member('gitlab', 3, 20)
      # ```
      def edit_project_member(project : Int32 | String, user_id, access_level) : JSON::Any
        put("projects/#{project}/members/#{user_id}", form: {
          "access_level" => access_level,
        }).parse
      end

      # Removes a user from project team.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] user_id The ID of a user.
      # - return [JSON::Any] Information about removed team member.
      #
      # ```
      # client.remove_project_member('gitlab', 2)
      # ```
      def remove_project_member(project : Int32 | String, user_id : Int32) : JSON::Any
        delete("projects/#{project}/members/#{user_id}").parse
      end

      # Get a list of a project's pages domains.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] List of pages domains under a project.
      #
      # ```
      # client.project_pages_domains(42)
      # client.project_pages_domains('gitlab')
      # ```
      def project_pages_domains(project : Int32 | String) : JSON::Any
        get("projects/#{project}/pages/domains").parse
      end

      # Gets a project pages domain.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [String] The custom domain.
      # - return [JSON::Any] Information about pages domain under a project.
      #
      # ```
      # client.project_pages_domain(1, "pages-domain.com")
      # ```
      def project_pages_domain(project : Int32 | String, domain : String) : JSON::Any
        get("projects/#{project}/pages/domains/#{domain}").parse
      end

      # Adds a pages domain to project.
      #
      # - param  [Int32, String] project_id The ID or name of a project.
      # - param  [String] domain The custom domain.
      # - params [Hash] form A customizable set of options.
      # - option form [Bool] :auto_ssl_enabled Enables automatic generation of SSL certificates issued by Let’s Encrypt for custom domains.
      # - option form [String] :certificate The certificate in PEM format with intermediates following in most specific to least specific order.
      # - option form [String] :key The certificate key in PEM format.
      # - return [JSON::Any] Information about added pages domain.
      #
      # ```
      # client.add_project_pages_domain('gitlab', "pages-domain.com", {"auto_ssl_enabled" => true})
      # ```
      def add_project_pages_domain(project : Int32 | String, domain : String, form : Hash = {} of String => String) : JSON::Any
        post("projects/#{project}/pages/domains", form: form.merge({ "domain" => domain })).parse
      end

      # Updates a pages domain project.
      #
      # - param  [Int32, String] project_id The ID or name of a project.
      # - param  [String] domain The custom domain.
      # - params [Hash] form A customizable set of options.
      # - option form [Bool] :auto_ssl_enabled Enables automatic generation of SSL certificates issued by Let’s Encrypt for custom domains.
      # - option form [String] :certificate The certificate in PEM format with intermediates following in most specific to least specific order.
      # - option form [String] :key The certificate key in PEM format.
      # - return [JSON::Any] Information about added pages domain.
      #
      # ```
      # client.edit_project_pages_domain('gitlab', "pages-domain.com", {"auto_ssl_enabled" => true})
      # ```
      def edit_project_pages_domain(project : Int32 | String, domain : String, form : Hash = {} of String => String) : JSON::Any
        put("projects/#{project}/pages/domains", form: form.merge({ "domain" => domain })).parse
      end

      # Removes a pages domain from project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [String] domain The custom domain.
      # - return [JSON::Any] Information about removed team member.
      #
      # ```
      # client.remove_project_pages_domain(1, "pages-domain.com")
      # ```
      def remove_project_pages_domain(project : Int32 | String, domain : String) : JSON::Any
        delete("projects/#{project}/pages/domains/#{domain}").parse
      end

      # Get a list of a project's web hooks.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] params A customizable set of options.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [JSON::Any] List of web hooks under a project.
      #
      # ```
      # client.project_hooks(42)
      # client.project_hooks('gitlab', { "per_page" => "4" })
      # ```
      def project_hooks(project : Int32 | String, params : Hash? = nil) : JSON::Any
        get("projects/#{project}/hooks", params: params).parse
      end

      # Get a web hook of a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] hook_id The ID of a web hook.
      # - return [JSON::Any] Information about the web hook.
      #
      # ```
      # client.project_hook(42)
      # client.project_hook('gitlab', 1)
      # ```
      def project_hook(project : Int32 | String, hook_id : Int32) : JSON::Any
        get("projects/#{project}/hooks/#{hook_id}").parse
      end

      # Create a web hook of a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [String] url The url of a web hook.
      # - param  [Hash] form A customizable set of options.
      # - option form [String] :push_events Trigger hook on push events.
      # - option form [String] :issues_events Trigger hook on issues events.
      # - option form [String] :merge_requests_events Trigger hook on merge_requests events.
      # - option form [String] :tag_push_events Trigger hook on push_tag events.
      # - option form [String] :note_events Trigger hook on note events.
      # - option form [String] :enable_ssl_verification Do SSL verification when triggering the hook.
      # - return [JSON::Any] Information about the created web hook.
      #
      # ```
      # client.add_project_hook(42, "https://hooks.slack.com/services/xxx")
      # client.add_project_hook('gitlab', "https://hooks.slack.com/services/xxx", { "issues_events" => "true" })
      # ```
      def add_project_hook(project : Int32 | String, url : String, form : Hash = {} of String => String) : JSON::Any
        post("projects/#{project}/hooks", form: form.merge({"url" => url})).parse
      end

      # Updates a web hook of a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] hook_id The ID of a web hook.
      # - param  [Int32] url The url of a web hook.
      # - param  [Hash] form A customizable set of options.
      # - option form [String] :push_events Trigger hook on push events.
      # - option form [String] :issues_events Trigger hook on issues events.
      # - option form [String] :merge_requests_events Trigger hook on merge_requests events.
      # - option form [String] :tag_push_events Trigger hook on push_tag events.
      # - option form [String] :note_events Trigger hook on note events.
      # - option form [String] :enable_ssl_verification Do SSL verification when triggering the hook.
      # - return [JSON::Any] Information about updated web hook.
      #
      # ```
      # client.edit_project_hook('gitlab', 3, "https://hooks.slack.com/services/xxx")
      # ```
      def edit_project_hook(project : Int32 | String, hook_id : Int32, url : String, form : Hash = {} of String => String) : JSON::Any
        put("projects/#{project}/hooks/#{hook_id}", form: form.merge({"url" => url})).parse
      end

      # Removes a user from project team.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] hook_id The ID of a web hook.
      # - return [JSON::Any | Nil] Information about removed web hook.
      #
      # ```
      # client.remove_project_hook('gitlab', 2)
      # client.remove_project_hook(1, 2)
      # ```
      def remove_project_hook(project : Int32 | String, hook_id : Int32) : JSON::Any?
        body = delete("projects/#{project}/hooks/#{hook_id}").body
        JSON.parse(body) unless body.empty?
      end

      # Get a list of a project's branches.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] options A customizable set of options.
      # - option options [Int32] :page The page number.
      # - option options [Int32] :per_page The number of results per page.
      # - return [JSON::Any] List of branches under a project.
      #
      # ```
      # client.project_branchs(42)
      # client.project_branchs('gitlab', { "per_page" => "4" })
      # ```
      def project_branchs(project : Int32 | String, params : Hash = {} of String => String) : JSON::Any
        get("projects/#{project}/repository/branches", params: params).parse
      end

      # Get a branch of a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Int32] branch The name of a branch.
      # - return [JSON::Any] Information about the branch under a project.
      #
      # ```
      # client.project_branch(42)
      # client.project_branch('gitlab', "develop")
      # ```
      def project_branch(project : Int32 | String, branch : String) : JSON::Any
        get("projects/#{project}/repository/branches/#{branch}").parse
      end

      # Protect a branch of a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] branch The name of a branch.
      # - return [JSON::Any] Information about the protected branch.
      #
      # ```
      # client.protect_project_branch(2, "master")
      # client.protect_project_branch("gitlab", "master")
      # ```
      def protect_project_branch(project : Int32 | String, branch : String) : JSON::Any
        put("projects/#{project}/repository/branches/#{branch}/protect").parse
      end

      # Unprotect a branch of a project.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] branch The name of a branch.
      # - return [JSON::Any] Information about the unprotect branch.
      #
      # ```
      # client.unprotect_project_branch(2, "master")
      # client.unprotect_project_branch("gitlab", "master")
      # ```
      def unprotect_project_branch(project : Int32 | String, branch : String) : JSON::Any
        put("projects/#{project}/repository/branches/#{branch}/unprotect").parse
      end

      # Create a forked from/to relation between existing projects. Available only for admins.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [Hash] branch The name of a branch.
      # - return [JSON::Any] Information about the forked project.
      #
      # ```
      # client.create_fork_from(1, 21)
      # ```
      def create_fork_from(project : Int32 | String, forked_from_id : Int32) : JSON::Any
        post("projects/#{project}/fork/#{forked_from_id}").parse
      end

      # Delete an existing forked from relationship. Available only for admins.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - return [JSON::Any] Information about the unforked project.
      #
      # ```
      # client.remove_fork(1)
      # ```
      def remove_fork(project : Int32 | String) : JSON::Any
        delete("projects/#{project}/fork").parse
      end

      # Upload a file in a project
      #
      # Uploads a file to the specified project to be used in an issue or merge request description, or a comment.
      #
      # **Note**: The returned url is relative to the project path. In Markdown contexts, the link is automatically expanded when the format in markdown is used.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [String] file The path of a file.
      # - return [JSON::Any] Information about the uploaded file.
      #
      # ```
      # client.upload_file(1, "/Users/icyleaf/Desktop/snippets_ruby.rb")
      # client.upload_file(1, "/Users/icyleaf/Desktop/screenshot.png")
      # client.upload_file(1, "/Users/icyleaf/Desktop/archive.zip")
      # ```
      def upload_file(project : Int32 | String, file : String) : JSON::Any
        post("projects/#{project}/uploads", form: {"file" => File.open(file)}).parse
      end

      # Same as `upload_file`
      def upload_file(project : Int32 | String, file : File) : JSON::Any
        post("projects/#{project}/uploads", form: {"file" => file}).parse
      end

      # List project custom attributes
      #
      # **Available only for admin**.
      #
      # - param [Int32] project_id The Id of project
      # - return [JSON::Any] information about the custom_attribute
      #
      # ```
      # client.project_custom_attributes(4)
      # ```
      def project_custom_attributes(project_id : Int32 ) : JSON::Any
        get("projects/#{project_id.to_s}/custom_attributes").parse
      end

      # Add's a project custom attribute
      #
      # **Available only for admin**.
      #
      # - param [Int32] project_id The Id of project
      # - param [String] the key of the custom attribute
      # - param  [Hash] params A single param with the value of the custom attribute
      # - params [String] :value The value of the custom attribute.
      # - return [JSON::Any] information about the custom_attribute
      #
      # ```
      # client.project_add_custom_attribute(4, custom_key, {"value"=> "custom_value"})
      # ```
      def project_add_custom_attribute(project_id : Int32, key : String, params : Hash = {} of String => String ) : JSON::Any
        put("projects/#{project_id.to_s}/custom_attributes/#{key}", form: params).parse
      end

      # Deletes a project custom attribute
      #
      # **Available only for admin**.
      #
      # - param [Int32] project_id The Id of project
      # - param [String] the key of the custom attribute
      # - return [JSON::Any] information about the custom_attribute
      #
      # ```
      # client.project_delete_custom_attribute(4, custom_key)
      # ```
      def project_delete_custom_attribute(project_id : Int32, key : String) : JSON::Any
        delete("projects/#{project_id.to_s}/custom_attributes/#{key}").parse
      end

    end
  end
end
