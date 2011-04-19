# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{boatman}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bruz Marzolf"]
  s.date = %q{2011-04-19}
  s.default_executable = %q{boatman}
  s.description = %q{}
  s.email = %q{bmarzolf@systemsbiology.org}
  s.executables = ["boatman"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/boatman",
    "lib/boatman.rb",
    "lib/boatman/copyable.rb",
    "lib/boatman/ext/class.rb",
    "lib/boatman/ext/fixnum.rb",
    "lib/boatman/ext/string.rb",
    "lib/boatman/monitored_directory.rb",
    "lib/boatman/monitored_file.rb",
    "spec/boatman_spec.rb",
    "spec/data/copy_exception.rb",
    "spec/data/copy_exception.yml",
    "spec/data/filename_ending.rb",
    "spec/data/filename_ending.yml",
    "spec/data/filename_ending_regexp.rb",
    "spec/data/filename_ending_regexp.yml",
    "spec/data/filename_regexp.rb",
    "spec/data/filename_regexp.yml",
    "spec/data/folder.rb",
    "spec/data/folder.yml",
    "spec/data/invalid_directory.rb",
    "spec/data/invalid_directory.yml",
    "spec/data/modify.rb",
    "spec/data/modify.yml",
    "spec/data/no_destination_folder.rb",
    "spec/data/no_destination_folder.yml",
    "spec/data/rename.rb",
    "spec/data/rename.yml",
    "spec/spec.opts",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/bmarzolf/boatman}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Ruby DSL for ferrying around and manipulating files}
  s.test_files = [
    "spec/boatman_spec.rb",
    "spec/data/copy_exception.rb",
    "spec/data/filename_ending.rb",
    "spec/data/filename_ending_regexp.rb",
    "spec/data/filename_regexp.rb",
    "spec/data/folder.rb",
    "spec/data/invalid_directory.rb",
    "spec/data/modify.rb",
    "spec/data/no_destination_folder.rb",
    "spec/data/rename.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end
