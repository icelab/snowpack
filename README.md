# Disclaimer

**This project is not intended for public usage and is not open for contributions. Icelab takes no responsibility for usage in your projects**.

# Snowpack

[![Build Status](https://travis-ci.org/icelab/snowpack.svg?branch=master)](https://travis-ci.org/icelab/snowpack)

Snowpack is lightwight application framework for Icelab’s Ruby applications. It builds upon [dry-system][dry-system], and integrates Hanami [router][hanami-router]/[controller][hanami-controller] (unstable branches) for HTTP request handling, and [rom-rb] for database persistence.

[dry-system]: https://github.com/dry-rb/dry-system
[hanami-router]: https://github.com/hanami/router
[hanami-controller]: https://github.com/hanami/controller
[rom-rb]: https://rom-rb.org/

## Getting started

Install the gem:

```
gem install snowpack -v "1.0.0.alpha2"
```

Generate a new application:

```
snowpack new my_app
```

Then enter the application and (if required) generate a new slice:

```
./bin/run generate slice main
```

## CLI

Snowpack's application CLI is accessible via the `bin/run` executable, which provides access to various commands. To learn about these, run:

```
$ ./bin/run
Commands:
  run assets [SUBCOMMAND]
  run console                            # Open interactive console
  run db [SUBCOMMAND]
  run generate [SUBCOMMAND]
  ```

To learn about sub-commands, run the parent command:

```
$ ./bin/run db
Commands:
  run db create                                  # Create database
  run db create_migration [NAME]                 # Create new migration file
  run db drop                                    # Delete database
  run db migrate                                 # Migrates database
  run db reset                                   # Drop, create, and migrate database
  run db rollback                                # Rollback database to a previous migration
  run db sample_data                             # Load sample data
  run db seed                                    # Load database seeds
  run db structure [SUBCOMMAND]
  run db version                                 # Print schema version
```

To learn about any specific command, pass the `-h` or `--help` option:

```
$ ./bin/run db migrate --help
Command:
  run db migrate

Usage:
  run db migrate

Description:
  Migrates database

Options:
  --env=VALUE, -e VALUE                 # Application environment
  --target=VALUE, -t VALUE              # Target migration number
  --help, -h                            # Print this help
```

## Console

An application console is available via `bin/run console`. It provides convenient access to various components:

```
=> starting my_app[development] console
=> my_app[development] booted in in 0.4s
my_app[development]>
```

### Console helpers

The console offers convenient access to all rom-rb relations:

```
my_app[development]> users
=> #<Persistence::Relations::Users dataset=#<Sequel::Postgres::Dataset: "SELECT \"id\", \"email\", \"encrypted_password\", \"access_token\", \"access_token_expiration\", \"active\", \"created_at\", \"updated_at\", \"name\" FROM \"users\" ORDER BY \"users\".\"id\"">>
```

As well as all slices:

```
my_app[development]> main
=> MyApp::Main::Slice
```

As well as any root-level registrations on the slices:

```
my_app[development]> main.user_repo
# => #<MyApp::Main::UserRepo struct_namespace=MyApp::Main::Entities auto_struct=true>
```
