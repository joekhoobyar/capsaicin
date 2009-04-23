#!/usr/bin/env ruby
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'date'

# Helper to retrieve the "revision number" of the git tree.
def git_tree_version
  if File.directory?(".git")
    @tree_version ||= `git describe`.strip.sub('-', '.')
    case @tree_version.count('.')
    when 0
      @tree_version = '0.0.0'
    when 1
      @tree_version << '.0'
    end
  end
  @tree_version
end

def gem_version
  git_tree_version.gsub(/-.*/, '')
end

def release
  "jk-capistrano-extensions-#{git_tree_version}"
end

def manifest
  `git ls-files`.split("\n")
end

begin
  require 'rubygems'

  require 'rake'
  require 'rake/clean'
  require 'rake/packagetask'
  require 'rake/gempackagetask'
  require 'fileutils'
rescue LoadError
  # Too bad.
else

  spec = Gem::Specification.new do |s|
    s.name = "jk-capistrano-extensions"
    
    s.homepage = "http://github.com/joekhoobyar/capistrano-extensions/"
    s.summary = "Joe Khoobyar's Capistrano Extensions"
    s.description = <<-EOF
      Joe Khoobyar's Capistrano Extensions
    EOF

    # Determine the current version of the software
    s.version = gem_version
    
    s.author = "Joe Khoobyar"
    s.email = "joe@ankhcraft.com"
    s.platform = Gem::Platform::RUBY
    s.require_paths = ["lib"]
    s.files = manifest
    #s.test_files      = Dir['test/{test,spec}_*.rb']
    
    s.required_ruby_version = '>= 1.8.6'
    s.date = DateTime.now
    
    s.has_rdoc = true
  end

  Rake::GemPackageTask.new(spec) do |p|
    p.gem_spec = spec
    p.need_tar = false
    p.need_zip = false
  end

  desc "Generate a gemspec"
  task :gemspec do
    open("capistrano-extensions.gemspec", "w") do |f| f << spec.to_ruby end
    puts "gemspec successfully created."
  end
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

task :default => :package

