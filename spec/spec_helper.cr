require "spec2"
require "webmock"
require "../src/gitlab"

GITLAB_ENDPOINT = "https://api.gitlab.org/api/v3"
GITLAB_TOKEN = "token"

def client
  Gitlab.client(GITLAB_ENDPOINT, GITLAB_TOKEN)
end

def load_fixture(name)
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

def stub_get(path, fixture)
  WebMock.stub(:get, "#{client.endpoint}#{path}")
         .with(headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture))
end

def stub_post(path, fixture, status_code = 200)
  WebMock.stub(:post, "#{client.endpoint}#{path}")
         .with(headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture), status: status_code)
end

def stub_put(path, fixture, params = nil)
  query = if params
    "?" + params.map {|k,v| "#{k}=#{v}"}.join("&")
  else
   ""
  end

  WebMock.stub(:put, "#{client.endpoint}#{path}#{query}")
         .with(headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture))
end


def stub_delete(path, fixture)
  WebMock.stub(:delete, "#{client.endpoint}#{path}")
         .with(headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture))
end
