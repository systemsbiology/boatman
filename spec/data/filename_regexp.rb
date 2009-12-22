source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_matching /.*file.*\.txt/ do |file|
    move file, :to => destination_folder
  end
end
