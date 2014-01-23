# Env loading and parsing cribbed from Dotenv

module RakeTasksForRails

  module Envs

    @@LINE = /
      \A
      (?:export\s+)?    # optional export
      ([\w\.]+)         # key
      (?:\s*=\s*|:\s+?) # separator
      (                 # optional value begin
        '(?:\'|[^'])*'  #   single quoted value
        |               #   or
        "(?:\"|[^"])*"  #   double quoted value
        |               #   or
        [^#\n]+         #   unquoted value
      )?                # value end
      (?:\s*\#.*)?      # optional comment
      \z
    /x

    def self.push(app_name, environment)
      puts "Pushing Envs for #{environment}"
      envs = self.load_envs(environment)
      envs_string = envs.map{|key, value| "#{key}=#{value}"}.join(" ")
      `heroku config:set #{envs_string} -a #{app_name}`
      puts "Pushed Envs"
    end

    def self.load_envs(environment)
      envs = {}
      self.load_file(".env", envs) if File.exists?(".env")
      environment_env_basename = ".env.#{environment}"
      self.load_file(environment_env_basename, envs) if File.exists?(environment_env_basename)
      puts "Loaded envs for #{environment}:"
      envs.each{|key, value| puts "   #{key}=#{value}"}
      return envs
    end

    def self.load_file(filename, envs)
      puts "loading envs from #{filename}"
      File.read(filename).split("\n").each do|line|

        if match = line.match(@@LINE)
          key, value = match.captures

          value ||= ''
          # Remove surrounding quotes
          value = value.strip.sub(/\A(['"])(.*)\1\z/, '\2')

          if $1 == '"'
            value = value.gsub('\n', "\n")
            # Unescape all characters except $ so variables can be escaped properly
            value = value.gsub(/\\([^$])/, '\1')
          end

          envs[key] = value
        elsif line !~ /\A\s*(?:#.*)?\z/ # not comment or blank line
          raise FormatError, "Line #{line.inspect} doesn't match format"
        end
      end
    end

  end

end