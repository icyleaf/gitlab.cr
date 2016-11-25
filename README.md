# 💎 Gitlab.cr

[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/icyleaf/gitlab.cr/blob/master/LICENSE)
[![Version](https://img.shields.io/badge/version-0.2.1-green.svg)](https://github.com/icyleaf/gitlab.cr)
[![Dependency Status](https://shards.rocks/badge/github/icyleaf/gitlab.cr/status.svg)](https://shards.rocks/github/icyleaf/gitlab.cr)
[![devDependency Status](https://shards.rocks/badge/github/icyleaf/gitlab.cr/dev_status.svg)](https://shards.rocks/github/icyleaf/gitlab.cr)
[![Build Status](https://travis-ci.org/icyleaf/gitlab.cr.svg)](https://travis-ci.org/icyleaf/gitlab.cr)

Gitlab.cr is a [GitLab API](http://docs.gitlab.com/ce/api/README.html) wrapper writes with [Crystal](http://crystal-lang.org/) Language.
Inspired from [gitlab](https://github.com/NARKOZ/gitlab) gem for ruby version.

Build in crystal version >= `v0.18.2`, Docs Generated in latest commit.

## Installation

### Stable version

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gitlab:
    github: icyleaf/gitlab.cr
    branch: master
```

`master` branch is always the latest stable release version.

### Develop(Unstable) version

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gitlab:
    github: icyleaf/gitlab.cr
    branch: develop
```

### Explicit version

Add this to your application's `shard.yml`, and change the [version(release)](https://github.com/icyleaf/gitlab.cr/releases) what you want:

```yaml
dependencies:
  gitlab:
    github: icyleaf/gitlab.cr
    version: 0.2.2
```

## Usage

```crystal
require "gitlab"

# configuration
endpoint = "http://domain.com/api/v3"
token = "<token>"

# initialize a new client
g = Gitlab.client(endpoint, token)
# => #<Gitlab::Client:0x101653f20 @endpoint="http://localhost:10080/api/v3", @token="xxx">

# get the authenticated user
user = g.user
# => {"name" => "icyleaf", "username" => "icyleaf", "id" => 34, "state" => "active", "avatar_url" => "http://www.gravatar.com/avatar/38e1b2eb5d0a3fff4fb0ab8363c8f874?s=80&d=identicon", "web_url" => "http://gitlab.docker:10080/u/icyleaf", "created_at" => "2016-05-14T09:23:42.594+05:30", "is_admin" => true, "bio" => nil, "location" => nil, "skype" => "", "linkedin" => "", "twitter" => "", "website_url" => "", "last_sign_in_at" => "2016-05-14T09:24:00.575+05:30", "confirmed_at" => "2016-05-14T09:23:42.457+05:30", "email" => "icyleaf.cn@gmail.com", "theme_id" => 2, "color_scheme_id" => 1, "projects_limit" => 8, "current_sign_in_at" => "2016-06-18T20:11:15.609+05:30", "identities" => [], "can_create_group" => true, "can_create_project" => true, "two_factor_enabled" => false, "external" => false, "private_token" => "xxx"}

# get the user's email
email = user["email"]
# => "icyleaf.cn@gmail.com"

# get list of projects
projects = g.projects({ "per_page" => 5 })

# handle the exception
begin
  pp g.delete_group(999)
rescue ex
  pp ex.message
  # Here has one variable "response" instance of Gitlab::HTTP::Response
  # Friendly for developer to debug and control expressions.
  pp ex.response.code
  pp ex.response.body.parse_json
end

# request not handled APIs
# example: request a GET method to call "/application/settings"

# get gitlab settings
g.get("/application/settings")

# update gitlab settings
g.put("/application/settings", { "signup_enabled" => "false" })
```

For more information, refer to [API Documentation](http://icyleaf.github.io/gitlab.cr/).

## Progress

### Built-in

- [x] Http Client
- [x] Exceptions
- [x] Gitlab wrapper
- [x] Authentication

### Gitlab

- [x] Users
  - [x] List Users - `users`
  - [x] Single user - `user(user_id)`
  - [x] User creation - `create_user`
  - [x] User modification - `edit_user`
  - [x] User deletion - `delete_user`
  - [x] Current user - `user`
  - [x] Block user - `block_user(user_id)`
  - [x] Unblock user - `unblock_user(user_id)`
  - [x] List SSH keys - `ssh_keys`
  - [x] List SSH keys for user - `ssh_keys(user_id)`
  - [x] Single SSH key `ssh_key(ssh_key_id)`
  - [x] Add SSH key - `create_ssh_key`
  - [x] Add SSH key for user - `create_ssh_key(user_id)`
  - [x] Delete SSH key for current user - `delete_ssh_key`
  - [x] Delete SSH key for given user - `delete_ssh_key(user_id)`
  - [x] List emails - `emails`
  - [x] List emails for user - `emails(user_id)`
  - [x] Single email - `email`
  - [x] Add email - `add_email`
  - [x] Add email for user - `add_email(user_id)`
  - [x] Delete email for current user - `delete_email`
  - [x] Delete email for given user - `delete_email(user_id)`
- [x] Session
  - [x] Login session - `session`
- [ ] Projects (including setting Webhooks)
  - [ ] Uploads - **TODO**: Waiting for Crystal API
    - [ ] Upload a file
  - [x] List projects - `projects`
    - [x] List owned projects - `owned_projects`
    - [x] List starred projects - `starred_projects`
    - [x] List ALL projects - `all_projects`
    - [x] Get single project - `project`
    - [x] Get project events - `project_events`
    - [x] Create project - `create_project`
    - [x] Create project for user - `create_project(user_id)`
    - [x] Edit project - `edit_project`
    - [x] Fork project - `fork_project`
    - [x] Star a project - `star_project`
    - [x] Unstar a project - `unstar_project`
    - [x] Archive a project - `archive_project`
    - [x] Unarchive a project - `unarchive_project`
    - [x] Remove project - `delete_project`
  - [x] Team members
    - [x] List project team members - `project_members`
    - [x] Get project team member - `project_member`
    - [x] Add project team member - `add_project_member`
    - [x] Edit project team member - `edit_project_member`
    - [x] Remove project team member - `remove_project_member`
    - [x] Share project with group - `share_project`
  - [x] Hooks
    - [x] List project hooks - `project_hooks`
    - [x] Get project hook - `project_hook`
    - [x] Add project hook - `add_project_hook`
    - [x] Edit project hook - `edit_project_hook`
    - [x] Delete project hook - `remove_project_hook`
  - [x] Branches
    - [x] List branches - `project_branchs`
    - [x] List single branch - `project_branch`
    - [x] Protect single branch - `protect_project_branch`
    - [x] Unprotect single branch - `unprotect_project_branch`
  - [x] Admin fork relation
    - [x] Create a forked from/to relation between existing projects. - `create_fork_from`
    - [x] Delete an existing forked from relationship - `remove_fork_from`
  - [x] Search for projects by name - `project_search`
- [x] Repositories
  - [x] Get file archive
  - [x] List repository tree - `tree`
  - [x] Raw file content - `file_contents`
  - [x] Raw blob content - `blow_content`
  - [x] Compare branches, tags or commits - `compare`
  - [x] Contributors - `contributors`
- [x] Commits
  - [x] List repository commits - `commits`
  - [x] Get a single commit - `commit`
  - [x] Get the diff of a commit - `commit_diff`
  - [x] Get the comments of a commit - `commit_coments`
  - [x] Post comment to commit - `create_commit_comment`
  - [x] Commit status
    - [x] Get the status of a commit - `commit_status`
    - [x] Post the build status to a commit - `update_commit_status`
- [x] Branches
  - [x] List repository branches - `branches`
  - [x] Get single repository branch - `branch`
  - [x] Protect repository branch - `protect_branch`
  - [x] Unprotect repository branch - `unprotect_branch`
  - [x] Create repository branch - `create_branch`
  - [x] Delete repository branch - `delete_branch`
- [x] Merge Requests
  - [x] List merge requests - `merge_requests`
  - [x] Get single MR - `merge_request`
  - [x] Get single MR commits - `merge_request_commit`
  - [x] Get single MR changes - `merge_request_changes`
  - [x] Create MR - `create_merge_request`
  - [x] Update MR - `edit_merge_request`
  - [x] Delete a merge request - `delete_merge_request`
  - [x] Accept MR - `accept_merge_request`
  - [x] Cancel Merge When Build Succeeds - `cancel_merge_request_when_build_succeed`
  - [x] Comments on merge requests - `merge_request_comments`
  - [x] List issues that will close on merge -  `merge_request_closed_issues`
  - [x] Subscribe to a merge request - `subscribe_merge_request`
  - [x] Unsubscribe from a merge request - `unsubscribe_merge_request`
- [x] Issues
  - [x] List issues - `issues`
  - [x] List project issues - `issues(project_id)`
  - [x] Single issue - `issue`
  - [x] New issue - `create_issue`
  - [x] Edit issue - `edit_issue` / `close_issue` / `reopen_issue`
  - [x] Delete an issue - `delete_issue`
  - [x] Move an issue - `move_issue`
  - [x] Subscribe to an issue - `subscribe_issue`
  - [x] Unsubscribe from an issue - `unsubscribe_issue`
  - [x] Comments on issues - Comments are done via the **notes** resource
- [x] Keys
  - [x] Get SSH key with user by ID of an SSH key - `key`
- [x] Labels
  - [x] List labels - `labels`
  - [x] Create a new label - `create_label`
  - [x] Delete a label - `delete_label`
  - [x] Edit an existing label - `edit_labe`
  - [x] Subscribe to a label - `subscribe_label`
  - [x] Unsubscribe from a label - `unsubscribe_label`
- [x] Milestones
  - [x] List project milestones - `milestones`
  - [x] Get single milestone - `milestone`
  - [x] Create new milestone - `create_milestone`
  - [x] Edit milestone - `edit_milestone`
  - [x] Get all issues assigned to a single milestone - `milestone_issues`
- [x] Notes (comments)
  - [x] Issues
    - [x] List project issue notes - `issue_notes`
    - [x] Get single issue note - `issue_note`
    - [x] Create new issue note - `create_issue_note`
    - [x] Modify existing issue note - `edit_issue_note`
    - [x] Delete an issue note - `delete_issue_note`
  - [x] Snippets
    - [x] List all snippet notes - `snippet_notes`
    - [x] Get single snippet note - `snippet_note`
    - [x] Create new snippet note - `create_snippet_note`
    - [x] Modify existing snippet note - `edit_snippet_note`
    - [x] Delete a snippet note - `delete_snippet_note`
  - [x] Merge Requests
    - [x] List all merge request notes - `merge_request_notes`
    - [x] Get single merge request note - `merge_request_note`
    - [x] Create new merge request note - `create_merge_request_note`
    - [x] Modify existing merge request note - `edit_merge_request_note`
    - [x] Delete a merge request note - `delete_merge_request_note`
- [x] Deploy Keys
  - [x] List deploy keys - `deploy_keys`
  - [x] Single deploy key - `deploy_key`
  - [x] Add deploy key - `create_deploy_key`
  - [x] Delete deploy key - `remove_deploy_key`
- [x] Groups
  - [x] List groups - `groups`
  - [x] List a group's projects - `group_projects`
  - [x] Details of a group - `group`
  - [x] New group - `create_group`
  - [x] Transfer project to group - `transfer_project_to_group`
  - [x] Update group - `edit_group`
  - [x] Remove group - `delete_group`
  - [x] Search for group - `search_groups`
  - [x] Group members
    - [x] List group members - `group_members`
    - [x] Add group member - `add_member_to_group`
    - [x] Edit group team member - `edit_member_to_group`
    - [x] Remove user team member - `remove_member_to_group`
  - [x] Namespaces in groups - same as **List group**
- [x] Tags
  - [x] List project repository tags - `tags`
  - [x] Get a single repository tag - `tag`
  - [x] Create a new tag - `create_tag`
  - [x] Delete a tag - `delete_tag`
  - [x] Create a new release - `create_release_notes`
  - [x] Update a release - `update_release_notes`
- [ ] Project Snippets
- [ ] Services
- [ ] Repository Files
- [ ] System Hooks
- [ ] Namespaces
- [ ] Settings

## Contributing

1. [Fork it](https://github.com/icyleaf/gitlab.cr/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) aka 三火 - creator, maintainer
