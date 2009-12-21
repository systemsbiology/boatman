source_folder.check_every 1.second do
  age :greater_than => 0.minutes

  files_ending_with "txt" do |file|
    #require 'rubygems'; require 'ruby-debug'; debugger
    move :file => file, :to => destination_folder
  end
end
