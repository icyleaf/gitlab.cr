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
    # See http://docs.gitlab.com/ce/api/projects.html
    #
    module Project

      # Gets a list of projects owned by the authenticated user.
      #
      # Alias to projects({ "scope" => "owned" })
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
      # Alias to projects({ "scope" => "starred" })
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
      # Alias to projects({ "scope" => "all" })
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
      # @param  [Hash] options A customizable set of options.
      # @option options [String] :scope Scope of projects. 'owned' for list of projects owned by the authenticated user, 'starred' for list of projects starred by the authenticated user, 'all' to get all projects (admin only)
      # @option options [String] :archived if passed, limit by archived status.
      # @option options [String] :visibility if passed, limit by visibility public, internal, private.
      # @option options [String] :order_by Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at.
      # @option options [String] :sort Return requests sorted in asc or desc order. Default is desc.
      # @option options [String] :search Return list of authorized projects according to a search criteria.
      # @option options [Integer] :page The page number.
      # @option options [Integer] :per_page The number of results per page.
      # @return [Array<Hash>]
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
    end
  end
end
