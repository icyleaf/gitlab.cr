module Gitlab
  class Client
    # Defines methods related to branch.
    #
    # Every API call to issues must be authenticated.
    #
    # If a user is not a member of a project and the project is private, a GET request on that project will result to a 404 status code.
    #
    # Issues pagination
    #
    # By default, GET requests return 20 results at a time because the API results are paginated.
    #
    # Read more on [pagination](http://docs.gitlab.com/ce/api/README.html#pagination).
    #
    # See [http://docs.gitlab.com/ce/api/issues.html](http://docs.gitlab.com/ce/api/issues.html)
    module Issue
      # Gets a list of issues.
      #
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :state Return all issues or just those that are opened or closed.
      # - option params [String] :labels Return all issues or just those that are opened or closed.
      # - option params [String] :order_by Return requests ordered by created_at or updated_at fields. Default is created_at.
      # - option params [String] :sort Return requests sorted in asc or desc order. Default is desc.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of issues.
      #
      # ```
      # client.issues
      # client.issues({"per_page" => "10"})
      # ```
      def issues(params : Hash? = nil)
        JSON.parse get("/issues", params: params).body
      end

      # Gets a list isssues in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :iid Return the issue having the given iid.
      # - option params [String] :state Return all issues or just those that are opened or closed.
      # - option params [String] :labels Return all issues or just those that are opened or closed.
      # - option params [String] :milestone The milestone title.
      # - option params [String] :order_by Return requests ordered by created_at or updated_at fields. Default is created_at.
      # - option params [String] :sort Return requests sorted in asc or desc order. Default is desc.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of issues under a project.
      #
      # ```
      # client.issue(1)
      # client.issue(1, {"per_page" => "10"})
      # ```
      def issues(project_id : Int32, params : Hash? = nil)
        JSON.parse get("/projects/#{project_id}/issues", params: params).body
      end

      # Get single issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - return [Hash] Information about the issue.
      #
      # ```
      # client.issue(1, 10)
      # ```
      def issue(project_id : Int32, issue_id : Int32)
        JSON.parse get("/projects/#{project_id}/issues/#{issue_id}").body
      end

      # Create issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] title The title of an issue.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :description The description of an issue.
      # - option params [String] :assignee_id The ID of a user to assign issue.
      # - option params [String] :milestone_id The ID of a milestone to assign issue.
      # - option params [String] :labels Comma-separated label names for an issue.
      # - option params [String] :created_at Date time string, ISO 8601 formatted, e.g. 2016-03-11T03:45:40Z.
      # - return [Hash] Information about the created issue in a project.
      #
      # ```
      # client.create_issue(1, "support cli command")
      # client.create_issue(1, "error in debug mode", {"description" => "xxx"})
      # ```
      def create_issue(project_id : Int32, title : String, params : Hash = {} of String => String)
        JSON.parse post("/projects/#{project_id}/issues", form: {
          "title" => title,
        }).body
      end

      # Edit an issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :title The title of an issue.
      # - option params [String] :description The description of an issue.
      # - option params [String] :assignee_id The ID of a user to assign issue.
      # - option params [String] :milestone_id The ID of a milestone to assign issue.
      # - option params [String] :labels Comma-separated label names for an issue.
      # - option params [String] :state_event The state event of an issue. Set close to close the issue and reopen to reopen it.
      # - option params [String] :created_at Date time string, ISO 8601 formatted, e.g. 2016-03-11T03:45:40Z.
      # - return [Hash] Information about the created issue in a project.
      #
      # ```
      # client.create_issue(1, 1, "support cli command")
      # client.create_issue(1, 2, "error in debug mode", {
      #   "assignee_id"  => "3",
      #   "milestone_id" => 4,
      #   "labels"       => "bug,v1.0.0",
      # })
      # ```
      def edit_issue(project_id : Int32, issue_id : Int32, params : Hash = {} of String => String)
        JSON.parse put("/projects/#{project_id}/issues/#{issue_id}", form: params).body
      end

      # Closes an issue.
      #
      # Alias to `edit_issue`(project_id, issue_id, { "state_event" => "close" })
      #
      # - param  [Integer] project The ID of a project.
      # - param  [Integer] id The ID of an issue.
      # - return [Hash] Information about closed issue.
      #
      # ```
      # client.close_issue(1, 1)
      # ```
      def close_issue(project_id : Int32, issue_id : Int32)
        edit_issue(project_id, issue_id, {"state_event" => "close"})
      end

      # Reopens an issue.
      #
      # Alias to `edit_issue`(project_id, issue_id, { "state_event" => "reopen" })
      #
      # - param  [Integer] project The ID of a project.
      # - param  [Integer] id The ID of an issue.
      # - return [Hash] Information about closed issue.
      #
      # ```
      # client.close_issue(1, 1)
      # ```
      def reopen_issue(project, id)
        edit_issue(project_id, issue_id, {"state_event" => "reopen"})
      end

      # Delete an issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - return [Hash] Information about the deleted issue.
      #
      # ```
      # client.delete_issue(4, 3)
      # ```
      def delete_issue(project_id : Int32, issue_id : Int32)
        JSON.parse delete("/projects/#{project_id}/issues/#{issue_id}").body
      end

      # Move an issue to another project.
      #
      # - param  [Int32] project_id The ID of a project
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [Int32] to_project_id The ID of anthor to move project.
      # - return [Hash] Information about the moved issue.
      #
      # ```
      # client.move_issue(4, 3)
      # ```
      def move_issue(project_id : Int32, issue_id : Int32, to_project_id : Int32)
        JSON.parse post("/projects/#{project_id}/issues/#{issue_id}/move", form: {
          "to_project_id" => to_project_id,
        }).body
      end

      # Subscribe an issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - return [Hash] Information about the subscribed issue in a project.
      #
      # ```
      # client.subscribe_issue(1, 38)
      # ```
      def subscribe_issue(project_id : Int32, issue_id : Int32)
        JSON.parse post("/projects/#{project_id}/issues/#{issue_id}/subscription").body
      end

      # Unsubscribe an issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - return [Hash] Information about the subscribed issue in a project.
      #
      # ```
      # client.unsubscribe_issue(1, 38)
      # ```
      def unsubscribe_issue(project_id : Int32, issue_id : Int32)
        JSON.parse delete("/projects/#{project_id}/issues/#{issue_id}/subscription").body
      end
    end
  end
end
