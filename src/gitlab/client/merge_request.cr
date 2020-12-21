module Gitlab
  class Client
    # Defines methods related to merge request.
    #
    # See [http://docs.gitlab.com/ce/api/merge_requests.html](http://docs.gitlab.com/ce/api/merge_requests.html)
    module MergeRequest
      # List merge requests in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [Int32] :iid Return the request having the given iid.
      # - option params [String] :state Return all requests or just those that are merged, opened or closed.
      # - option params [String] :order_by Return requests ordered by created_at or updated_at fields. Default is created_at
      # - option params [String] :sort Return requests sorted in asc or desc order. Default is desc
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [JSON::Any] List of merge requests under a project.
      #
      # ```
      # client.merge_requests(1)
      # client.merge_requests(1, {"state" => "opened", "per_page" => "10"})
      # ```
      def merge_requests(project_id : Int32, params : Hash? = nil) : JSON::Any
        get("projects/#{project_id}/merge_requests", params: params).parse
      end

      # Get a single merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of a merge request.
      # - return [JSON::Any] Information about the merge request.
      #
      # ```
      # client.merge_request(1, 10)
      # ```
      def merge_request(project_id : Int32, merge_request_id : Int32) : JSON::Any
        get("projects/#{project_id}/merge_requests/#{merge_request_id}").parse
      end

      # List commits of merge requests in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Integer] id The ID of a merge request.
      #
      # ```
      # client.merge_request_commits(1, 2)
      # ```
      def merge_request_commits(project_id : Int32, merge_request_id : Int32) : JSON::Any
        get("projects/#{project_id}/merge_requests/#{merge_request_id}/commits").parse
      end

      # Create a merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] source_branch The name of a source branch.
      # - param  [String] target_branch The name of a target branch.
      # - param  [String] title The title of a merge request.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :assignee_id The ID pf assignee user.
      # - option params [String] :description The description of the merge request.
      # - option params [String] :target_project_id The target project (numeric id).
      # - option params [String] :labels Labels for MR as a comma-separated list.
      # - option params [String] :milestone_id The ID of the milestone.
      # - return [JSON::Any] Information about the created merge_request in a project.
      #
      # ```
      # client.create_merge_request(1, "feature/xxx", "develop", "feature: support xxx")
      # client.create_merge_request(1, "hotfix/xxx", "master", "fix some bugs", {"milestone_id" => "2"})
      # ```
      def create_merge_request(project_id : Int32, source_branch : String, target_branch : String, title : String, params : Hash = {} of String => String) : JSON::Any
        post("projects/#{project_id}/merge_requests", form: {
          "source_branch" => source_branch,
          "target_branch" => target_branch,
          "title"         => title,
        }.merge(params)).parse
      end

      # Edit a merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of a merge request.
      # - param  [String] source_branch The name of a source branch.
      # - param  [String] target_branch The name of a target branch.
      # - param  [String] title The title of a merge request.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :assignee_id The ID pf assignee user.
      # - option params [String] :description The description of the merge request.
      # - option params [String] :target_project_id The target project (numeric id).
      # - option params [String] :state_event New state (close|reopen|merge).
      # - option params [String] :labels Labels for MR as a comma-separated list.
      # - option form [String] :milestone_id The ID of the milestone.
      # - return [JSON::Any] Information about the created merge request in a project.
      #
      # ```
      # client.create_merge_request(1, 4, "feature/xxx", "develop", "feature: support xxx")
      # client.create_merge_request(1, 6, "hotfix/xxx", "master", "fix some bugs", {"state" => "close"})
      # ```
      def edit_merge_request(project_id : Int32, merge_request_id : Int32, source_branch : String, target_branch : String, title : String, form : Hash = {} of String => String) : JSON::Any
        put("projects/#{project_id}/merge_requests/#{merge_request_id}", form: {
          "source_branch" => source_branch,
          "target_branch" => target_branch,
          "title"         => title,
        }.merge(form)).parse
      end

      # Deiete a merge request in a project.
      #
      # Only for admins and project owners. Soft deletes the merge request in question.
      # If the operation is successful, a status code 200 is returned.
      # In case you cannot destroy this merge request, or it is not present, code 404 is given.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - return [JSON::Any] Information about the deleted merge requet.
      #
      # ```
      # client.delete_merge_request(1, 3, 6)
      # ```
      def delete_merge_request(project_id : Int32, merge_request_id : Int32) : JSON::Any | Bool
        response = delete("projects/#{project_id}/merge_requests/#{merge_request_id}")
        return true if response.status_code == 204
        response.parse
      end

      # List changes of a merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [JSON::Any] List of issues of merge request under a project.
      #
      # ```
      # client.merge_request_changes(1, 3)
      # client.merge_request_changes(1, 4, {"per_page" => "5"})
      # ```
      def merge_request_changes(project_id : Int32, merge_request_id : Int32, params : Hash = {} of String => String) : JSON::Any
        get("projects/#{project_id}/merge_requests/#{merge_request_id}/changes", params: params).parse
      end

      # Updates a merge request.
      #
      # - param  [Integer] project The ID or name of a project.
      # - param  [Integer] id The ID of a merge request.
      # - param  [Hash] form A customizable set of options.
      # - option form [String] :title The title of a merge request.
      # - option form [String] :source_branch The source branch name.
      # - option form [String] :target_branch The target branch name.
      # - option form [Integer] :assignee_id The ID of a user to assign merge request.
      # - option form [String] :state_event New state (close|reopen|merge).
      #
      # ```
      # client.update_merge_request(5, 42, { title: 'New title' })
      # ```
      def update_merge_request(project_id : Int32, merge_request_id, form : Hash? = nil)
        put("projects/#{project_id}/merge_requests/#{merge_request_id}", form: form).parse
      end

      # Accept a merge request in a project.
      #
      # Merge changes submitted with MR using this API.
      #
      # If the merge succeeds you'll get a 200 OK.
      #
      # If it has some conflicts and can not be merged - you'll get a 405 and the error message 'Branch cannot be merged'
      #
      # If merge request is already merged or closed - you'll get a 406 and the error message 'Method Not Allowed'
      #
      # If the sha parameter is passed and does not match the HEAD of the source - you'll get a 409 and the error message 'SHA does not match HEAD of source branch'
      #
      # If you don't have permissions to accept this merge request - you'll get a 401
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - return [JSON::Any] Information about the accepted merge requet.
      #
      # ```
      # client.accept_merge_request(1, 3)
      # ```
      def accept_merge_request(project_id : Int32, merge_request_id : Int32, form : Hash? = nil) : JSON::Any
        put("projects/#{project_id}/merge_requests/#{merge_request_id}/merge", form: form).parse
      end

      # Cancel merge request when build succeeds in a project.
      #
      # If successful you'll get 200 OK.
      #
      # If you don't have permissions to accept this merge request - you'll get a 401
      #
      # If the merge request is already merged or closed - you get 405 and error message 'Method Not Allowed'
      #
      # In case the merge request is not set to be merged when the build succeeds, you'll also get a 406 error.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - return [JSON::Any] Information about the accepted merge requet.
      #
      # ```
      # client.cancel_merge_request_when_build_succeed(1, 3)
      # ```
      def cancel_merge_request_when_build_succeed(project_id : Int32, merge_request_id : Int32) : JSON::Any
        put("projects/#{project_id}/merge_requests/#{merge_request_id}/cancel_merge_when_build_succeeds").parse
      end

      # List issues that will close on merge in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [JSON::Any] List of issues of merge request under a project.
      #
      # ```
      # client.merge_request_closes_issues(1, 3)
      # client.merge_request_closes_issues(1, 4, {"per_page" => "5"})
      # ```
      def merge_request_closes_issues(project_id : Int32, merge_request_id : Int32, params : Hash = {} of String => String) : JSON::Any
        get("projects/#{project_id}/merge_requests/#{merge_request_id}/closes_issues", params: params).parse
      end

      # Subscribe a merge request in a project.
      #
      # Subscribes the authenticated user to a merge request to receive notification. If the operation is successful, status code 201 together with the updated merge request is returned. If the user is already subscribed to the merge request, the status code 304 is returned. If the project or merge request is not found, status code 404 is returned.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - return [JSON::Any] Information about the subscribed merge request in a project.
      #
      # ```
      # client.subscribe_merge_request(1, 38)
      # ```
      def subscribe_merge_request(project_id : Int32, merge_request_id : Int32) : JSON::Any
        post("projects/#{project_id}/merge_requests/#{merge_request_id}/subscribe").parse
      end

      # Unsubscribe a merge request in a project.
      #
      # Unsubscribes the authenticated user from a merge request to not receive notifications from that merge request. If the operation is successful, status code 200 together with the updated merge request is returned. If the user is not subscribed to the merge request, the status code 304 is returned. If the project or merge request is not found, status code 404 is returned.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge_request.
      # - return [JSON::Any] Information about the subscribed merge request in a project.
      #
      # ```
      # client.unsubscribe_merge_request(1, 38)
      # ```
      def unsubscribe_merge_request(project_id : Int32, merge_request_id : Int32) : JSON::Any
        post("projects/#{project_id}/merge_requests/#{merge_request_id}/unsubscribe").parse
      end
    end
  end
end
