begin
  require "ftputils"
rescue LoadError
  require "rubygems"
  require "ftputils"
end

require "yaml"
require "digest/md5"

require "boatman/ext/class"
require "boatman/ext/string"
require "boatman/ext/fixnum"

require "boatman/copyable"
require "boatman/monitored_directory"
require "boatman/monitored_file"

class Boatman 
  cattr_accessor :tasks
  cattr_accessor :logger

  def self.load(args)
    if(args.size < 1 || args.size > 2)
      Boatman.print_usage
      exit(0)
    end

    puts "Logging to boatman.log"
    require 'logger'
    Boatman.logger = Logger.new("boatman.log")
    logger.level = Logger::INFO

    @config_file = args[0]

    @working_directory = args[1] || "."
    Boatman.logger.info "Working directory: #{@working_directory}"

    load_config_file(args[0])
  end

  def self.load_config_file(file)
    Boatman.logger.info  "Loading Config File: #{@config_file}"
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
          begin
            # do everything in the context of the working directory
            puts "Going to check #{task[:directory].path} at #{Time.now}" if $DEBUG
            Dir.chdir(@working_directory) do
              task[:directory].instance_eval &task[:block]
            end
            puts "Leaving #{task[:directory].path} at #{Time.now}" if $DEBUG
          rescue Exception => e
            Boatman.logger.error "Task had an error: #{e.message}" rescue nil
          end

          task[:last_run] = Time.now
        end
      end
      
      sleep 1
    end
  end
end
