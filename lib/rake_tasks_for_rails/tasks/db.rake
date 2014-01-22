require 'rake_tasks_for_rails/config'
require 'rake_tasks_for_rails/db'
require 'dropbox_sdk'

namespace :db do

  namespace :push do

    desc "Dump development database, upload to Dropbox and restore staging from it"
    task :staging => :environment do
      RakeTasksForRails::DB.push(RakeTasksForRails::Config.staging_app_name)
    end

    task :production => :environment do
      RakeTasksForRails::DB.push(RakeTasksForRails::Config.production_app_name)
    end

  end

  desc "Kill Postgres connections, Drop, create, migrate then seed the database"
  task :rebuild => [:environment, "db:kill", "db:drop", "db:create", "db:migrate", "db:seed"]

  desc "Kill Postgres connections, Drop, create then migrate the database with RAILS_ENV=test"
  task :rebuild_test => [:environment, "db:set_test_environment", "db:kill", "db:drop", "db:create", "db:migrate"]

  desc "Kill all Postgres connections"
  task :kill => :environment do
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