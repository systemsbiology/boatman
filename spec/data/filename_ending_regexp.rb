source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_ending_with /(_R|_G)\.tif/ do |file|
    move :file => file, :to => destination_folder
  end
end
