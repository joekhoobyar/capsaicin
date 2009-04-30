#!/usr/bin/env ruby

require 'rubygems'
require 'rake/rdoctask'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "capsaicin"
    s.homepage = "http://github.com/joekhoobyar/capsaicin"
    s.summary = "Joe Khoobyar's spicy capistrano extensions"
    s.description = %Q{Spicy capistrano extensions for various needs}

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
    '--title' << "Capsaicin" <<
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

