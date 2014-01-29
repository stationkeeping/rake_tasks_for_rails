require 'rake_tasks_for_rails/config'
require 'rake_tasks_for_rails/envs'

namespace :envs do

  namespace :push do

    desc 'Add envs in .env and .env.staging to staging environment'
    task :staging do
      RakeTasksForRails::Envs.push(RakeTasksForRails::Config.staging_app_name,
        RakeTasksForRails::Config::STAGING_ENVIRONMENT)
    end

    desc 'Add envs in .env and .env.production to production environment'
    task :production do
      RakeTasksForRails::Envs.push(RakeTasksForRails::Config.production_app_name,
        RakeTasksForRails::Config::PRODUCTION_ENVIRONMENT)
    end

  end

  desc "Default to 'envs:push:staging'"
  task :push => 'envs:push:staging'

  namespace :print do

    desc 'Print envs in .env and .env.production'
    task :development do
      RakeTasksForRails::Envs.load_envs(RakeTasksForRails::Config::DEVELOPMENT_ENVIRONMENT)
    end

    desc 'Print envs in .env and .env.staging'
    task :staging do
      RakeTasksForRails::Envs.load_envs(RakeTasksForRails::Config::STAGING_ENVIRONMENT)
    end

    desc 'Print envs in .env and .env.production'
    task :production do
      RakeTasksForRails::Envs.load_envs(RakeTasksForRails::Config::PRODUCTION_ENVIRONMENT)
    end

  end

  desc "Default to 'envs:print:development'"
  task :print => 'envs:print:development'

end