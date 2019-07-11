# Changelog

## [1.0.0.alpha3] - 2019-07-11

### Added

- Add `snowpack version` subcommand for standalone executable

### Changed

- Add Application.slice_paths method, this can be overridden in subclasses to allow selective ignoring of some slices (this is not a perfect final solution, but helps in the interim)
- Slice.finalize! exits gracefully if Slice already finalized
- Slice.finalize! passes all its arguments to super
- Add Slice's default system_dir (if it exists) when inheriting from Snowpack::Slice
- Use internal error class in Web::EndpointResolver, allowing snowpack apps to work without hanami-controller installed

### Fixed

- Fix bug with recersive filtering in RackLogger
- Remove require of bundler/setup preventing `snowpack` executable from working in some circumstances

## [1.0.0.alpha2] - 2019-07-01

### Changed

- Fix case of gem name (now "snowpack", fully lowercase)

## [1.0.0.alpha1] - 2019-07-01 [YANKED]

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
