require 'dropbox_sdk'

namespace :db do

  desc "Dump development database, upload to Dropbox and restore staging from it"
  task :push => :environment do
    db_name = db_name = "#{ENV["DEVELOPMENT_DATABASE_ROOTNAME"] || File.basename(Rails.root)}_development"
    db_file = "#{db_name}.dump"
    dump_dir = "tmp/db"
    dump_path = File.expand_path(File.join(dump_dir, db_file))
    dump_public_path = "public/tmp/db/#{db_file}"
    staging_app_name = ENV["HEROKU_STAGING_APP_NAME"] || "#{File.basename(Rails.root)}-staging"
    # Dump database
    puts "Dumping database to #{dump_public_path}"
    `mkdir -p #{File.expand_path(dump_dir)}`
    `rm #{dump_path}`
    `pg_dump -Fc --no-acl --no-owner -h localhost -U $(whoami) #{db_name} > #{dump_path}`
    # Upload to Dropbox
    puts "Uploading to Dropbox ..."
    client = DropboxClient.new(ENV["DROPBOX_ACCESS_TOKEN"])
    file = open(dump_path)
    response = client.put_file(dump_public_path, file, true)
    dump_public_url = client.media(dump_public_path)["url"]
    puts "Uploaded dump to #{dump_public_url}"
    puts "Restoring database to staging ..."
    `heroku pgbackups:restore DATABASE #{dump_public_url} --confirm #{staging_app_name}`
    puts "Done"
  end

  desc "Kill Postgres connections, Drop, create, migrate then seed the database"
  task :rebuild => [:environment, "db:kill", "db:drop", "db:create", "db:migrate", "db:seed"]

  desc "Kill Postgres connections, Drop, create then migrate the database with RAILS_ENV=test"
  task :rebuild_test => [:environment, "db:set_test_environment", "db:kill", "db:drop", "db:create", "db:migrate"]

  desc "Kill all Postgres connections"
  task :kill => :environment do
    db_name = "#{File.basename(Rails.root)}_#{Rails.env}"
    sh = <<EOF
ps xa \
| grep postgres: \
| grep #{db_name} \
| grep -v grep \
| awk '{print $1}' \
| xargs kill
EOF
    puts `#{sh}`
  end

end