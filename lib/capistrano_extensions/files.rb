require File.join(File.dirname(__FILE__), %w(files local.rb))

module CapistranoExtensions::Files
  class_eval(Local.public_instance_methods(false).map do |m|
    "def #{m}(*f) local_files.#{m}(*f) end"
  end.join("\n"))
end

Capistrano.plugin :files, CapistranoExtensions::Files

