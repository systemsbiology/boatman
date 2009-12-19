source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_ending_with "txt" do |file|
    move file => destination_folder
  end
end
