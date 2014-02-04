require 'rake_tasks_for_rails/config'
require 'rake_tasks_for_rails/assets'

namespace :app do

  namespace :push do

    desc "Push to Heroku staging app"
    task :staging  => :environment do
      Rake::Task['app:push:implementation'].invoke(RakeTasksForRails::Config.staging_app_name,
        RakeTasksForRails::Config.staging_remote, RakeTasksForRails::Config::STAGING_ENVIRONMENT)
    end

    desc "Push to Production staging app"
    task :production  => :environment do
      Rake::Task['shared:confirm'].invoke("Push application to production", RakeTasksForRails::Config.production_app_name)
      Rake::Task['app:push:implementation'].invoke(RakeTasksForRails::Config.production_app_name,
        RakeTasksForRails::Config.production_remote, RakeTasksForRails::Config::PRODUCTION_ENVIRONMENT)
    end

    task :implementation, [:app_name, :remote, :environment]  => :environment do |t, args|
      puts "Checking for changes in `app/assets` ..."
      if RakeTasksForRails::Assets.assets_changed?(args[:app_name], args[:remote])
        puts "Changes detected. Precompiling assets"
        # Set the appropriate environment before precompilation
        system("RAILS_ENV=#{args[:environment]} rake app:push:force_precompile")
        puts "Comitting changes to 'public/assets/manifest'"
        `git add public/assets/manifest*.*`
        `git commit -m "Add updated asset manifest"`
      end
      puts "Pushing changes ..."
      `git push #{args[:remote]} master`
      puts "Running Migrations ..."
      `heroku run rake db:migrate -a #{:app_name}`
      puts "Done"
    end

    # By wrapping rake assets:precompile in a separate task with a dependency on environment we
    # force it to reload the environment
    desc "Force precompile in given environment"
    task :force_precompile => :environment do
      system("rake assets:precompile --trace")
    end

  end

  desc "Default to 'app:push:staging'"
  task :push => "app:push:staging"

end