require 'fileutils'

module CapistranoExtensions
  module Files

    include FileUtils
    public *FileUtils.methods(false)

    class_eval(%w(exists? directory? executable?).map do |m|
      "def #{k}(f) File.#{k}(f) end"
    end.join("\n"))

  end
end

Capistrano.plugin :files, CapistranoExtensions::Files
