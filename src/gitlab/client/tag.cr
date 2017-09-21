module Gitlab
  class Client
    # Defines methods related to tag.
    #
    # See [http://docs.gitlab.com/ce/api/tags.html](http://docs.gitlab.com/ce/api/tags.html)
    module Tag
      # Gets a list of tags in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return [JSON::Any] List of tags under a project.
      #
      # ```
      # client.tags(1)
      # client.tags(1, {"per_page" => "10"})
      # ```
      def tags(project_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/tags", params: params).body
      end

      # Get single tag in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - return [JSON::Any] Information about the tag in a project.
      #
      # ```
      # client.tag(1, "master")
      # ```
      def tag(project_id : Int32, tag : String) : JSON::Any
        JSON.parse get("/projects/#{project_id}/repository/tags/#{tag}").body
      end

      # Create a tag in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - param  [String] ref Create tag using commit SHA, another tag name, or branch name.
      # - param  [String] form A customizable set of the params.
      # - option form  [String] :message Creates annotated tag.
      # - option  form [String] :release_description Add release notes to the git tag and store it in the GitLab database.
      # - return [JSON::Any] Information about the created tag in a project.
      #
      # ```
      # client.create_tag(1, "1.0.0", "master")
      # client.create_tag(1, "1.0.1", "1.0.0", {"message" => "message in tag", "release_description" => "message in gitlab"})
      # ```
      def create_tag(project_id : Int32, tag : String, ref : String, form : Hash = {} of String => String) : JSON::Any
        JSON.parse post("/projects/#{project_id}/repository/tags", form: {
          "tag_name" => tag,
          "ref"      => ref,
        }.merge(form)).body
      end

      # Delete a tag.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [String] tag The name of a tag.
      # - return [JSON::Any] Information about the deleted tag.
      #
      # ```
      # client.delete_tag(42)
      # ```
      def delete_tag(project_id : Int32, tag : String) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/repository/tag/#{tag}").body
      end

      # Create release notes in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - param  [String] description Release notes with markdown support.
      # - return [JSON::Any] Information about the created release notes in a project.
      #
      # ```
      # client.create_release_notes(1, "1.0.0", "Release v1.0.0")
      # ```
      def create_release_notes(project_id : Int32, tag : String, description : String) : JSON::Any
        JSON.parse post("/projects/#{project_id}/repository/tags/#{tag}/release", form: {
          "description" => description,
        }).body
      end

      # Update release notes in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] tag The name of a tag.
      # - param  [String] description Release notes with markdown support.
      # - return [JSON::Any] Information about the updated release notes in a project.
      #
      # ```
      # client.update_release_notes(1, "1.0.0", "# Release v1.0.0\n## xxx\n## xxx")
      # ```
      def update_release_notes(project_id : Int32, tag : String, description : String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/repository/tags/#{tag}/release", form: {
          "description" => description,
        }).body
      end
    end
  end
end
