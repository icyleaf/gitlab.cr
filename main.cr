require "./src/gitlab"

require "http/client"
require "json"
require "secure_random"
require "tempfile"
require "webmock"
# require "compiler/crystal/*"
# require "compiler/crystal/syntax"
# require "compiler/crystal/compiler"
# require "compiler/crystal/program"
# require "compiler/crystal/crystal_path"
# require "compiler/crystal/core_ext/*"
# require "compiler/crystal/macros/*"
# # require "compiler/crystal/tools/*"
# require "compiler/crystal/semantic/*"
# require "compiler/crystal/codegen/*"

# endpoint = "http://git.2b6.me/api/v3"
# token = "kNT_eyzC-3VMP7zzGCDw"


endpoint = "http://localhost:10080/api/v3"
token = "7cwQstc9dMp4Mu6boxhs"


client = Gitlab.client(endpoint, token)

# pp client.get("/user")
WebMock.stub(:delete, "#{client.endpoint}/projects/1/hooks/1")
.with(headers: { "PRIVATE-TOKEN" => client.token })
.to_return(body: "")
r = client.remove_project_hook(1, 1)

if r
  puts "dd"
else
  puts "222l"
end

# group = client.group_search("Cocoapods")[0]

# [1, 2].each do |page|
#   projects = client.group_projects(159, {"per_page" => "100", "page" => page.to_s }).to_a
#   projects.each do |p|
#     begin
#       p_id = p["id"]
#       puts "unprotect #{p["name"]} ... "
#       client.unprotect_project_branch(p_id.to_s, "master")
#     rescue
#       next
#     end
#   end
# end


# begin
#   # user = client.get("/user")
#   # pp client.upload_file(1, "shard.yml")
#   p client.file_archive(1, "c71e9525c6ca57a251784eb3dbe7677392c38858")
#   # p client.file_contents(1, "a5c805f456f46b44e270f342330b06e06c53cbcc", "CHANGELOGS.md")
#   # pp client.projects({ "per_page" => "2" })
# rescue ex: Gitlab::Error::Error
#   pp ex
# end

# target_filenames = Dir["spec/**/*_spec.cr"]
# source_filename = Fie.expand_path("spec")
#
# source = target_filenames.map { |filename| %(require "./#{filename}") }.join("\n")
# sources = [Crystal::Compiler::Source.new(source_filename, source)]

# output_filename = tempfile "spec"
# compiler = Crystal::Compiler.new
#
# result = compiler.compile sources, output_filename
# execute output_filename

