module Gitlab
  class Client
    # Defines methods related to repository.
    #
    # See [http://docs.gitlab.com/ce/api/repositories.html](http://docs.gitlab.com/ce/api/repositories.html)
    module Repository
      # Get a list of repository files and directories in a project.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [Hash] params A customizable set of params.
      # - option params [String] :path The path inside repository. Used to get contend of subdirectories.
      # - option params [String] :ref_name The name of a repository branch or tag or if not given the default branch
      # - return [Hash]
      #
      # ```
      # client.tree(42)
      # client.tree(42, { path: 'Gemfile' })
      # ```
      def tree(project_id : Int32, params : Hash? = nil)
        JSON.parse get("/projects/#{project_id}/repository/tree", params: params).body
      end

      # Get the raw file contents for a blob by blob SHA.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] sha The id of a commit sha.
      # - return [String] The raw file contents
      #
      # ```
      # client.blow_contents(1, "74bbc1b7")
      # client.blow_contents(1, "a5c805f456f46b44e270f342330b06e06c53cbcc")
      # ```
      def blob_contents(project_id : Int32, sha : String)
        JSON.parse get("/projects/#{project_id}/repository/raw_blobs/#{sha}").body
      end

      # Get the raw file contents for a file by commit SHA and path.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] sha The id of a commit sha.
      # - param  [String] filepath The path and name of a file.
      # - return [String] The raw file contents
      #
      # ```
      # client.file_contents(1, "74bbc1b7", "README.md")
      # client.file_contents(1, "a5c805f456f46b44e270f342330b06e06c53cbcc", "src/gitlab.cr")
      # ```
      def file_contents(project_id : Int32, sha : String, filepath : String)
        JSON.parse get("/projects/#{project_id}/repository/blobs/#{sha}", params: {"filepath" => filepath}).body
      end

      # Get an archive of the repository.
      #
      # FIXME: response content type is "application/octet-stream"
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] sha The commit SHA to download defaults to the tip of the default branch.
      # - return [String] The archive file.
      #
      # ```
      # client.file_archive(1)
      # client.file_archive(1, "a5c805f456f46b44e270f342330b06e06c53cbcc")
      # ```
      def file_archive(project_id : Int32, sha : String? = nil)
        JSON.parse get("/projects/#{project_id}/repository/archive").body
      end

      # Compare branches, tags or commits.
      #
      # - param  [Int32] project The ID of a project.
      # - param  [String] from the commit SHA or branch name.
      # - param  [String] to the commit SHA or branch name.
      # - return [String] List a compare between from and to.
      #
      # ```
      # client.compare(1, "master", "develop")
      # client.compare(1, "a5c805f4", "v1.0.0")
      # ```
      def compare(project_id : Int32, from : String, to : String)
        JSON.parse get("/projects/#{project_id}/repository/compare", params: {
          "from" => from,
          "to"   => to,
        }).body
      end

      # Get repository contributors list
      #
      # - param  [Int32] project The ID of a project.
      # - params  [Hash] options A customizable set of options.
      # - option params [Int32] :page The page number.
      # - option params [Int32] :per_page The number of results per page.
      # - return [Array<Hash>] List of projects of the authorized user.
      #
      # ```
      # client.contributors(1)
      # client.contributors(1, {"per_page" => "10"})
      # ```
      def contributors(project_id : Int32, params : Hash? = nil)
        JSON.parse get("/projects/#{project_id}/repository/contributors", params: params)
      end
    end
  end
end
