module Gitlab
  class Client
    # Defines methods related to note.
    #
    # Notes are comments on snippets, issues or merge requests..
    #
    # See [http://docs.gitlab.com/ce/api/notes.html](http://docs.gitlab.com/ce/api/notes.html)
    module Note
      # Gets a list notes of issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return JSON::Any List of notes of issue under a project.
      #
      # ```
      # client.issue_notes(1, 1)
      # client.issue_notes(1, 5, {"per_page" => "10"})
      # ```
      def issue_notes(project_id : Int32, issue_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/issues/#{issue_id}/notes", params: params).body
      end

      # Get single note of issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [Int32] note_id The ID of a note.
      # - return [Hash] Information about the note of issue.
      #
      # ```
      # client.issue_note(1, 10)
      # ```
      def issue_note(project_id : Int32, issue_id : Int32, note_id : Int32) : JSON::Any
        JSON.parse get("/projects/#{project_id}/issues/#{issue_id}/notes/#{note_id}").body
      end

      # Create note of issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [String] body The body of a note.
      # - params [String] created_at Date time string, ISO 8601 formatted, e.g. 2016-03-11T03:45:40Z.
      # - return [Hash] Information about the created note of issue in a project.
      #
      # ```
      # client.create_issue_note(1, 10, "great work!")
      # client.create_issue_note(1, 12, "great work!", "2016-03-11T03:45:40Z")
      # ```
      def create_issue_note(project_id : Int32, issue_id : Int32, body : String, created_at : String? = nil) : JSON::Any
        form = Hash(String, String).new.tap do |obj|
          obj["body"] = body
          obj["created_at"] = created_at if created_at
        end

        JSON.parse post("/projects/#{project_id}/issues/#{issue_id}/notes", form: form).body
      end

      # Edit a note of issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [Int32] note_id The ID of a note.
      # - param  [String] body The body of a note.
      # - return [Hash] Information about the updated issue in a project.
      #
      # ```
      # client.edit_issue_note(1, 10, 22, "great work!")
      # ```
      def edit_issue_note(project_id : Int32, issue_id : Int32, note_id : Int32, body : String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/issues/#{issue_id}/notes/#{note_id}", form: {
          "body" => body,
        }).body
      end

      # Deiete a note of issue in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] issue_id The ID of an issue.
      # - param  [Int32] note_id The ID of a note.
      # - return [Hash] Information about the deleted note of issue.
      #
      # ```
      # client.delete_issue_note(1, 3, 6)
      # ```
      def delete_issue_note(project_id : Int32, issue_id : Int32, note_id : Int32) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/issues/#{issue_id}/notes/#{note_id}").body
      end

      # Gets a list notes of snippet in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] snippet_id The ID of an snippet.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return JSON::Any List of notes of snippet under a project.
      #
      # ```
      # client.snippet_notes(1, 1)
      # client.snippet_notes(1, 5, {"per_page" => "10"})
      # ```
      def snippet_notes(project_id : Int32, snippet_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/snippets/#{snippet_id}/notes", params: params).body
      end

      # Get single note of snippet in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] snippet_id The ID of an snippet.
      # - param  [Int32] note_id The ID of a note.
      # - return [Hash] Information about the note of snippet.
      #
      # ```
      # client.snippet_note(1, 10)
      # ```
      def snippet_note(project_id : Int32, snippet_id : Int32, note_id : Int32) : JSON::Any
        JSON.parse get("/projects/#{project_id}/snippets/#{snippet_id}/notes/#{note_id}").body
      end

      # Create note of snippet in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] snippet_id The ID of an snippet.
      # - param  [String] body The body of an snippet.
      # - return [Hash] Information about the created note of snippet in a project.
      #
      # ```
      # client.create_snippet_note(1, 10, "great work!")
      # ```
      def create_snippet_note(project_id : Int32, snippet_id : Int32, body : String) : JSON::Any
        JSON.parse post("/projects/#{project_id}/snippets/#{snippet_id}/notes", form: {"body" => body}).body
      end

      # Edit a note of snippet in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] snippet_id The ID of an snippet.
      # - param  [Int32] note_id The ID of a note.
      # - param  [String] body The body of an snippet.
      # - return [Hash] Information about the updated snippet in a project.
      #
      # ```
      # client.edit_snippet_note(1, 10, 22, "great work!")
      # ```
      def edit_snippet_note(project_id : Int32, snippet_id : Int32, note_id : Int32, body : String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/snippets/#{snippet_id}/notes/#{note_id}", form: {
          "body" => body,
        }).body
      end

      # Deiete a note of snippet in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] snippet_id The ID of an snippet.
      # - param  [Int32] note_id The ID of a note.
      # - return [Hash] Information about the deleted note of snippet.
      #
      # ```
      # client.delete_snippet_note(1, 3, 6)
      # ```
      def delete_snippet_note(project_id : Int32, snippet_id : Int32, note_id : Int32) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/snippets/#{snippet_id}/notes/#{note_id}").body
      end

      # Gets a list notes of merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of a merge request.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :page The page number.
      # - option params [String] :per_page The number of results per page. default is 20
      # - return JSON::Any List of notes of merge request under a project.
      #
      # ```
      # client.merge_request_notes(1, 1)
      # client.merge_request_notes(1, 5, {"per_page" => "10"})
      # ```
      def merge_request_notes(project_id : Int32, merge_request_id : Int32, params : Hash? = nil) : JSON::Any
        JSON.parse get("/projects/#{project_id}/merge_requests/#{merge_request_id}/notes", params: params).body
      end

      # Get single note of merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of a merge request.
      # - param  [Int32] note_id The ID of a note.
      # - return [Hash] Information about the note of merge request.
      #
      # ```
      # client.merge_request_note(1, 10)
      # ```
      def merge_request_note(project_id : Int32, merge_request_id : Int32, note_id : Int32) : JSON::Any
        JSON.parse get("/projects/#{project_id}/merge_requests/#{merge_request_id}/notes/#{note_id}").body
      end

      # Create note of merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of a merge request.
      # - param  [String] body The title of an merge_requests.
      # - return [Hash] Information about the created note of merge request in a project.
      #
      # ```
      # client.create_merge_request_note(1, 10, "great work!")
      # ```
      def create_merge_request_note(project_id : Int32, merge_request_id : Int32, body : String, created_at : String? = nil) : JSON::Any
        JSON.parse post("/projects/#{project_id}/merge_requests/#{merge_request_id}/notes", form: {"body" => body}).body
      end

      # Edit a note of merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of an merge request.
      # - param  [Int32] note_id The ID of a note.
      # - param  [String] body The title of a merge request.
      # - return [Hash] Information about the updated merge request in a project.
      #
      # ```
      # client.edit_merge_request_note(1, 10, 22, "great work!")
      # ```
      def edit_merge_request_note(project_id : Int32, merge_requests_id : Int32, note_id : Int32, body : String) : JSON::Any
        JSON.parse put("/projects/#{project_id}/merge_requests/#{merge_requests_id}/notes/#{note_id}", form: {
          "body" => body,
        }).body
      end

      # Deiete a note of merge request in a project.
      #
      # - param  [Int32] project_id The ID of a project.
      # - param  [Int32] merge_request_id The ID of a merge request.
      # - param  [Int32] note_id The ID of a note.
      # - return [Hash] Information about the deleted note of merge request.
      #
      # ```
      # client.delete_merge_request_note(1, 3, 6)
      # ```
      def delete_merge_request_note(project_id : Int32, merge_request_id : Int32, note_id : Int32) : JSON::Any
        JSON.parse delete("/projects/#{project_id}/merge_requestss/#{merge_request_id}/notes/#{note_id}").body
      end
    end
  end
end
