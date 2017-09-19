module Gitlab
  class Client
    # Defines methods related to group.
    #
    # See [http://docs.gitlab.com/ce/api/groups.html](http://docs.gitlab.com/ce/api/groups.html)
    module Group
      # Gets a list of groups.
      #
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of groups
      #
      # ```
      # client.groups
      # client.groups({"per_page" => "100", "page" => "5"})
      # ```
      def groups(params : Hash? = nil)
        JSON.parse get("/groups", params: params).body
      end

      # Get a list of projects under a group
      #
      # Notes: Not all gitlab version has this api.
      #
      # - param [Int32] id The ID of a group
      # - params [Hash] params A customizable set of params.
      # - option params [String] :archived if passed, limit by archived status.
      # - option params [String] :visibility if passed, limit by visibility public, internal, private.
      # - option params [String] :order_by Return requests ordered by id, name, path, created_at, updated_at or last_activity_at fields. Default is created_at.
      # - option params [String] :sort Return requests sorted in asc or desc order. Default is desc.
      # - option params [String] :search Return list of authorized projects according to a search criteria.
      # - option params [String] :ci_enabled_first Return projects ordered by ci_enabled flag. Projects with enabled GitLab CI go first.
      # - return [Array<Hash>] List of projects under a group
      #
      # ```
      # client.group_projects(1)
      # client.group_projects(1, { "archived" => "true")
      # client.group_projects(1, { "order_by" => "last_activity_at", "sort" => "desc"})
      # ```
      def group_projects(group_id : Int32, params : Hash? = nil)
        JSON.parse get("/groups/#{group_id.to_s}/projects", params: params).body
      end

      # Gets details of a group.
      #
      # - param  [Int32|String] id The ID of a group.
      # - return [Hash] Information about group.
      #
      # ```
      # client.group(42)
      # client.group("orgination")
      # ```
      def group(group : Int32 | String)
        JSON.parse get("/groups/#{group}").body
      end

      # Creates a new group.
      #
      # - param [String] name The name of a group.
      # - param [String] path The path of a group.
      # - param [String] description The group"s description.
      # - param [String] visibility_level The group"s visibility. 0 for private, 10 for internal, 20 for public.
      # - return [Hash] Information about created group.
      #
      # ```
      # client.create_group("new-group", "group-path")
      # client.create_group("gitlab", "gitlab-path", "New Gitlab project")
      # client.create_group("gitlab", "gitlab-path", visibility_level: 0)
      # ```
      def create_group(name, path, description = nil, visibility_level : Int32? = nil)
        form = build_group_params(name, path, description, visibility_level)
        JSON.parse post("/groups", form: form).body
      end

      # Creates a new group.
      #
      # Notes: Not all gitlab version has this api.
      #
      # - param [Int32] group_id The ID of a group.
      # - param [String] name The name of a group.
      # - param [String] path The path of a group.
      # - param [String] description The group"s description.
      # - param [String] visibility_level The group"s visibility. 0 for private, 10 for internal, 20 for public.
      # - return [Hash] Information about created group.
      #
      # ```
      # client.create_group("new-group", "group-path")
      # client.create_group("gitlab", "gitlab-path", "New Gitlab project")
      # client.create_group("gitlab", "gitlab-path", {"visibility_level" => "0"})
      # ```
      def edit_group(group_id : Int32, name, path, description = nil, visibility_level : Int32? = nil)
        form = build_group_params(name, path, description, visibility_level)
        JSON.parse put("/groups/#{group_id.to_s}", form: form).body
      end

      # Delete a group.
      #
      # - param  [Int32] group_id The ID of a group
      # - return [Hash] Information about the deleted group.
      #
      # ```
      # client.delete_group(42)
      # ```
      def delete_group(group_id : Int32)
        JSON.parse delete("/groups/#{group_id.to_s}").body
      end

      # Search for groups by name
      #
      # - param  [String] query A string to search for in group names and paths.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :per_page Number of projects to return per page
      # - option params [String] :page The page to retrieve
      # - return [Array<Hash>] List of projects under search qyery
      #
      # ```
      # client.group_search("gitlab")
      # client.group_search("gitlab", {"per_page" => 50})
      # ```
      def group_search(query, params : Hash = {} of String => String)
        JSON.parse get("/groups", params: {"search" => query}.merge(params)).body
      end

      # Transfers a project to a group
      #
      # - params [Int32] group_id The ID of a group.
      # - params [Int32] project_id The ID of a project.
      #
      # ```
      # Gitlab.transfer_project_to_group(3, 50)
      # ```
      def transfer_project_to_group(group_id, project_id)
        JSON.parse post("/groups/#{group_id.to_s}/projects/#{project_id.to_s}").body
      end

      # Get a list of group members.
      #
      # - param  [Int32] id The ID of a group.
      # - param  [Hash] params A customizable set of params.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [Array<Hash>] List of group members under a group
      #
      # ```
      # client.group_members(1)
      # client.group_members(1, {"per_page" => "50"})
      # ```
      def group_members(group_id : Int32, params : Hash? = nil)
        JSON.parse get("/groups/#{group_id.to_s}/members", params: params).body
      end

      # Adds a user to group.
      #
      # - param  [Int32] group_id The group id to add a member to.
      # - param  [Int32] user_id The user id of the user to add to the team.
      # - param  [Int32] access_level Project access level.
      # - return [Hash] Information about added group member.
      #
      # ```
      # client.add_group_member(1, 2, 40)
      # ```
      def add_group_member(group_id : Int32, user_id : Int32, access_level)
        JSON.parse post("/groups/#{group_id.to_s}/members", form: {
          "user_id"      => user_id.to_s,
          "access_level" => access_level,
        }).body
      end

      # Edit a user of a group.
      #
      # - param  [Int32] group_id The group id to add a member to.
      # - param  [Int32] user_id The user id of the user to add to the team.
      # - param  [Int32] access_level Project access level.
      # - return [Hash] Information about added group member.
      #
      # ```
      # client.edit_group_member(1, 2, 40)
      # ```
      def edit_group_member(group_id : Int32, user_id : Int32, access_level)
        JSON.parse put("/groups/#{group_id}/members/#{user_id}", form: {
          "user_id"      => user_id.to_s,
          "access_level" => access_level,
        }).body
      end

      # Removes user from user group.
      #
      # - param  [Int32] group_id The group id to add a member to.
      # - param  [Int32] user_id The user id of the user to add to the team.
      # - return [Hash] Information about added group member.
      #
      # ```
      # client.remove_group_member(1, 2)
      # ```
      def remove_group_member(group_id : Int32, user_id : Int32)
        JSON.parse delete("/groups/#{group_id.to_s}/members/#{user_id.to_s}").body
      end

      private def build_group_params(name, path, description = nil, visibility_level : Int32? = nil)
        Hash(String, String).new.tap do |params|
          params["name"] = name
          params["path"] = path
          params["description"] = description if description
          params["visibility_level"] = visibility_level.to_s if visibility_level
        end
      end
    end
  end
end
