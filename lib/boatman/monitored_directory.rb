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

  def files_ending_with(file_ending, &block)
    @minimum_age ||= false
    @maximum_age ||= false

    file_paths = Dir.entries(@directory_path).grep(/#{file_ending}$/).collect do |name|
      "#{@directory_path}/#{name}"
    end

    Boatman.logger.debug "Found #{file_paths.size} files in #{@directory_path}"
    file_paths.each do |file_path|
      age = Time.now - File.mtime(file_path)
      Boatman.logger.debug "Age in seconds of #{file_path} is #{age}"
      next if @minimum_age && age < @minimum_age
      next if @maximum_age && age > @maximum_age

      file = MonitoredFile.new(file_path)
      file.instance_eval &block
    end
  end
end
