require "../../spec_helper"

describe Gitlab::Client::Project do
  describe ".projects" do
    it "should return a paginated response of projects" do
      stub_get("/projects", "projects")
      projects = client.projects

      projects.should be_a JSON::Any
      projects[0]["name"].as_s.should eq "Brute"
      projects[0]["owner"]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".project_search" do
    it "should return a paginated response of projects found" do
      stub_get("/projects?search=Gitlab", "project_search")
      project_search = client.project_search("Gitlab")

      project_search.should be_a JSON::Any
      project_search[0]["name"].as_s.should eq "Gitlab"
      project_search[0]["owner"]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".project" do
    it "should return information about a project" do
      stub_get("/projects/3", "project")
      project = client.project(3)

      project["name"].as_s.should eq "Gitlab"
      project["owner"]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".project_events" do
    it "should return a paginated response of events" do
      stub_get("/projects/2/events", "project_events")
      events = client.project_events(2)
      events.should be_a JSON::Any
      events.size.should eq 2
    end

    it "should return the action name of the event" do
      stub_get("/projects/2/events", "project_events")
      events = client.project_events(2)
      events[0]["action_name"].as_s.should eq "opened"
    end
  end

  describe ".create_project" do
    it "should return information about a created project" do
      stub_post("/projects", "project")
      project = client.create_project("Gitlab")

      project["name"].as_s.should eq "Gitlab"
      project["owner"]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".create_project for user" do
    it "should return information about a created project" do
      WebMock.reset
      stub_post("/users", "user")
      owner = client.create_user("johnexample.com", "pass", "John owner")

      stub_post("/projects/user/#{owner["id"]}", "project_for_user")
      project = client.create_project(owner["id"].as_i, "Brute")

      project["name"].as_s.should eq "Brute"
      project["owner"]["name"].as_s.should eq "John Owner"
    end
  end

  describe ".delete_project" do
    it "should return information about a deleted project" do
      stub_delete("/projects/Gitlab", "project")
      project = client.delete_project("Gitlab")

      project["name"].as_s.should eq "Gitlab"
      project["owner"]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".fork_project" do
    context "without sudo option" do
      it "should return information about the forked project" do
        stub_post("/projects/3/fork", "project_fork")
        project = client.fork_project(3)

        project["forked_from_project"]["id"].as_i.should eq 3
        project["id"].as_i.should eq 20
      end
    end

    context "with the sudo option" do
      it "should return information about the forked project" do
        form = {"sudo" => "root"}
        stub_post("/projects/3/fork", "project_forked_for_user", form: form)
        project = client.fork_project(3, form)

        project["forked_from_project"]["id"].as_i.should eq 3
        project["id"].as_i.should eq 20
        project["owner"]["username"].as_s.should eq "root"
      end
    end
  end

  describe ".team_members" do
    it "should return a paginated response of team members" do
      stub_get("/projects/3/members", "team_members")
      team_members = client.project_members(3)

      team_members.should be_a JSON::Any
      team_members[0]["name"].as_s.should eq "John Smith"
    end
  end

  describe ".project_member" do
    it "should return information about a team member" do
      stub_get("/projects/3/members/1", "team_member")
      team_member = client.project_member(3, 1)

      team_member["name"].as_s.should eq "John Smith"
    end
  end

  describe ".add_project_member" do
    it "should return information about an added team member" do
      form = {"body" => "3", "access_level" => "40"}
      stub_post("/projects/3/members", "team_member")
      team_member = client.add_project_member(3, 1, 40)

      team_member["name"].as_s.should eq "John Smith"
    end
  end

  describe ".edit_project_member" do
    it "should return information about an edited team member" do
      form = {"access_level" => "40"}
      stub_put("/projects/3/members/1", "team_member", form: form)
      team_member = client.edit_project_member(3, 1, 40)

      team_member["name"].as_s.should eq "John Smith"
    end
  end

  describe ".remove_project_member" do
    it "should return information about a removed team member" do
      stub_delete("/projects/3/members/1", "team_member")
      team_member = client.remove_project_member(3, 1)

      team_member["name"].as_s.should eq "John Smith"
    end
  end

  describe ".pages_domains" do
    it "should return a paginated response of pages domains" do
      stub_get("/projects/58/pages/domains", "pages_domains")
      pages_domains = client.project_pages_domains(58)

      pages_domains.should be_a JSON::Any
      pages_domains[0]["domain"].as_s.should eq "example-pages-domain.com"
    end
  end

   describe ".pages_domain" do
     it "should return information about a pages domain" do
       stub_get("/projects/58/pages/domains/example-pages-domain.com", "pages_domain")
       pages_domain = client.project_pages_domain(58, "example-pages-domain.com")

       pages_domain["domain"].as_s.should eq "example-pages-domain.com"
     end
   end

   describe ".add_pages_domain" do
     it "should return information about an added pages domain" do
       stub_post("/projects/58/pages/domains", "pages_domain")
       pages_domain = client.add_project_pages_domain(58, "example-pages-domain.com")

       pages_domain["domain"].as_s.should eq "example-pages-domain.com"
     end
   end

  describe ".edit_pages_domain" do
    it "should return information about an edited pages domain" do
      form = {
        "domain" => "example-pages-domain.com",
        "auto_ssl_enabled" => true
      }
      stub_put("/projects/58/pages/domains", "pages_domain", form: form)
      pages_domain = client.edit_project_pages_domain(58, "example-pages-domain.com", form)
      # I DON'T UNDERSTAND WHY THIS FAILS
      #pages_domain = client.edit_project_pages_domain(58, "example-pages-domain.com", {"auto_ssl_enabled"=>true})

      pages_domain["domain"].as_s.should eq "example-pages-domain.com"
    end
  end

  describe ".remove_pages_domain" do
    it "should return information about a removed pages domain" do
      stub_delete("/projects/58/pages/domains/example-pages-domain.com", "pages_domain")
      pages_domain = client.remove_project_pages_domain(58, "example-pages-domain.com")

      pages_domain["domain"].as_s.should eq "example-pages-domain.com"
    end
  end

  describe ".project_hooks" do
    it "should return a paginated response of hooks" do
      stub_get("/projects/1/hooks", "project_hooks")
      hooks = client.project_hooks(1)

      hooks.should be_a JSON::Any
      hooks[0]["url"].as_s.should eq "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".project_hook" do
    it "should return information about a hook" do
      stub_get("/projects/1/hooks/1", "project_hook")
      hook = client.project_hook(1, 1)

      hook["url"].as_s.should eq "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".add_project_hook" do
    context "without specified events" do
      it "should return information about an added hook" do
        form = {"url" => "https://api.example.net/v1/webhooks/ci"}
        stub_post("/projects/1/hooks", "project_hook", form: form)
        hook = client.add_project_hook(1, "https://api.example.net/v1/webhooks/ci")

        hook["url"].as_s.should eq "https://api.example.net/v1/webhooks/ci"
      end
    end

    context "with specified events" do
      it "should return information about an added hook" do
        form = {
          "url"                   => "https://api.example.net/v1/webhooks/ci",
          "push_events"           => "true",
          "merge_requests_events" => "true",
        }
        stub_post("/projects/1/hooks", "project_hook_edit", form: form)
        hook = client.add_project_hook(1, "https://api.example.net/v1/webhooks/ci", form: form)

        hook["url"].as_s.should eq "https://api.example.net/v1/webhooks/ci"
        hook["merge_requests_events"].as_bool.should be_truthy
      end
    end
  end

  describe ".edit_project_hook" do
    it "should return information about an edited hook" do
      form = {"url" => "https://api.example.net/v1/webhooks/ci"}
      stub_put("/projects/1/hooks/1", "project_hook", form: form)
      hook = client.edit_project_hook(1, 1, "https://api.example.net/v1/webhooks/ci")

      hook["url"].as_s.should eq "https://api.example.net/v1/webhooks/ci"
    end
  end

  describe ".edit_project" do
    context "using project ID" do
      it "should return information about an edited project" do
        form = {"name" => "Gitlab-edit"}
        stub_put("/projects/3", "project_edit", form: form)
        project = client.edit_project(3, form)

        project["name"].as_s.should eq "Gitlab-edit"
      end
    end

    context "using namespaced project path" do
      it "encodes the path properly" do
        WebMock.reset
        form = {"name" => "Gitlab-edit"}
        stub = stub_put("/projects/namespace/path", "project_edit", form: form)
        project = client.edit_project("namespace/path", form)

        project["name"].as_s.should eq "Gitlab-edit"
      end
    end
  end

  describe ".remove_project_hook" do
    context "when empty response" do
      it "should return false" do
        stub_delete("/projects/1/hooks/1", nil)

        hook = client.remove_project_hook(1, 1)
        hook.should be_nil
      end
    end

    context "when JSON response" do
      it "should return information about a deleted hook" do
        WebMock.reset
        stub_delete("/projects/1/hooks/1", "project_hook")
        hook = client.remove_project_hook(1, 1)
        hook.not_nil!["url"].as_s.should eq "https://api.example.net/v1/webhooks/ci"
      end
    end
  end

  # =======
  # describe ".push_rule" do
  #   before do
  #     stub_get("/projects/1/push_rule", "push_rule")
  #     push_rule = client.push_rule(1)
  #   end

  #   it "should get the correct resource" do
  #     a_get("/projects/1/push_rule").should have_been_made
  #   end

  #   it "should return information about a push rule" do
  #     push_rule.commit_message_regex.should eq "\\b[A-Z]{3}-[0-9]+\\b"
  #   end
  # end

  # describe ".add_push_rule" do
  #   before do
  #     stub_post("/projects/1/push_rule", "push_rule")
  #     push_rule = client.add_push_rule(1, { deny_delete_tag: false, commit_message_regex: "\\b[A-Z]{3}-[0-9]+\\b" })
  #   end

  #   it "should get the correct resource" do
  #     a_post("/projects/1/push_rule").should have_been_made
  #   end

  #   it "should return information about an added push rule" do
  #     push_rule.commit_message_regex.should eq "\\b[A-Z]{3}-[0-9]+\\b"
  #   end
  # end

  # describe ".edit_push_rule" do
  #   before do
  #     stub_put("/projects/1/push_rule", "push_rule")
  #     push_rule = client.edit_push_rule(1, { deny_delete_tag: false, commit_message_regex: "\\b[A-Z]{3}-[0-9]+\\b" })
  #   end

  #   it "should get the correct resource" do
  #     a_put("/projects/1/push_rule").should have_been_made
  #   end

  #   it "should return information about an edited push rule" do
  #     push_rule.commit_message_regex.should eq "\\b[A-Z]{3}-[0-9]+\\b"
  #   end
  # end

  # describe ".delete_push_rule" do
  #   context "when empty response" do
  #     before do
  #       stub_request(:delete, "#{client.endpoint}/projects/1/push_rule").
  #         with(headers: { "PRIVATE-TOKEN" => client.private_token }).
  #         to_return(body: "")
  #       push_rule = client.delete_push_rule(1)
  #     end

  #     it "should get the correct resource" do
  #       a_delete("/projects/1/push_rule").should have_been_made
  #     end

  #     it "should return false" do
  #       push_rule.should be(false)
  #     end
  #   end

  #   context "when JSON response" do
  #     before do
  #       stub_delete("/projects/1/push_rule", "push_rule")
  #       push_rule = client.delete_push_rule(1)
  #     end

  #     it "should get the correct resource" do
  #       a_delete("/projects/1/push_rule").should have_been_made
  #     end

  #     it "should return information about a deleted push rule" do
  #       push_rule.commit_message_regex.should eq "\\b[A-Z]{3}-[0-9]+\\b"
  #     end
  #   end
  # end
  # =======

  describe ".create_fork_from" do
    it "should return information about a forked project" do
      stub_post("/projects/42/fork/24", "project_fork_link")
      forked_project_link = client.create_fork_from(42, 24)
      forked_project_link["forked_from_project_id"].as_i.should eq 24
      forked_project_link["forked_to_project_id"].as_i.should eq 42
    end
  end

  describe ".remove_fork" do
    it "should return information about an unforked project" do
      stub_delete("/projects/42/fork", "project_fork_link")
      forked_project_link = client.remove_fork(42)

      forked_project_link["forked_to_project_id"].as_i.should eq 42
    end
  end

  describe ".share_project" do
    it "should return information about an added group" do
      form = {"group_id" => "10", "group_access" => "40"}
      stub_post("/projects/3/share", "group", form: form)
      group = client.share_project(3, 10, 40)

      group["id"].as_i.should eq 10
    end
  end

  describe ".star_project" do
    it "should return information about the starred project" do
      stub_post("/projects/3/star", "project_star")
      starred_project = client.star_project(3)

      starred_project["id"].as_i.should eq 3
    end
  end

  describe ".unstar_project" do
    it "should return information about the unstarred project" do
      stub_delete("/projects/3/star", "project_unstar")
      unstarred_project = client.unstar_project(3)

      unstarred_project["id"].as_i.should eq 3
    end
  end

  describe ".custom_attributes" do
    it "should return a json data of project's custom attributes" do
      stub_get("/projects/1/custom_attributes", "project_add_custom_attribute")
      result = client.project_custom_attributes(1)

      result["key"].as_s.should eq "custom_key"
      result["value"].as_s.should eq "custom_value"
    end
  end

  describe ".add_custom_attribute" do
    it "should return boolean" do
      params = {"value" => "custom_value"}
      stub_put("/projects/1/custom_attributes/custom_key", "project_add_custom_attribute", params)

      result = client.project_add_custom_attribute(1, "custom_key", params )
      result["key"].as_s.should eq "custom_key"
      result["value"].as_s.should eq "custom_value"
    end
  end

  describe ".delete_custom_attribute" do
    it "should return boolean" do
      stub_delete("/projects/1/custom_attributes/custom_key","project_delete_custom_attribute")

      result = client.project_delete_custom_attribute(1, "custom_key")
      result.size.should eq 0
    end
  end



end
