namespace :app do

  desc "Push app to Heroku, prcompiling assets if any changes have been made"
  task :push do
    puts "Checking for changes in `app/assets` ..."
    if assets_changed?
      puts "Changes detected. Precompiling assets"
      Rake::Task['rake:assets:precompile'].invoke
      puts "Comitting changes to 'public/assets/manifest.yml'"
      `git add public/assets/manifest.yml`
      `git commit -m "Add updated asset manifest"`
    end
    puts "Pushing changes ..."
    `git push staging master`
    puts "Done"
  end

  desc "Rebuild locally from scratch"
  task :rebuild => ["db:rebuild"]

  def assets_changed?
    # Create a hash using the contents of 'app/assets/' and compare it to the saved hash.
    # If the hashes are identical we know nothing has changed. If they are different, something has
    # chnaged, so replace the old hash with the new for comparison next time.
    asset_hash_file_path = ENV["ASSET_HASH_FILE_PATH"]
    current_hash = Zlib::crc32(Dir.glob("app/assets/**/*").map { |name| [name, File.mtime(name)] }.to_s).to_s
    if File.exists?(asset_hash_file_path)
      previous_hash = File.read(asset_hash_file_path)
    end
    if previous_hash.blank? || current_hash != previous_hash
      File.open(asset_hash_file_path, 'w') {|f| f.write(current_hash) }
      true
    else
      false
    end
  end

end