require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Moving files based on regexp ending" do

  before do
    @working_directory = File.expand_path(File.dirname(__FILE__) + '/data/file_transfer_by_regexp')
    FileUtils.mkdir_p(@working_directory + '/tmp/source')
    FileUtils.mkdir_p(@working_directory + '/tmp/destination')
    FileUtils.touch(@working_directory + '/tmp/source/datafile_R.tif')
    FileUtils.touch(@working_directory + '/tmp/source/datafile.tif')
  end

  it "should move only files with the correct ending" do
    #$DEBUG = true
    boatman = Boatman.load(["#{@working_directory}/config.yml", @working_directory])
    thread = Thread.new do
      Boatman.run
    end
    sleep 2
    thread.exit

    File.exist?(@working_directory + '/tmp/destination/datafile_R.tif').should be_true
    File.exist?(@working_directory + '/tmp/destination/datafile.tif').should be_false
  end

  after do
    FileUtils.rm_rf(@working_directory + '/tmp')
  end

end
