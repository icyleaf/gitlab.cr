# 💎 Gitlab.cr

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/icyleaf/gitlab.cr/blob/master/LICENSE)
[![Version](https://img.shields.io/badge/version-development-green.svg)](https://github.com/icyleaf/gitlab.cr)
[![Dependency Status](https://shards.rocks/badge/github/icyleaf/gitlab.cr/status.svg)](https://shards.rocks/github/icyleaf/gitlab.cr)
[![devDependency Status](https://shards.rocks/badge/github/icyleaf/gitlab.cr/dev_status.svg)](https://shards.rocks/github/icyleaf/gitlab.cr)
[![Build Status](https://travis-ci.org/icyleaf/gitlab.cr.svg)](https://travis-ci.org/icyleaf/gitlab.cr)

Gitlab.cr is a [GitLab API](http://docs.gitlab.com/ce/api/README.html) wrapper writes with [Crystal](http://crystal-lang.org/) Language.
Inspired from [gitlab](https://github.com/NARKOZ/gitlab) gem for ruby version.

Docs Generated in latest commit.

## Status

Learning Crystal language, and **WORKIONG IN PROCESS**, please DO NOT use it in production environment.

Build in crystal version >= `v0.17.4`

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gitlab.cr:
    github: icyleaf/gitlab.cr
```

## Usage

```crystal
require "gitlab"

endpoint = "http://domain.com/api/v3"
token = "<token>"

begin
  g = Gitlab.client(endpoint, token)
  pp g.users({ "per_page" => "2" })
  pp g.user(2)
rescue ex
  pp ex.message
  # Here has one variable "response" instance of HTTP::Response
  # Friendly for developer to debug and control expressions.
  pp ex.response.status_code
  pp ex.response.body
end
```

More API check it out: [http://icyleaf.github.io/gitlab.cr/](http://icyleaf.github.io/gitlab.cr/)

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
- [ ] Session
- [ ] Projects (including setting Webhooks)
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
  - [ ] Uploads - **TODO**: Waiting for Crystal API
    - [ ] Upload a file
- [ ] Project Snippets
- [ ] Services
- [ ] Repositories
- [ ] Repository Files
- [ ] Commits
- [ ] Branches
- [ ] Merge Requests
- [ ] Issues
- [ ] Labels
- [ ] Milestones
- [ ] Notes (comments)
- [ ] Deploy Keys
- [ ] System Hooks
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
