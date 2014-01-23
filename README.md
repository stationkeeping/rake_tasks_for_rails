# RakeTasksForRails

Simple Rake tasks to help with Rails development using Postgres and Heroku.

## Tasks

Wherever possible, tasks use sensible defaults which can be overridden using environmental variables. Note: `app_name` is taken from your Rails application name:

- `ENV["HEROKU_STAGING_APP_NAME"]` - Default: "#{app_name}-staging"
- `ENV["HEROKU_PRODUCTION_APP_NAME"]` - Default: "#{app_name}-production"
- `ENV["REMOTE_STAGING_NAME"]` - Default: "staging"
- `ENV["REMOTE_PRODUCTION_NAME"]` - Default: "production"
- `ENV["DEVELOPMENT_DATABASE_NAME"]` - Default: "#{app_name}_development"
- `ENV["DROPBOX_ACCESS_TOKEN"]` - Default: This will cause an exception to be raised if missing
- `ENV["ASSET_HASH_DIRNAME"]` - Default: "tmp". *Note: this is the location of the file used to track changes to assets and used to determine whether precompilation is necessary.*


Tasks are broken into three groups:

### App

#### Push

1. app:push (defers to 'app:push:staging')
2. app:push:staging
3. app:push:production

These tasks all do the following:

1. Check to see if the contents of 'app/assets' has changed. If so `rake:assets:precompile` is run
under the environment of the remote application.
2. If assets have been precompiled, the new manifest is commited. This task assumes that the assets themselves will be uploaded separately to a CDN, manually or via Asset Sync.
3. Push master branch to the remote application
4. Run migrations on the remote application

### DB

#### Push

1. db:push (defers to 'db:push:staging')
2. db:push:staging
3. db:push:production

These tasks do the following:

1. Dumps the development databse to your Dropbox public folder: 'public/tmp/db/'
2. Restores the remote application's database from this dump

#### Rebuild

1. db:rebuild (defers to 'db:rebuild:development')
2. db:rebuild:development
3. db:rebuild:test

These tasks do the following:

1. Kill all Postgres DB connections
2. Drop the database
3. Create the database
4. Run migrations
5. Seed the database

#### Kill

1. db:kill (defers to 'db:kill:development')
2. db:kill:development

These tasks do the following:

1. Forcably kills all processes conected to the Postgres database.

### Env

#### Push

1. envs:push (defers to 'envs:push:staging')
2. envs:push:staging
3. envs:push:production

These tasks do the following:

1. Loads envs from `.env` and from `.env.environment`, with envs from the latter overriding the former.
2. Adds these envs to the remote application

#### Print

1. envs:print (defers to 'envs:print:staging')
2. envs:print:development
3. envs:print:staging
4. envs:print:production

These tasks do the following:

1. Loads envs from `.env` and from `.env.environment`, with envs from the latter overriding the former.
2. Prints these envs to the console

## Installation

1. Clone the repo.

2. Add the following to your Gemfile:

```
gem "rake_tasks_for_rails", path: "path/to/cloned/rake_tasks_for_rails"
```