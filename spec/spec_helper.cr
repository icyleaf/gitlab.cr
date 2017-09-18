require "spec2"
require "webmock"
require "../src/gitlab"

def client
  Gitlab.client("https://api.gitlab.org", "token")
end

def load_fixture(name)
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

# GET
def stub_get(path, fixture)
  WebMock.stub(:get, "#{client.endpoint}#{path}")
         .with(body: "", headers: {
            "Private-Token" => client.token,
            "User-Agent" => Halite::Options::USER_AGENT,
            "Accept" => "*/*",
            "Connection" => "keep-alive"
          })
          .to_return(body: load_fixture(fixture))
end
