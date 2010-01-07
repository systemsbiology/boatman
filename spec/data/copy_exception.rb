source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_ending_with "txt" do |file|
    copy file, :to => destination_folder do |old_file_name, new_file_name|
      raise "something went horribly wrong"
    end
  end
end
