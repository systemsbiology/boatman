require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Copying new files from one location to another" do

  before do
    @working_directory = File.expand_path(File.dirname(__FILE__) + '/data/file_transfer_and_rename')
    FileUtils.mkdir_p(@working_directory + '/tmp/source')
    FileUtils.mkdir_p(@working_directory + '/tmp/destination')
    FileUtils.touch(@working_directory + '/tmp/source/datafile.txt')
  end

  it "should copy and rename a file" do
    #$DEBUG = true
    boatman = Boatman.load(["#{@working_directory}/config.yml", @working_directory])
    thread = Thread.new do
      Boatman.run
    end
    sleep 2
    thread.exit

    File.exist?(@working_directory + '/tmp/destination/renamed_datafile.txt').should be_true
  end

  after do
    FileUtils.rm_rf(@working_directory + '/tmp')
  end

end
