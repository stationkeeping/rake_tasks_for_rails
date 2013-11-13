require 'rake_tasks_for_rails'
require 'rails'
module RakeTasksForRails
  class Railtie < Rails::Railtie
    railtie_name :rake_tasks_for_rails

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end