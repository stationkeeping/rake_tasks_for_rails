module RakeTasksForRails

  module Config

    def self.app_name
      File.basename(Rails.root)
    end

    def self.staging_app_name
      ENV["HEROKU_STAGING_APP_NAME"] || "#{app_name}-staging"
    end

    def self.production_app_name
      ENV["HEROKU_PRODUCTION_APP_NAME"] || "#{app_name}-production"
    end

    def self.staging_remote
      ENV["REMOTE_STAGING_NAME"] || "staging"
    end

    def self.production_remote
      ENV["REMOTE_PRODUCTION_NAME"] || "production"
    end

    def self.development_database_name
      ENV["DEVELOPMENT_DATABASE_NAME"] || "#{app_name}_development"
    end

    def self.dropbox_access_token
      ENV["DROPBOX_ACCESS_TOKEN"] || raise("You must set the 'DROPBOX_ACCESS_TOKEN' env")
    end

    def self.asset_hash_dirname
      ENV["ASSET_HASH_FILE_PATH"] || "tmp"
    end

  end
end