# Disclaimer

This project **is not ready for public usage** and it's **not open for contributions**. It will be open-sourced in the future, for the time being **you're not encouraged to use it** and **Icelab does not take any responsibility for its usage in your projects**.

# Snowflakes

[![Build Status](https://travis-ci.org/icelab/snowflakes.svg?branch=master)](https://travis-ci.org/icelab/snowflakes)

Snowflakes is a collection of development tools and common dry-web application components shared across Icelab's applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snowflakes', git: 'https://github.com/icelab/snowflakes.git', branch: 'master'
```

And then execute:

```
$ bundle
```

Run installation command:

```
$ sf install
```

## CLI

Snowflake's ships with a CLI accessible via `bin/run` executable, which provides access to various commands.
To learn about available tasks, simply run:

```
$ bin/run
Commands:
  run assets SUBCOMMAND  # Asset commands
  run console            # Start application console
  run db SUBCOMMAND      # Database commands
  run help [COMMAND]     # Describe available commands or one specific command
  run reloader           # Start application reloader
  run routes SUBCOMMAND  # Route commands
```

To learn about sub-commands, you can type:

```
$ bin/run db
Commands:
  run db create                # Create database
  run db drop                  # Drop database
  run db help [COMMAND]        # Describe subcommands or one specific subcommand
  run db migrate               # Run database migrations
  run db migrate               # Run database migrations
  run db reset                 # Drop, create and migrate the database
  run db sample_data           # Load db sample data if it exists
  run db seed                  # Load db seed if it exists
  run db structure SUBCOMMAND  # Database structure commands
  run db version               # Print schema version
```

To learn about a specific command and its options, type:

```
$ bin/run db help create
Usage:
  run create

Options:
  -e, [--env=ENV]  # Application environment

Create database
```

## Console

Application console is available via `bin/run console`, which automatically provides convenient access to various components:

```
=> starting berg[development] console
=> berg[development] booted in in 2.528877s
berg[development]>
```

### Console Plugins

REPL context object has access to all relations and all sub-apps repositories:

```
berg[development]> users
=> #<Persistence::Relations::Users dataset=#<Sequel::Postgres::Dataset: "SELECT \"id\", \"email\", \"encrypted_password\", \"access_token\", \"access_token_expiration\", \"active\", \"created_at\", \"updated_at\", \"name\" FROM \"users\" ORDER BY \"users\".\"id\"">>
berg[development]> user_repo
=> #<Main::Persistence::Repositories::Users relations=[:users]>
```

## Application reloader

For the reloader to work you need to start puma as follows:

```
bundle exec puma config.ru --pidfile tmp/pids/puma-api.pid
```

To start application reloader type:

```
$ bin/run reloader
```

It will restart your puma server ever time a file is changed or added to `apps` dir.
