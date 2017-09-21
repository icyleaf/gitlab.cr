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
        JSON.parse get("/projects/#{project_id}/repository/files/#{filepath}", params: {
          ref: ref,
        }).body
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

      # def create_file
      # end

      # def edit_file
      # end

      # def remove_file
      # end

      private def file_contents_from_blobs(project_id : Int32, filepath : String, sha : String) : String
        get("/projects/#{project_id}/repository/blobs/#{sha}", params: {
          "filepath" => filepath,
        }, headers: {
          "Accept" => "text/plain",
        }).body
      end

      private def file_contents_from_files(project_id : Int32, filepath : String, ref : String) : String
        get("/projects/#{project_id}/repository/files/#{filepath}/raw", params: {
          "ref" => ref,
        }, headers: {
          "Accept" => "text/plain",
        }).body
      end
    end
  end
end
