class Boatman
  class MonitoredDirectory
    include Copyable

    attr_accessor :path
    attr_accessor :match_data

    def initialize(path, match_data = nil)
      @path = path
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

      entry_paths = Dir.entries(@path).grep(/#{entry_pattern}/).collect do |name|
        "#{@path}/#{name}"
      end

      Boatman.logger.debug "Found #{entry_paths.size} entries in #{@path}"
      entry_paths.each do |entry_path|
        next if type == :file && !FTPUtils::FTPFile.file?(entry_path)
        next if type == :directory && !FTPUtils::FTPFile.directory?(entry_path)

        age = Time.now - FTPUtils::FTPFile.mtime(entry_path)
        next if @minimum_age && age < @minimum_age
        next if @maximum_age && age > @maximum_age

        match_data = FTPUtils::FTPFile.basename(entry_path).match(entry_pattern) if entry_pattern.is_a?(Regexp)
        case type
        when :file
          entry = MonitoredFile.new(entry_path, match_data)
        when :directory
          entry = MonitoredDirectory.new(entry_path, match_data)
        end

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

    private

    def copy_entry(source_path, destination_path, &block)
      FTPUtils.mkdir_p FTPUtils::FTPFile.dirname(destination_path)
      FTPUtils.cp_r source_path, destination_path
      
      if block_given?
        yield destination_path, "#{destination_path}.tmp"
        FTPUtils.cp_r "#{destination_path}.tmp", destination_path
        FTPUtils.rm_r "#{destination_path}.tmp"
      end
    end

  end
end
