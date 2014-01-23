require 'rake_tasks_for_rails/config'
require 'rake_tasks_for_rails/db'
require 'dropbox_sdk'

namespace :db do

  namespace :push do

    desc "Dump development database, upload to Dropbox and restore staging database from it"
    task :staging => :environment do
      RakeTasksForRails::DB.push(RakeTasksForRails::Config.staging_app_name)
    end

    desc "Dump development database, upload to Dropbox and restore production database from it"
    task :production => :environment do
      RakeTasksForRails::DB.push(RakeTasksForRails::Config.production_app_name)
    end

  end

  task

  namespace :rebuid do

    desc "Kill Development Postgres DB connections, drop, create, migrate then seed the database"
    task :development => [:environment, "db:kill", "db:drop", "db:create", "db:migrate", "db:seed"]

    desc "Kill Postgres connections, Drop, create then migrate the database with RAILS_ENV=test"
    task :test => [:environment, "db:set_test_environment", "db:kill", "db:drop", "db:create", "db:migrate"]

  end

  namespace :kill do

    desc "Kill all Postgres connections"
    task :development => :environment do
    sh = <<EOF
ps xa \
| grep postgres: \
| grep #{RakeTasksForRails::Config.development_database_name} \
| grep -v grep \
| awk '{print $1}' \
| xargs kill
EOF
      puts `#{sh}`
    end

  end

end