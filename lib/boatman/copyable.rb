class Boatman
  module Copyable
    def copy(file, params, remove_original=false, &block)
      source_path = file.path
      base_name = params[:rename] || FTPUtils::FTPFile.basename(source_path)

      destination_path = FTPUtils::FTPFile.expand_path(params[:to] + "/" + base_name) 

      return if FTPUtils::FTPFile.exists?(destination_path)

      begin
        copy_entry(source_path, destination_path, &block)
        FTPUtils.rm_r source_path if remove_original

        Boatman.logger.info "Successfully copied #{source_path} to #{destination_path}"
      rescue Exception => e
        # remove the possibly incorrect destination file 
        FTPUtils.rm_r "#{destination_path}" rescue nil
        Boatman.logger.error "#{e.message} at #{e.backtrace[0]}"
      end
    end

    def move(file, params, &block)
      copy(file, params, remove_original=true, &block)
    end
  end
end
