# 💎 Gitlab.cr

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/icyleaf/gitlab.cr/blob/master/LICENSE)
[![Develop Status](https://img.shields.io/badge/status-development-green.svg)](https://github.com/icyleaf/gitlab.cr)
[![Dependency Status](https://shards.rocks/badge/github/icyleaf/gitlab.cr/status.svg)](https://shards.rocks/github/icyleaf/gitlab.cr)
[![devDependency Status](https://shards.rocks/badge/github/icyleaf/gitlab.cr/dev_status.svg)](https://shards.rocks/github/icyleaf/gitlab.cr)
[![Build Status](https://travis-ci.org/icyleaf/gitlab.cr.svg)](https://travis-ci.org/icyleaf/gitlab.cr)

Gitlab.cr is a [GitLab API](http://docs.gitlab.com/ce/api/README.html) wrapper writes with [Crystal](http://crystal-lang.org/) Language.
Inspired from [gitlab](https://github.com/NARKOZ/gitlab) gem for ruby version.

Docs Generated in **latest commit**.

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
end
```

More API check here: http://icyleaf.github.io/gitlab.cr/

## Progress

### Built-in

- [x] Http Client
- [x] Exceptions
- [x] Gitlab wrapper
- [x] Authentication

### Gitlab

- [ ] Users
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
  - [ ] Add SSH key - `create_ssh_key`
  - [ ] Add SSH key for user - `create_ssh_key(user_id)`
  - [ ] Delete SSH key for current user - `delete_ssh_key`
  - [ ] Delete SSH key for given user - `delete_ssh_key(user_id)`
  - [ ] List emails - `emails`
  - [ ] List emails for user - `emails(user_id)`
  - [ ] Single email - `email`
  - [ ] Add email - `create_email`
  - [ ] Add email for user - `create_email(user_id)`
  - [ ] Delete email for current user - `delete_email`
  - [ ] Delete email for given user - `delete_email(user_id)`
- [ ] Session
- [ ] Projects (including setting Webhooks)
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
- [ ] Groups
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
