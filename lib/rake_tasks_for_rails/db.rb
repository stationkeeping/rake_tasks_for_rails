module RakeTasksForRails

  module DB

    def self.push(app_name)
      dump_basename = "#{RakeTasksForRails::Config.development_database_name}.dump"
      dump_dirname = "tmp/db"
      dump_filename = File.expand_path(File.join(dump_dirname, dump_basename))
      dump_dropbix_public_path = "public/tmp/db/#{dump_basename}"
      # Dump database
      puts "Dumping database to #{dump_dropbix_public_path}"
      `mkdir -p #{File.expand_path(dump_dirname)}`
      if File.exists?(dump_filename)
        `rm #{dump_filename}`
      end
      `pg_dump -Fc --no-acl --no-owner -h localhost -U $(whoami) #{RakeTasksForRails::Config.development_database_name} > #{dump_filename}`
      # Upload to Dropbox
      puts "Uploading to Dropbox ..."
      client = DropboxClient.new(RakeTasksForRails::Config.dropbox_access_token)
      file = open(dump_filename)
      response = client.put_file(dump_dropbix_public_path, file, true)
      dump_public_url = client.media(dump_dropbix_public_path)["url"]
      puts "Uploaded dump to #{dump_public_url}"
      puts "Restoring database to #{app_name} ..."
      `heroku pgbackups:restore DATABASE #{dump_public_url} --confirm #{app_name}`
      puts "Done"
    end

  end

end