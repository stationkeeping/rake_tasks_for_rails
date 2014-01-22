module RakeTasksForRails

  class Assets

    def self.assets_changed?(app_name, remote)
      # Create a hash using the contents of 'app/assets/' and compare it to the saved hash.
      # If the hashes are identical we know nothing has changed. If they are different, something has
      # chnaged, so replace the old hash with the new for comparison next time.
      asset_hash_basename = "#{app_name}_#{remote}.txt"
      asset_hash_filename = File.expand_path(File.join(RakeTasksForRails::Config.asset_hash_dirname, asset_hash_basename))
      current_hash = Zlib::crc32(Dir.glob("app/assets/**/*").map { |name| [name, File.mtime(name)] }.to_s).to_s

      if File.exists?(asset_hash_filename)
        previous_hash = File.read(asset_hash_filename)
      end

      # Two situations where we want to precompile:
      # 1. There is, but it doesn't match the current hash
      # 2. There is no manifest
      if current_hash != previous_hash || !self.manifest_exists?
        File.open(asset_hash_filename, 'w') {|f| f.write(current_hash) }
        true
      else
        false
      end
    end

    def self.manifest_exists?
      Dir.glob("public/assets/manifest*.*").any?
    end

  end
end
