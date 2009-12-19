source_folder.check_every 1.seconds do
  age :greater_than => 0.minutes

  files_ending_with /(_R|_G)\.tif/ do |file|
    move file => destination_folder
  end
end
