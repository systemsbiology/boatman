class Boatman
  module Copyable
    def copy(file, params, remove_original=false, &block)
      source_path = file.path
      base_name = params[:rename] || File.basename(source_path)

      destination_path = File.expand_path(params[:to] + "/" + base_name) 

      return if File.exists?(destination_path)

      begin
        copy_entry(source_path, destination_path, &block)
        FileUtils.rm_r source_path if remove_original

        Boatman.logger.info "Successfully copied #{source_path} to #{destination_path}"
      rescue Exception => e
        Boatman.logger.error e.message
      end
    end

    def move(file, params, &block)
      copy(file, params, remove_original=true, &block)
    end
  end
end
