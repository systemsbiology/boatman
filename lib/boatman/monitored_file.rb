class Boatman
  class MonitoredFile
    include Copyable

    attr_accessor :path
    attr_accessor :match_data

    def initialize(file_path, match_data = nil)
      @path = file_path
      @match_data = match_data
    end

    def disable_checksum_verification
      @checksum_verification_disabled = true
    end

    private

    def copy_entry(source_path, destination_path, &block)
      FTPUtils.mkdir_p FTPUtils::FTPFile.dirname(destination_path)

      if block_given?
        yield source_path, "#{destination_path}.tmp"
        FTPUtils.cp "#{destination_path}.tmp", destination_path
        FTPUtils.rm "#{destination_path}.tmp"
      else
        FTPUtils.cp source_path, destination_path
        
        unless @checksum_verification_disabled
          verify_checksum_matches(source_path, destination_path, &block)
        end
      end
    end

    def verify_checksum_matches(file_1, file_2)
      file_1_digest = incremental_digest(file_1)
      file_2_digest = incremental_digest(file_2)
      raise "Checksum verification failed when copying #{base_name}" unless  file_1_digest == file_2_digest
    end

    def incremental_digest(file_name)
      file = open(file_name, "r")

      digester = Digest::MD5.new
      file.each_line do |line|
        digester << line
      end

      file.close

      return digester.hexdigest
    end
  end
end
