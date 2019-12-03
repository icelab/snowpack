# Changelog

## [1.0.0.alpha7] - 2019-12-03

### Fixed

- Set up :sql notification event before enabling SQL logging
- CLI `db migrate` task can now run when no migration files are present

## [1.0.0.alpha6] - 2019-10-22

### Added

- Added custom Appsignal/Sidekiq instrumentation

### Fixed

- Reduced arity strictness of Appsignal/Que error handler

## [1.0.0.alpha5] - 2019-09-20

### Changed

- Remove dry-transaction from generated application `Gemfile`

### Fixed

CLI:

- Don't crash when referring to seeds file path in `db seed` command
- Don't boot application before loading seeds in `db seed` command (the application boot process may depend on the seeds having been run first)
- Fix crash when passing a previous migration target to `db migrate` command

App generation:

- Ensure `tmp/` dir is generated with new apps
- Fixed module nesting of generated `Operation` class
- Include dry-monads/dry-matcher directly in generated `Operation` class (rather than `Dry::Transaction::Operation`, given dry-transaction is no longer a generated gem dependency)

Spec suite:

- Don't crash when `tmp/` dir is not present

## [1.0.0.alpha4] - 2019-07-11

### Fixed

- Remove require of bundler/setup in `snowpack` executable entirely

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
