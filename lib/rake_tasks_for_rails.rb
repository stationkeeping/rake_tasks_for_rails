require "rake_tasks_for_rails/version"

module RakeTasksForRails
  require 'rake_tasks_for_rails/railtie' if defined?(Rails)
end
