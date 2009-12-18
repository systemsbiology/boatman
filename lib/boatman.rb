$DEBUG = true
require "yaml"
require "digest/md5"

require "boatman/ext/class"
require "boatman/ext/string"
require "boatman/ext/fixnum"

require "boatman/monitored_directory.rb"
require "boatman/monitored_file.rb"

class Boatman 
  cattr_accessor :tasks

  def self.load(args)
    if(args.size < 1 || args.size > 2)
      Boatman.print_usage
      exit(0)
    end

    @config_file = args[0]

    @working_directory = args[1] || "."
    puts "working directory: #{@working_directory}" if $DEBUG

    load_config_file(args[0])
  end

  def self.load_config_file(file)
    puts "loading #{@config_file}" if $DEBUG
    config = YAML.load_file(@config_file)

    @task_files = config["tasks"]

    config["directories"].each do |key, value|
      Object.class_eval do
        define_method(key) do
          return value
        end
      end
    end
  end

  def self.print_usage
    puts "Usage: boatman <config file> [<working directory>]"
  end

  def self.run
    @task_files.each do |task_file|
      require "#{@working_directory}/#{task_file}"
      puts "Added task #{task_file}"
    end

    interrupted = false
    trap("INT") { interrupted = true }
    
    while true do
      if interrupted
        puts "Exiting from boatman"
        return
      end

      tasks.each do |task|
        if task[:last_run].nil? || Time.now - task[:last_run] > task[:time_interval]
          # do everything in the context of the working directory
          Dir.chdir(@working_directory) do
            task[:directory].instance_eval &task[:block]
          end

          task[:last_run] = Time.now
        end
      end
      
      sleep 1
    end
  end
end
