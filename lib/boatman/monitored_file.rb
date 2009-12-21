class MonitoredFile
  attr_accessor :path
  attr_accessor :match_data

  def initialize(file_path, match_data = nil)
    @path = file_path
    @match_data = match_data
  end

  def disable_checksum_verification
    @checksum_verification_disabled = true
  end

  def copy(params, &block)
    source_path = params[:file].path
    base_name = params[:rename] || File.basename(source_path)

    destination_path = File.expand_path(params[:to] + "/" + base_name) 

    return if File.exists?(destination_path)

    begin
      copy_file(source_path, destination_path, &block)
      Boatman.logger.info "Successfully copied #{source_path} to #{destination_path}"
    rescue Exception => e
      Boatman.logger.error e.message
    end
  end

  def move(params, &block)
    source_path = params[:file].path
    base_name = params[:rename] || File.basename(source_path)

    destination_path = File.expand_path(params[:to] + "/" + base_name) 
    
    return if File.exists?(destination_path)

    begin
      copy_file(source_path, destination_path, &block)
      FileUtils.rm source_path

      Boatman.logger.info "Successfully moved #{source_path} to #{destination_path}"
    rescue Exception => e
      Boatman.logger.error e.message
    end
  end

  private

  def copy_file(source_path, destination_path, &block)
    FileUtils.mkdir_p File.dirname(destination_path)
    FileUtils.cp source_path, destination_path
    
    unless @checksum_verification_disabled
      verify_checksum_matches(source_path, destination_path, &block)
    end

    if block_given?
      yield destination_path, "#{destination_path}.tmp"
      FileUtils.cp "#{destination_path}.tmp", destination_path
      FileUtils.rm "#{destination_path}.tmp"
    end
  end

  def verify_checksum_matches(file_1, file_2)
    file_1_digest = Digest::MD5.hexdigest( File.read(file_1) )
    file_2_digest = Digest::MD5.hexdigest( File.read(file_2) )
    raise "Checksum verification failed when copying #{base_name}" unless  file_1_digest == file_2_digest
  end
end
