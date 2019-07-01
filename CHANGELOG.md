# Changelog

## [1.0.0.alpha1] - 2019-07-01

### Added

- Introduce app/slices structure via `Snowpack::Application` and `Snowpack::Slice`
- Introduce `Snowpack::Web` module for holding route definitions and preparing rack app
- Introduce `Snowpack::Web::Application` and `Snowpack::Web::Plugin` dry-system plugin, which provide a rack-mountable web application (and supporting infrastructure) depending upon hanami-router (unstable branch) for routing and hanami-controller (unstable branch) for HTTP endpoint handling
- Introduce `snowpack` CLI with `new` command for generating new applications
- Add `generate slice` application CLI command

### Changed

- Rebuild application CLI using hanami-cli

### Removed

- Remove repo readers from console environment
