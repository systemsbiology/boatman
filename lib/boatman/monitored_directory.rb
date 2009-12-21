class MonitoredDirectory
  def initialize(directory_path)
    @directory_path = directory_path
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

  def files_matching(file_pattern, &block)
    @minimum_age ||= false
    @maximum_age ||= false

    file_paths = Dir.entries(@directory_path).grep(/#{file_pattern}/).collect do |name|
      "#{@directory_path}/#{name}"
    end

    Boatman.logger.debug "Found #{file_paths.size} files in #{@directory_path}"
    file_paths.each do |file_path|
      age = Time.now - File.mtime(file_path)
      next if @minimum_age && age < @minimum_age
      next if @maximum_age && age > @maximum_age

      match_data = file_path.match(file_pattern) if file_pattern.is_a?(Regexp)
      file = MonitoredFile.new(file_path, match_data)
      file.instance_eval &block
    end
  end

  def files_ending_with(file_ending, &block)
    return files_matching(/#{file_ending}$/, &block)
  end
end
