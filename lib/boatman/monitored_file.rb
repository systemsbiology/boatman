class MonitoredFile < File

  def initialize(file_path)
    super(file_path)
  end

  def disable_checksum_verification
    @checksum_verification_disabled = true
  end

  def move(params)
    raise "move takes a hash of file => destination folder" unless params.instance_of?(Hash)
    
    params.each do |file, destination|
      source_path = file.path
      base_name = File.basename(source_path)

      if(destination =~ /^\//)
        destination_path = File.expand_path(destination + "/" + base_name)
      else
        destination_path = File.expand_path(working_directory + "/" + destination + "/" + base_name)
      end

      next if File.exists?(destination_path)

      FileUtils.cp file.path, destination_path
      
      unless @checksum_verification_disabled
        verify_checksum_matches(file.path, destination_path)
      end

      if block_given?
        yield destination_path, "#{destination_path}.tmp"
        FileUtils.cp "#{destination_path}.tmp", destination_path
        FileUtils.rm "#{destination_path}.tmp"
      end

      FileUtils.rm file.path
    end
  end

  def verify_checksum_matches(file_1, file_2)
    file_1_digest = Digest::MD5.hexdigest( File.read(file_1) )
    file_2_digest = Digest::MD5.hexdigest( File.read(file_2) )
    raise "Checksum verification failed when copying #{base_name}" unless  file_1_digest == file_2_digest
  end
end
