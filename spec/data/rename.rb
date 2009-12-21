source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_ending_with "txt" do |file|
    new_name = "renamed_" + File.basename(file.path)

    move :file => file, :to => destination_folder, :rename => new_name
  end
end
