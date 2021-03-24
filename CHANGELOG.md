# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

> TODO

## [0.7.0] (2021-03-24)

### Fixed

- Compatibility with Crystal 1.0.

### Added

- Add `create_file` method. [#44](https://github.com/icyleaf/gitlab.cr/issues/44) (thanks @[mipmip](https://github.com/mipmip))


## [0.6.1] (2020-12-22)

### Added

- Add custom attributes for users, projects and groups [#32](https://github.com/icyleaf/gitlab.cr/issues/32) [#37](https://github.com/icyleaf/gitlab.cr/issues/37) (thanks @[mipmip](https://github.com/mipmip))
- Add authenticating with a key by figerprint [#36](https://github.com/icyleaf/gitlab.cr/issues/36) (thanks @[mipmip](https://github.com/mipmip))
- Add poroject pages domain [#31](https://github.com/icyleaf/gitlab.cr/issues/31) (thanks @[mipmip](https://github.com/mipmip))

### Changed

- Change delete behaviour since Gitlab 9.0 [#33](https://github.com/icyleaf/gitlab.cr/issues/33) [#39](https://github.com/icyleaf/gitlab.cr/issues/39) (thanks @[mipmip](https://github.com/mipmip))

### Fixed

- Correct determine graphql path
- Compatibility with Crystal 0.30

## [0.5.0] (2019-05-20)

### Fixed

- Compatibility with Crystal 0.28

## [0.4.0] (2018-11-15)

### Added

- Add `version` API.
- Add `available?` API.

## [0.3.5] (2018-08-20)

### Fixed

- Compatibility with Crystal 0.26

## [0.3.4] (2018-06-19)

### Fixed

- Compatibility with Crystal 0.25

## [0.3.3] (2018-01-19)

### Changed

- All errors based on APIError now only accepts Response class.
  - `BadRequest`
  - `Unauthorized`
  - `Forbidden`
  - `NotFound`
  - `MethodNotAllowed`
  - `Conflict`
  - `Unprocessable`
  - `InternalServerError`
  - `BadGateway`
  - `ServiceUnavailable`

### Fixed

- Fix get message or error when return error json data.
- Fix throws unmatched exception with 502 and non-json body of response.
- Fix throws an exception with use v4 api, changed to v5. ([Read more](https://docs.gitlab.com/ce/api/README.html#road-to-graphql))

## [0.3.0] (2017-09-22)

### Changed

- Use [Halite](https://github.com/icyleaf/halite) instead of legcy built-in HTTP client
- Rename `keys` to `deploy_keys` in deploy_keys uri
- Change project search uri
- Support return nil in `remove_project_hook`
- Support pass extra params in `accept_merge_request`
- Change query to body to pass data in PUT request
- Change `edit_group` pass args way(from key to hash)
- Rename `file_archive` to `repo_archive`
- Rename `blob_contents` to `blob`
- Get file content via two ways, one fail, try the other
- 100% pass rspec
- Based on Crystal v0.23.1

### Added

- Add `milestone_merge_requests` api
- Add `update_merge_request` api
- Add `group_member` api
- Add `get_file`

### Fixed

- Correct all matched `subscribe` methods uri
- Correct fork `project`/`project_member` uri
- Correct `delete_merge_request_note` uri
- Correct all branch methods uri
- Duplicate `lables` methods, and rename to `issues`

## [0.2.4] (2017-08-25)

### Changed

- Rename search_groups to group_search.
- [Upgrade to support Crystal 0.20.0](https://github.com/icyleaf/gitlab.cr/commit/acc2b4170b6cb4a2ec339d466d9127b10bdd444b)

### Added

- [Support find group by name](https://github.com/icyleaf/gitlab.cr/commit/b7fd47cc630e2213f19c2653c7cfa275638945fd)

### Fiexed

- Fix group_search and user_search with ghost variable.

## [0.2.1] (2016-06-22)

### Fiexed

- [Fix typo in project url](https://github.com/icyleaf/gitlab.cr/commit/fcd957e18e1ec03fb0c2fc1c422c56b3e826ff14)

## v0.2.0 (2016-06-21)

- [initial implementation](https://github.com/icyleaf/gitlab.cr/issues?q=milestone%3A0.2.0+is%3Aclosed)

[Unreleased]: https://github.com/icyleaf/gitlab.cr/compare/v0.7.0...HEAD
[0.7.0]: https://github.com/icyleaf/gitlab.cr/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/icyleaf/gitlab.cr/compare/v0.5.0...v0.6.1
[0.5.0]: https://github.com/icyleaf/gitlab.cr/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/icyleaf/gitlab.cr/compare/v0.3.5...v0.4.0
[0.3.5]: https://github.com/icyleaf/gitlab.cr/compare/v0.3.4...v0.3.5
[0.3.4]: https://github.com/icyleaf/gitlab.cr/compare/v0.3.3...v0.3.4
[0.3.3]: https://github.com/icyleaf/gitlab.cr/compare/v0.3.0...v0.3.3
[0.3.0]: https://github.com/icyleaf/gitlab.cr/compare/v0.2.4...v0.3.0
[0.2.4]: https://github.com/icyleaf/gitlab.cr/compare/v0.2.1...v0.2.4
[0.2.1]: https://github.com/icyleaf/gitlab.cr/compare/v0.2.0...v0.2.1
