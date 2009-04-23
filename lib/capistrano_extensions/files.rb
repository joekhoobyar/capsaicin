require File.join(File.dirname(__FILE__), %w(files local.rb))
require File.join(File.dirname(__FILE__), %w(files remote.rb))

module CapistranoExtensions::Files
  class_eval(Local.public_instance_methods(false).map do |m|
    "def #{m}(*f) send(_via.to_s + '_files').#{m}(*f) end"
  end.join("\n"))

  def _via
    @config.fetch(:files_via, :remote).to_sym != :local ? :remote : :local
  end
end

Capistrano.plugin :files, CapistranoExtensions::Files
