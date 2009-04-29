#!/usr/bin/env ruby

require 'rubygems'
require 'rake/rdoctask'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "capistrano-extensions"
    s.homepage = "http://github.com/joekhoobyar/capistrano-extensions"
    s.summary = "Joe Khoobyar's Capistrano Extensions"
    s.description = %Q{Various capistrano extensions}

    s.authors = ["Joe Khoobyar"]
    s.email = "joe@ankhcraft.com"

    s.add_dependency 'capistrano'
    s.add_dependency 'archive-tar-minitar'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# ---------  RDoc Documentation ---------
desc "Generate RDoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README' <<
    '--title' << "Joe Khoobyar's Capistrano Extensions" <<
    '--charset' << 'utf-8'
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include 'README'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
end

task :default => :build

