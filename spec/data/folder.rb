source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  folders_matching "bob" do |file|
    move file, :to => destination_folder
  end
end
