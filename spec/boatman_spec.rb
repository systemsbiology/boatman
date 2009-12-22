require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Moving new files from one location to another" do

  before(:each) do
    @working_directory = File.expand_path(File.dirname(__FILE__) + '/data')
    FileUtils.mkdir_p(@working_directory + '/tmp/source')
    FileUtils.mkdir_p(@working_directory + '/tmp/destination')
  end

  def run_boatman
    thread = Thread.new do
      Boatman.run
    end
    sleep 2
    thread.exit
  end

  it "should move based on filename ending" do
    FileUtils.touch(@working_directory + '/tmp/source/datafile.txt')

    boatman = Boatman.load(["#{@working_directory}/filename_ending.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/datafile.txt').should be_true
  end

  it "should create the destination folder if it does not yet exist" do
    FileUtils.rm_rf(@working_directory + '/tmp/destination')
    FileUtils.touch(@working_directory + '/tmp/source/datafile.txt')

    boatman = Boatman.load(["#{@working_directory}/no_destination_folder.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/datafile.txt').should be_true
  end

  it "should move based on regular expression match to filename ending" do
    FileUtils.touch(@working_directory + '/tmp/source/datafile_R.tif')
    FileUtils.touch(@working_directory + '/tmp/source/datafile.tif')

    boatman = Boatman.load(["#{@working_directory}/filename_ending_regexp.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/datafile_R.tif').should be_true
    File.exist?(@working_directory + '/tmp/destination/datafile.tif').should be_false
  end

  it "should move and modify a file" do
    datafile = File.new(@working_directory + '/tmp/source/datafile.txt', "w")
    datafile << "Some text"
    datafile.close

    boatman = Boatman.load(["#{@working_directory}/modify.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/datafile.txt').should be_true
    File.new(@working_directory + '/tmp/destination/datafile.txt').readlines.should ==
      ["# Some text"]
  end

  it "should move and rename a file" do
    FileUtils.touch(@working_directory + '/tmp/source/datafile.txt')

    boatman = Boatman.load(["#{@working_directory}/rename.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/renamed_datafile.txt').should be_true
  end

  it "should move a file based on a regular expression on the entire filename" do
    FileUtils.touch(@working_directory + '/tmp/source/datafile.txt')
  
    boatman = Boatman.load(["#{@working_directory}/filename_regexp.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/datafile.txt').should be_true
  end

  it "should move a folder based on its name" do
    FileUtils.mkdir(@working_directory + '/tmp/source/bob')
  
    boatman = Boatman.load(["#{@working_directory}/folder.yml", @working_directory])
    run_boatman

    File.exist?(@working_directory + '/tmp/destination/bob').should be_true
    File.directory?(@working_directory + '/tmp/destination/bob').should be_true
  end

  after(:each) do
    FileUtils.rm_rf(@working_directory + '/tmp')
  end

end
