require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Copying new files from one location to another" do

  before do
    @working_directory = File.expand_path(File.dirname(__FILE__) +
      '/data/file_transfer_no_destination_folder')
    FileUtils.mkdir_p(@working_directory + '/tmp/source')
    FileUtils.touch(@working_directory + '/tmp/source/datafile.txt')
  end

  it "should create the destination folder if it does not yet exist" do
    #$DEBUG = true
    boatman = Boatman.load(["#{@working_directory}/config.yml", @working_directory])
    thread = Thread.new do
      Boatman.run
    end
    sleep 2
    thread.exit

    File.exist?(@working_directory + '/tmp/destination/datafile.txt').should be_true
  end

  after do
    FileUtils.rm_rf(@working_directory + '/tmp')
  end

end