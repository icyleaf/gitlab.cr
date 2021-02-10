module Gitlab
  class Client
    # Defines methods related to repository.
    #
    # See [https://docs.gitlab.com/ce/api/repository_files.html](https://docs.gitlab.com/ce/api/repository_files.html)
    module RepositoryFile
      # Gets a repository file.
      #
      # - param  [Int32] project The ID or name of a project.
      # - param  [String] file_path The full path of the file.
      # - param  [String] ref The name of branch, tag or commit.
      # - return [JSON::Any]
      #
      # ```
      # client.get_file(42, "README.md")
      # client.get_file(42, "README.md", "develop")
      # ```
      def get_file(project_id : Int32, filepath : String, ref = "HEAD")
        get("projects/#{project_id}/repository/files/#{filepath}", params: {
          ref: ref,
        }).parse
      end

      # Get the raw file contents for a file by commit SHA and path.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] filepath The path and name of a file.
      # - param  [String] sha The id of a commit sha.
      # - return [String] The raw file contents
      #
      # ```
      # client.file_contents(1, "README.md")
      # client.file_contents(1, "src/gitlab.cr", "a5c805f456f46b44e270f342330b06e06c53cbcc")
      # ```
      def file_contents(project_id : Int32, filepath : String, sha = "HEAD") : String
        file_contents_from_files(project_id, filepath, sha)
      rescue
        file_contents_from_blobs(project_id, filepath, sha)
      end

      # Creates a new repository file.
      #
      # - param  [Int32, String] project The ID or name of a project. If using namespaced projects call make sure that the NAMESPACE/PROJECT_NAME is URL-encoded.
      # - param  [String] filepath The path and name of a file. Do not URL-encode
      # - param  [String] branch  The branch to create the file in
      # - param  [String] content The raw file contents
      # - param  [String] commit_message The commit message
      # - param  [Hash] options A customizable set of options.
      # - option form [String] :author_name Commit author's name
      # - option form [String] :author_email Commit author's email
      #
      # ```
      # client.create_file("my-stuff/example-repo".gsub("/", "%2F"), "some/dir/file.txt", "master", "Hello World\ncreated by gitlab.cr", "Just did it", {} of String => String)
      # ```
      def create_file(project : String | Int32, path : String, branch : String, content : String, commit_message : String, options : Hash = {} of String => String) : JSON::Any
        uri = "projects/#{project}/repository/files/#{path.gsub("/", "%2F")}"
        post(uri, form: options.merge({"branch" => branch, "commit_message" => commit_message, "content" => content})).parse
      end

      # def edit_file
      # end

      # def remove_file
      # end

      private def file_contents_from_blobs(project_id : Int32, filepath : String, sha : String) : String
        get("projects/#{project_id}/repository/blobs/#{sha}", params: {
          "filepath" => filepath,
        }, headers: {
          "Accept" => "text/plain",
        }).parse
      end

      private def file_contents_from_files(project_id : Int32, filepath : String, ref : String) : String
        get("projects/#{project_id}/repository/files/#{filepath}/raw", params: {
          "ref" => ref,
        }, headers: {
          "Accept" => "text/plain",
        }).parse
      end
    end
  end
end
