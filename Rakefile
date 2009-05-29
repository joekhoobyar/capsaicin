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
    s.rubyforge_project = "capsaicin"

    s.add_dependency 'capistrano', ['>= 2.0']
    s.add_dependency 'archive-tar-minitar', ['>= 0.5']
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# These are new tasks
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/capsaicin/"
        local_dir = 'doc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end


# ---------  RDoc Documentation ---------
desc "Generate RDoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README.rdoc' <<
    '--title' << "Capsaicin" <<
    '--charset' << 'utf-8'
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include 'README*'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.libs << "lib"
end

task :default => :build

