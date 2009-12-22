class Boatman
  class MonitoredDirectory
    attr_accessor :directory_path
    attr_accessor :match_data

    def initialize(directory_path, match_data = nil)
      @directory_path = directory_path
      @match_data = match_data
    end

    def age(params)
      params.each do |key, value|
        case key
        when :greater_than
          @minimum_age = value
        when :less_than
          @maximum_age = value
        end
      end
    end

    def entries_matching(entry_pattern, type, &block)
      @minimum_age ||= false
      @maximum_age ||= false

      entry_paths = Dir.entries(@directory_path).grep(/#{entry_pattern}/).collect do |name|
        "#{@directory_path}/#{name}"
      end

      Boatman.logger.debug "Found #{entry_paths.size} entries in #{@directory_path}"
      entry_paths.each do |entry_path|
        next if type == :file && !File.file?(entry_path)
        next if type == :directory && !File.directory?(entry_path)

        age = Time.now - File.mtime(entry_path)
        next if @minimum_age && age < @minimum_age
        next if @maximum_age && age > @maximum_age

        match_data = entry_path.match(entry_pattern) if entry_pattern.is_a?(Regexp)
        entry = MonitoredFile.new(entry_path, match_data)
        entry.instance_eval &block
      end
    end

    def files_matching(file_pattern, &block)
      return entries_matching(file_pattern, type = :file, &block)
    end

    def files_ending_with(file_ending, &block)
      return files_matching(/#{file_ending}$/, &block)
    end

    def folders_matching(folder_pattern, &block)
      return entries_matching(folder_pattern, type = :directory, &block)
    end

    def folders_ending_with(folder_ending, &block)
      return folders_matching(/#{folder_ending}$/, &block)
    end
  end
end
