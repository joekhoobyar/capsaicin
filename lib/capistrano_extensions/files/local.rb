require 'fileutils'

module CapistranoExtensions
  module Files
    module Local

      include FileUtils::Verbose

      public *COMMANDS
      public :pwd

      FILE_TESTS.each do |m,t|
        class_eval <<-EODEF
          def #{m}(a, options={})
            logger.trace "test #{t} \#{a.gsub ' ', '\\ '}" if logger 
            File.#{m} a
          end
        EODEF
      end

      def tail_f(file, n=10)
        unless defined? File::Tail::Logfile then gem 'file-tail'; require 'file/tail' end
        File::Tail::Logfile.tail(file, :backward=>n) do |line| puts line end
      rescue Interrupt
        logger.trace "interrupted (Ctrl-C)" if logger
      end

      def upload(from, to)
        cp from, to
      end

      def download(from, to)
        cp from, to
      end

      def cd(dir, options={})
        if block_given?
          dir, dir2 = pwd, dir
          cd dir2
          yield
        end  
        cd dir
      end

    end
  end
end

Capistrano.plugin :local_files, CapistranoExtensions::Files::Local
