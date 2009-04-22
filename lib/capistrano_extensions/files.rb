require 'fileutils'

module CapistranoExtensions
  module Files

    include FileUtils

    public(*(FileUtils.methods(false) - %w(copy_entry copy_file copy_stream
                                            remove_entry remove_entry_secure remove_file
                                            compare_file compare_stream
                                            uptodate?)))

    class_eval(%w(exists? directory? executable?).map do |m|
      "def #{k}(f) File.#{k}(f) end"
    end.join("\n"))

  end
end

Capistrano.plugin :files, CapistranoExtensions::Files
