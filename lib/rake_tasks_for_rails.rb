require "rake_tasks_for_rails/version"

module RakeTasksForRails
  require 'rake_tasks_for_rails/railtie' if defined?(Rails)

  module Config

    def staging_app_name
      ENV["HEROKU_STAGING_APP_NAME"] || "#{File.basename(Rails.root)}-staging"
    end

    def production_app_name
      ENV["HEROKU_PRODUCTION_APP_NAME"] || "#{File.basename(Rails.root)}-production"
    end

    def staging_remote
      ENV["REMOTE_STAGING_NAME"] || "staging"
    end

    def production_remote
      ENV["REMOTE_PRODUCTION_NAME"] || "production"
    end

    def development_database_name
      ENV["DEVELOPMENT_DATABASE_NAME"} || "#{File.basename(Rails.root)}_development"
    end

    def dropbox_access_token
      ENV["DROPBOX_ACCESS_TOKEN"] || throw "You must set the 'DROPBOX_ACCESS_TOKEN' env"
    end

  end
end
