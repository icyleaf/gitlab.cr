require "spec"
require "webmock"
require "../src/gitlab"

GITLAB_ENDPOINT = "https://gitlab.example.com/api/v3"
GITLAB_TOKEN    = "token"

def client
  Gitlab.client(GITLAB_ENDPOINT, GITLAB_TOKEN)
end

def load_fixture(name : String?)
  return "" unless name
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

# GET
def stub_get(path, fixture, params = nil, response_headers = {} of String => String, status = 200)
  query = "?#{HTTP::Params.encode(params)}" if params

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:get, "#{client.endpoint}#{path}#{query}")
         .with(headers: {"Private-Token" => client.token})
         .to_return(status: status, body: load_fixture(fixture), headers: response_headers)
end

# POST
def stub_post(path, fixture, status_code = 200, params = nil, form = nil, response_headers = {} of String => String)
  query = "?#{HTTP::Params.escape(params)}" if params
  body = HTTP::Params.encode(form) if form

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:post, "#{client.endpoint}#{path}#{query}")
         .with(body: body, headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture), headers: response_headers, status: status_code)
end

# PUT
def stub_put(path, fixture, form = nil, response_headers = {} of String => String)
  body = HTTP::Params.encode(form) if form

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:put, "#{client.endpoint}#{path}")
         .with(body: body, headers: {"Private-Token" => client.token})
         .to_return(body: load_fixture(fixture), headers: response_headers)
end

# DELETE
def stub_delete(path, fixture = nil, form = nil, response_headers = {} of String => String, status = 200)
  body = HTTP::Params.encode(form) if form

  if fixture
    response_headers.merge!({"Content-Type" => "application/json"})
    WebMock.stub(:delete, "#{client.endpoint}#{path}")
          .with(body: body, headers: {"Private-Token" => client.token})
          .to_return(body: load_fixture(fixture), status: status, headers: response_headers)
  else
    WebMock.stub(:delete, "#{client.endpoint}#{path}")
          .with(body: body, headers: {"Private-Token" => client.token})
          .to_return(status: 204)
  end
end
