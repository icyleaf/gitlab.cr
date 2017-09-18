module Gitlab
  class Client
    # Defines methods related to milestone.
    #
    # See [http://docs.gitlab.com/ce/api/milestones.html](http://docs.gitlab.com/ce/api/milestones.html)
    module Milestone
      # List milestones in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [Int32] :iid Return only the milestone having the given iid.
      # - option params [String] :state Return only active or closed milestones.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of milestones under a project.
      #
      # ```
      # client.milestones(1)
      # client.milestones(1, {"state" => "active", "per_page" => "10"})
      # ```
      def milestones(project_id : Int32, params : Hash? = nil)
        JSON.parse get("/projects/#{project_id}/milestones", params: params).body
      end

      # Get a single milestone in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] milestone_id The ID of a milestone.
      # - return [Hash] Information about the milestone.
      #
      # ```
      # client.milestone(1, 10)
      # ```
      def milestone(project_id : Int32, milestone_id : Int32)
        JSON.parse get("/projects/#{project_id}/milestones/#{milestone_id}").body
      end

      # Create a milestone in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] title The title of a milestone.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :description The description of the milestone.
      # - option params [String] :due_date The due date of the milestone.
      # - return [Hash] Information about the created milestone in a project.
      #
      # ```
      # client.create_milestone(1, "v2.0")
      # client.create_milestone(1, "v2.0.1", "fix some bugs")
      # ```
      def create_milestone(project_id : Int32, title : String, params : Hash = {} of String => String)
        JSON.parse post("/projects/#{project_id}/milestones", form: {
          "title" => title,
        }.merge(params)).body
      end

      # Edit a milestone in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] milestone_id The ID of a milestone.
      # - param  [String] title The title of a milestone.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :description The description of the milestone.
      # - option params [String] :due_date The due date of the milestone.
      # - return [Hash] Information about the created milestone in a project.
      #
      # ```
      # client.edit_milestone(1, "v2.0")
      # client.edit_milestone(1, "v2.0.1", "fix some bugs")
      # ```
      def edit_milestone(project_id : Int32, milestone_id : Int32, title : String, params : Hash = {} of String => String)
        JSON.parse put("/projects/#{project_id}/milestones/#{milestone_id}", form: {
          "title" => title,
        }.merge(params)).body
      end

      # List issues of a milestone in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] milestone_id The ID of a milestone.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of issues of milestone under a project.
      #
      # ```
      # client.milestone_issues(1, 3)
      # client.milestone_issues(1, 4, {"per_page" => "5"})
      # ```
      def milestone_issues(project_id : Int32, milestone_id : Int32, params : Hash = {} of String => String)
        JSON.parse get("/projects/#{project_id}/milestones/#{milestone_id}/issues", params: params).body
      end
    end
  end
end
