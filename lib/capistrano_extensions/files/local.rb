require 'fileutils'

module CapistranoExtensions
  module Files
    module Local

      def tail_f(file, n=10)
        unless defined? File::Tail::Logfile then gem 'file-tail'; require 'file/tail' end
        File::Tail::Logfile.tail(file, :backward=>n) do |line| puts line end
      rescue Interrupt
        logger.trace "interrupted (Ctrl-C)" if logger
      end

      def upload(from, to)
        cp(from, to)
      end

      def download(from, to)
        cp(from, to)
      end


      include FileUtils::Verbose

      public *FileUtils::Verbose.methods(false)
      private *%w(copy_entry copy_file copy_stream
                  remove_entry remove_entry_secure remove_file
                  compare_file compare_stream
                  uptodate?)

      def exists?(a, options={})
        $stdout.puts "[ -f #{_q a} ] ]"
        File.exists? a
      end

      def directory?(a, options={})
        $stdout.puts "[ -d #{_q a} ]"
        File.directory? a
      end

      def executable?(a, options={})
        $stdout.puts "[ -x #{_q a} ]"
        File.executable? a
      end

    end
  end
end

Capistrano.plugin :local_files, CapistranoExtensions::Files::Local
