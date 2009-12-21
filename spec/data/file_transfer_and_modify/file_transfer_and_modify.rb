source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_ending_with "txt" do |file|
    move :file => file, :to => destination_folder do |old_file_name, new_file_name|
      old_file = File.new(old_file_name, "r")
      new_file = File.new(new_file_name, "w")

      old_file.readlines.each do |line|
        new_file << "# #{line}"
      end

      old_file.close
      new_file.close
    end
  end
end
