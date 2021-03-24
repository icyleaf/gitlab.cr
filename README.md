# 💎 Gitlab.cr

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/gitlab.cr.svg)](https://github.com/icyleaf/gitlab.cr/blob/master/CHANGELOG.md)
[![Build Status](https://github.com/icyleaf/gitlab.cr/workflows/Linux%20CI/badge.svg)](https://github.com/icyleaf/gitlab.cr/actions?query=workflow%3A%22Linux+CI%22)

Gitlab.cr is a [GitLab API](http://docs.gitlab.com/ce/api/README.html) wrapper writes with [Crystal](http://crystal-lang.org/) Language.
Inspired from [gitlab](https://github.com/NARKOZ/gitlab) gem for ruby version. **No support GraphQL API**

Build in crystal version >= `v1.0.0`, Docs Generated in latest commit.

## Installation

```yaml
dependencies:
  gitlab:
    github: icyleaf/gitlab.cr
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
  pp ex.response.body
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

- Http Client - [Halite](https://github.com/icyleaf/halite)
- Exceptions
- Gitlab wrapper
- Authentication
- 100% Rspec Coveraged

### Gitlab

#### Completed

- Service Status (**Not Gitlab API**)
  - Check service available - `available?`
- Users
  - List Users - `users`
  - Single user - `user(user_id)`
  - User creation - `create_user`
  - User modification - `edit_user`
  - User deletion - `delete_user`
  - Current user - `user`
  - User deletion - `delete_user`
  - List custom attributes for given user - `user_custom_attributes(user_id)`
  - Add custom attribute for given user - `user_add_custom_attribute(user_id, key)`
  - Delete custom attribute for given user - `user_delete_custom_attribute(user_id, key)`
  - Block user - `block_user(user_id)`
  - Unblock user - `unblock_user(user_id)`
  - List SSH keys - `ssh_keys`
  - List SSH keys for user - `ssh_keys(user_id)`
  - Single SSH key `ssh_key(ssh_key_id)`
  - Add SSH key - `create_ssh_key`
  - Add SSH key for user - `create_ssh_key(user_id)`
  - Delete SSH key for current user - `delete_ssh_key`
  - Delete SSH key for given user - `delete_ssh_key(user_id)`
  - List emails - `emails`
  - List emails for user - `emails(user_id)`
  - Single email - `email`
  - Add email - `add_email`
  - Add email for user - `add_email(user_id)`
  - Delete email for current user - `delete_email`
  - Delete email for given user - `delete_email(user_id)`
- Session
  - Login session - `session`
- Projects (including setting Webhooks)
  - Uploads
    - Upload a file - `upload_file`
  - List projects - `projects`
    - List owned projects - `owned_projects`
    - List starred projects - `starred_projects`
    - List ALL projects - `all_projects`
    - Get single project - `project`
    - Get project events - `project_events`
    - Create project - `create_project`
    - Create project for user - `create_project(user_id)`
    - Edit project - `edit_project`
    - Fork project - `fork_project`
    - Star a project - `star_project`
    - Unstar a project - `unstar_project`
    - Archive a project - `archive_project`
    - Unarchive a project - `unarchive_project`
    - Remove project - `delete_project`
  - Team members
    - List project team members - `project_members`
    - Get project team member - `project_member`
    - Add project team member - `add_project_member`
    - Edit project team member - `edit_project_member`
    - Remove project team member - `remove_project_member`
    - Share project with group - `share_project`
  - Pages Domains
    - List project pages domains - `project_pages_domains`
    - Get project pages domain - `project_pages_domain`
    - Add project pages domain - `add_project_pages_domain`
    - Edit project pages domain `edit_project_pages_domain`
    - Remove project pages domain - `remove_project_pages_domain`
  - Hooks
    - List project hooks - `project_hooks`
    - Get project hook - `project_hook`
    - Add project hook - `add_project_hook`
    - Edit project hook - `edit_project_hook`
    - Delete project hook - `remove_project_hook`
  - Branches
    - List branches - `project_branchs`
    - List single branch - `project_branch`
    - Protect single branch - `protect_project_branch`
    - Unprotect single branch - `unprotect_project_branch`
  - Admin fork relation
    - Create a forked from/to relation between existing projects. - `create_fork_from`
    - Delete an existing forked from relationship - `remove_fork_from`
  - Search for projects by name - `project_search`
- Repositories
  - List repository tree - `tree`
  - Raw blob content - `blow`
  - Get an archive of the repository - `archive_project`
  - Compare branches, tags or commits - `compare`
  - Contributors - `contributors`
- Repository File
  - Gets a repository file - `get_file`
  - Get raw file content - `file_contents`
  - Create a file
  - Edit a file
  - Remove a file
- Commits
  - List repository commits - `commits`
  - Get a single commit - `commit`
  - Get the diff of a commit - `commit_diff`
  - Get the comments of a commit - `commit_coments`
  - Post comment to commit - `create_commit_comment`
  - Commit status
    - Get the status of a commit - `commit_status`
    - Post the build status to a commit - `update_commit_status`
- Branches
  - List repository branches - `branches`
  - Get single repository branch - `branch`
  - Protect repository branch - `protect_branch`
  - Unprotect repository branch - `unprotect_branch`
  - Create repository branch - `create_branch`
  - Delete repository branch - `delete_branch`
- Merge Requests
  - List merge requests - `merge_requests`
  - Get single MR - `merge_request`
  - Get single MR commits - `merge_request_commit`
  - Get single MR changes - `merge_request_changes`
  - Create MR - `create_merge_request`
  - Update MR - `edit_merge_request`
  - Delete a merge request - `delete_merge_request`
  - Accept MR - `accept_merge_request`
  - Cancel Merge When Build Succeeds - `cancel_merge_request_when_build_succeed`
  - Comments on merge requests - `merge_request_comments`
  - List issues that will close on merge -  `merge_request_closed_issues`
  - Subscribe to a merge request - `subscribe_merge_request`
  - Unsubscribe from a merge request - `unsubscribe_merge_request`
- Issues
  - List issues - `issues`
  - List project issues - `issues(project_id)`
  - Single issue - `issue`
  - New issue - `create_issue`
  - Edit issue - `edit_issue` / `close_issue` / `reopen_issue`
  - Delete an issue - `delete_issue`
  - Move an issue - `move_issue`
  - Subscribe to an issue - `subscribe_issue`
  - Unsubscribe from an issue - `unsubscribe_issue`
  - Comments on issues - Comments are done via the **notes** resource
- Keys
  - Get SSH key with user by ID of an SSH key - `key`
- Labels
  - List labels - `labels`
  - Create a new label - `create_label`
  - Delete a label - `delete_label`
  - Edit an existing label - `edit_labe`
  - Subscribe to a label - `subscribe_label`
  - Unsubscribe from a label - `unsubscribe_label`
- Milestones
  - List project milestones - `milestones`
  - Get single milestone - `milestone`
  - Create new milestone - `create_milestone`
  - Edit milestone - `edit_milestone`
  - Get all issues assigned to a single milestone - `milestone_issues`
  - Get all merge requests of a given milestone. - `milestone_merge_requests`
- Notes (comments)
  - Issues
    - List project issue notes - `issue_notes`
    - Get single issue note - `issue_note`
    - Create new issue note - `create_issue_note`
    - Modify existing issue note - `edit_issue_note`
    - Delete an issue note - `delete_issue_note`
  - Snippets
    - List all snippet notes - `snippet_notes`
    - Get single snippet note - `snippet_note`
    - Create new snippet note - `create_snippet_note`
    - Modify existing snippet note - `edit_snippet_note`
    - Delete a snippet note - `delete_snippet_note`
  - Merge Requests
    - List all merge request notes - `merge_request_notes`
    - Get single merge request note - `merge_request_note`
    - Create new merge request note - `create_merge_request_note`
    - Modify existing merge request note - `edit_merge_request_note`
    - Delete a merge request note - `delete_merge_request_note`
- Deploy Keys
  - List deploy keys - `deploy_keys`
  - Single deploy key - `deploy_key`
  - Add deploy key - `create_deploy_key`
  - Delete deploy key - `remove_deploy_key`
- Groups
  - List groups - `groups`
  - List a group's projects - `group_projects`
  - Details of a group - `group`
  - New group - `create_group`
  - Transfer project to group - `transfer_project_to_group`
  - Update group - `edit_group`
  - Remove group - `delete_group`
  - Search for group - `group_search`
  - Group members
    - List group members - `group_members`
    - Get member detail of group - `group_member`
    - Add group member - `add_member_to_group`
    - Edit group team member - `edit_member_to_group`
    - Remove user team member - `remove_member_to_group`
  - Namespaces in groups - same as **List group**
- Tags
  - List project repository tags - `tags`
  - Get a single repository tag - `tag`
  - Create a new tag - `create_tag`
  - Delete a tag - `delete_tag`
  - Create a new release - `create_release_notes`
  - Update a release - `update_release_notes`
- Version
  - Get Gitlab version - `version`

#### Todo (optional)

- Award Emoji
- Project Snippets
- Services
- System Hooks
- Settings
- Boards
- Gitlab CI
  - Builds
  - Jobs
  - Runners
  - Pipelines

## Help and Discussion

You can browse the API documents:

http://icyleaf.github.io/gitlab.cr/

You can browse the Changelog:

https://github.com/icyleaf/gitlab.cr/blob/master/CHANGELOG.md

If you have found a bug, please create a issue here:

https://github.com/icyleaf/gitlab.cr/issues/new

## How to Contribute

Your contributions are always welcome! Please submit a pull request or create an issue to add a new question, bug or feature to the list.

All [Contributors](https://github.com/icyleaf/gitlab.cr/graphs/contributors) are on the wall.

## You may also like

- [halite](https://github.com/icyleaf/halite) - HTTP Requests Client with a chainable REST API, built-in sessions and loggers.
- [markd](https://github.com/icyleaf/markd) - Yet another markdown parser built for speed, Compliant to CommonMark specification.
- [poncho](https://github.com/icyleaf/poncho) - A .env parser/loader improved for performance.
- [popcorn](https://github.com/icyleaf/popcorn) - Easy and Safe casting from one type to another.
- [fast-crystal](https://github.com/icyleaf/fast-crystal) - 💨 Writing Fast Crystal 😍 -- Collect Common Crystal idioms.

## License

[MIT License](https://github.com/icyleaf/gitlab.cr/blob/master/LICENSE) © icyleaf
