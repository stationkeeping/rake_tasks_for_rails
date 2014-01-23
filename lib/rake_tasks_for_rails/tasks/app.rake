require 'rake_tasks_for_rails/config'
require 'rake_tasks_for_rails/assets'

namespace :app do

  namespace :push do

    desc "Push to Heroku staging app"
    task :staging  => :environment do
      Rake::Task['app:push:implementation'].invoke(RakeTasksForRails::Config.staging_app_name,
        RakeTasksForRails::Config.staging_remote)
    end

    desc "Push to Production staging app"
    task :production  => :environment do
      Rake::Task['app:push:implementation'].invoke(RakeTasksForRails::Config.production_app_name,
        RakeTasksForRails::Config.production_remote)
    end

    task :implementation, [:app_name, :remote]  => :environment do |t, args|
      puts "Checking for changes in `app/assets` ..."
      if RakeTasksForRails::Assets.assets_changed?(args[:app_name], args[:remote])
        puts "Changes detected. Precompiling assets"
        Rake::Task['rake:assets:precompile'].invoke
        puts "Comitting changes to 'public/assets/manifest'"
        `git add public/assets/manifest*.*`
        `git commit -m "Add updated asset manifest"`
      end
      puts "Pushing changes ..."
      `git push #{args[:remote]} master`
      puts "Running Migrations ..."
      'heroku run rake db:migrate -a #{:app_name}'
      puts "Done"
    end

  end

  # See db:rebuid
  desc "Rebuild locally from scratch"
  task :rebuild => ["db:rebuild"]

end