$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'boatman'
require 'spec'
require 'spec/autorun'

BOATMAN_BIN = File.expand_path(File.dirname(__FILE__) + '/../bin/boatman')

Spec::Runner.configure do |config|
  config.before(:each) { Boatman.tasks = nil }
end
