#!/usr/bin/env ruby

require 'rubygems'
require 'rake/rdoctask'

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

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
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

task :default => :build

Jeweler::GemcutterTasks.new
Jeweler::RubyforgeTasks.new do |rubyforge|
  rubyforge.doc_task = "rdoc"
  rubyforge.remote_doc_path = ''
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README.rdoc' <<
    '--charset' << 'utf-8'

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Capsaicin #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
