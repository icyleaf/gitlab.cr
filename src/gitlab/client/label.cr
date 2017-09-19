module Gitlab
  class Client
    # Defines methods related to label.
    #
    # See [http://docs.gitlab.com/ce/api/labels.html](http://docs.gitlab.com/ce/api/labels.html)
    module Label
      # Gets a list labels in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [Array<Hash>] List of issues under a project.
      #
      # ```
      # client.labels(1)
      # client.labels(1, {"per_page" => "10"})
      # ```
      def labels(project_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/labels", params: params).body
      end

      # Create label in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] name The name of a label.
      # - param  [String] color The color of the label in 6-digit hex notation with leading # sign.
      # - param [String] description The description of the label.
      # - return [Hash] Information about the created label in a project.
      #
      # ```
      # client.create_label(1, "hotfix", "#E2C08D")
      # client.create_label(1, "feature", "#C678DD", "next release features")
      # ```
      def create_label(project_id : Int32, name : String, color : String, description : String? = nil) : JSON::Any
        form = Hash(String, String).new.tap do |obj|
          obj["name"] = name
          obj["color"] = color
          obj["description"] = description if description
        end

        JSON.parse post("/projects/#{project_id}/labels", form: form).body
      end

      # Edit a label in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] name The name of a label.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :new_name The new name of the label.
      # - option params [String] :color The color of the label in 6-digit hex notation with leading # sign.
      # - option params [String] :description The description of the label.
      # - return [Hash] Information about the updated label in a project.
      #
      # ```
      # client.edit_label(1, "hotfix", {"new_name" => "bugs"})
      # client.edit_label(1, "hotfix", {"color" => "#BE5046"})
      # ```
      def edit_label(project_id : Int32, name : String, form : Hash = {} of String => String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/labels", form: {
          "name" => name,
        }.merge(params)).body
      end

      # Delete a label in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] name The name of a label.
      # - return [Hash] Information about the deleted label.
      #
      # ```
      # client.delete_issue(4, 3)
      # ```
      def delete_label(project_id : Int32, name : String) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/labels", form: {"name" => name}).body
      end

      # Subscribe a label in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] label_id The ID of a label.
      # - return [Hash] Information about the subscribed label in a project.
      #
      # ```
      # client.subscribe_label(1, 38)
      # ```
      def subscribe_label(project_id : Int32, label_id : Int32) : JSON::Any
        JSON.parse post("/projects/#{project_id}/labels/#{label_id}/subscription").body
      end

      # Unsubscribe a label in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] label_id The ID of a label.
      # - return [Hash] Information about the subscribed label in a project.
      #
      # ```
      # client.unsubscribe_label(1, 38)
      # ```
      def unsubscribe_label(project_id : Int32, label_id : Int32) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/labels/#{label_id}/subscription").body
      end
    end
  end
end
