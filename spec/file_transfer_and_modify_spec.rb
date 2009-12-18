require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Moving new files from one location to another with modifications" do

  before do
    #require 'rubygems';require 'ruby-debug';debugger
    @working_directory = File.expand_path(File.dirname(__FILE__) + '/data/file_transfer_and_modify')
    FileUtils.mkdir_p(@working_directory + '/tmp/source')
    FileUtils.mkdir_p(@working_directory + '/tmp/destination')
    datafile = File.new(@working_directory + '/tmp/source/datafile.txt', "w")
    datafile << "Some text"
    datafile.close
    Boatman.tasks = Array.new
  end

  it "should copy files from one folder to another" do
    boatman = Boatman.load(["#{@working_directory}/config.yml", @working_directory])
    thread = Thread.new do
      Boatman.run
    end
    sleep 2
    thread.exit

    File.exist?(@working_directory + '/tmp/destination/datafile.txt').should be_true
    File.new(@working_directory + '/tmp/destination/datafile.txt').readlines.should ==
      ["# Some text"]
  end

  after do
    FileUtils.rm_rf(@working_directory + '/tmp')
  end

end
