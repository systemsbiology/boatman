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

    file_pattern = File.expand_path(@directory_path + "/*" + file_ending)

    file_names = Dir.glob(file_pattern)
    Boatman.logger.debug "Found #{file_names.size} files in #{file_pattern}"
    file_names.each do |file_name|
      age = Time.now - File.mtime(file_name)
      Boatman.logger.debug "Age in seconds of #{file_name} is #{age}"
      next if @minimum_age && age < @minimum_age
      next if @maximum_age && age > @maximum_age

      file = MonitoredFile.new(file_name)
      file.instance_eval &block
    end
  end
end
