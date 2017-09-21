require "spec2"
require "webmock"
require "../src/gitlab"

GITLAB_ENDPOINT = "https://gitlab.example.com/api/v3"
GITLAB_TOKEN = "token"

def client
  Gitlab.client(GITLAB_ENDPOINT, GITLAB_TOKEN)
end

def load_fixture(name : String?)
  return "" unless name
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

# GET
def stub_get(path, fixture, params = nil)
  query = "?#{HTTP::Params.escape(params)}" if params

  WebMock.stub(:get, "#{client.endpoint}#{path}#{query}")
         .with(headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture))
end

# POST
def stub_post(path, fixture, status_code = 200, params = nil, form = nil)
  query = "?#{HTTP::Params.escape(params)}" if params
  body = HTTP::Params.escape(form) if form

  WebMock.stub(:post, "#{client.endpoint}#{path}#{query}")
         .with(body: body, headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture), status: status_code)
end

# PUT
def stub_put(path, fixture, form = nil)
  body = HTTP::Params.escape(form) if form

  WebMock.stub(:put, "#{client.endpoint}#{path}")
         .with(body: body, headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture))
end

# DELETE
def stub_delete(path, fixture, form = nil)
  body = HTTP::Params.escape(form) if form

  WebMock.stub(:delete, "#{client.endpoint}#{path}")
         .with(body: body, headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture))
end
