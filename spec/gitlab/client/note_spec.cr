require "../../spec_helper"

Spec2.describe Gitlab::Client::Note do
  describe "notes" do
    context "when issue notes" do
      it "should return a paginated response of notes" do
        stub_get("/projects/3/issues/7/notes", "notes")
        notes = client.issue_notes(3, 7)

        expect(notes).to be_a JSON::Any
        expect(notes[0]["author"]["name"].as_s).to eq "John Smith"
      end
    end

    context "when snippet notes" do
      it "should return a paginated response of notes" do
        stub_get("/projects/3/snippets/7/notes", "notes")
        notes = client.snippet_notes(3, 7)

        expect(notes).to be_a JSON::Any
        expect(notes[0]["author"]["name"].as_s).to eq "John Smith"
      end
    end

    context "when merge_request notes" do
      it "should return a paginated response of notes" do
        stub_get("/projects/3/merge_requests/7/notes", "notes")
        notes = client.merge_request_notes(3, 7)

        expect(notes).to be_a JSON::Any
        expect(notes[0]["author"]["name"].as_s).to eq "John Smith"
      end
    end
  end

  describe "note" do
    context "when issue note" do
      it "should return information about a note" do
        stub_get("/projects/3/issues/7/notes/1201", "note")
        note = client.issue_note(3, 7, 1201)

        expect(note["body"].as_s).to eq "The solution is rather tricky"
        expect(note["author"]["name"].as_s).to eq "John Smith"
      end
    end

    context "when snippet note" do
      it "should return information about a note" do
        stub_get("/projects/3/snippets/7/notes/1201", "note")
        note = client.snippet_note(3, 7, 1201)

        expect(note["body"].as_s).to eq "The solution is rather tricky"
        expect(note["author"]["name"].as_s).to eq "John Smith"
      end
    end

    context "when merge request note" do
      it "should return information about a note" do
        stub_get("/projects/3/merge_requests/7/notes/1201", "note")
        note = client.merge_request_note(3, 7, 1201)

        expect(note["body"].as_s).to eq "The solution is rather tricky"
        expect(note["author"]["name"].as_s).to eq "John Smith"
      end
    end
  end

  describe "create note" do
    context "when issue note" do
      it "should return information about a created note" do
        form = { "body" => "The solution is rather tricky" }
        stub_post("/projects/3/issues/7/notes", "note", form: form)
        note = client.create_issue_note(3, 7, "The solution is rather tricky")

        expect(note["body"].as_s).to eq "The solution is rather tricky"
        expect(note.["author"]["name"].as_s).to eq "John Smith"
      end
    end

    context "when snippet note" do
      it "should return information about a created note" do
        form = { "body" => "The solution is rather tricky" }
        stub_post("/projects/3/snippets/7/notes", "note", form: form)
        note = client.create_snippet_note(3, 7, "The solution is rather tricky")

        expect(note["body"].as_s).to eq "The solution is rather tricky"
        expect(note["author"]["name"].as_s).to eq "John Smith"
      end
    end

    context "when merge_request note" do
      it "should return information about a created note" do
        form = { "body" => "The solution is rather tricky" }
        stub_post("/projects/3/merge_requests/7/notes", "note", form: form)
        note = client.create_merge_request_note(3, 7, "The solution is rather tricky")

        expect(note["body"].as_s).to eq "The solution is rather tricky"
        expect(note["author"]["name"].as_s).to eq "John Smith"
      end
    end
  end

  describe "delete note" do
    context "when issue note" do
      it "should return information about a deleted issue note" do
        stub_delete("/projects/3/issues/7/notes/1201", "note")
        note = client.delete_issue_note(3, 7, 1201)

        expect(note["id"].as_i).to eq 1201
      end
    end

    context "when snippet note" do
      it "should return information about a deleted snippet note" do
        stub_delete("/projects/3/snippets/7/notes/1201", "note")
        note = client.delete_snippet_note(3, 7, 1201)

        expect(note["id"].as_i).to eq 1201
      end
    end

    context "when merge request note" do
      it "should return information about a deleted merge request note" do
        stub_delete("/projects/3/merge_requests/7/notes/1201", "note")
        note = client.delete_merge_request_note(3, 7, 1201)

        expect(note["id"].as_i).to eq 1201
      end
    end
  end

  describe "modify note" do
    context "when issue note" do
      it "should return information about a modified issue note" do
        form = { "body" => "edited issue note content" }
        stub_put("/projects/3/issues/7/notes/1201", "note", form: form)
        note = client.edit_issue_note(3, 7, 1201, "edited issue note content")

        expect(note["id"].as_i).to eq 1201
      end
    end

    context "when snippet note" do
      it "should return information about a modified snippet note" do
        form = { "body" => "edited snippet note content" }
        stub_put("/projects/3/snippets/7/notes/1201", "note", form: form)
        note = client.edit_snippet_note(3, 7, 1201, "edited snippet note content")

        expect(note["id"].as_i).to eq 1201
      end
    end

    context "when merge request note" do
      it "should return information about a modified request note" do
        form = { "body" => "edited merge request note content" }
        stub_put("/projects/3/merge_requests/7/notes/1201", "note", form: form)
        note = client.edit_merge_request_note(3, 7, 1201, "edited merge request note content")

        expect(note["id"].as_i).to eq 1201
      end
    end
  end
end
