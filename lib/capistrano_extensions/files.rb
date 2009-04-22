require 'fileutils'

module CapistranoExtensions
  module Files

    include FileUtils::Verbose

    public *FileUtils::Verbose.methods(false)
    private *%w(copy_entry copy_file copy_stream
                remove_entry remove_entry_secure remove_file
                compare_file compare_stream
                uptodate?)

    class_eval(%w(exists? directory? executable?).map do |m|
      "def #{m}(f) File.#{m}(f) end"
    end.join("\n"))

  end
end

Capistrano.plugin :files, CapistranoExtensions::Files
