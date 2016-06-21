require "spec"
require "webmock"
require "../src/gitlab"

def load_fixture(name)
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

def client
  Gitlab.client("https://api.gitlab.org", "token")
end

# GET
def stub_get(path, fixture)
  WebMock.stub(:get, "#{client.endpoint}#{path}").
    with(headers: { "PRIVATE-TOKEN" => client.token }).
    to_return(body: load_fixture(fixture))
end