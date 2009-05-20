require 'fileutils'

module Capsaicin
  module Files
    module Local

      include FileUtils::Verbose

      public *COMMANDS.flatten
      public :pwd

      FILE_TESTS.each do |m,t|
        class_eval <<-EODEF, __FILE__, __LINE__
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

      def tar_c(dest, src, options={}, &filter)
        logger and
          logger.trace "tar -cf #{dest} " + Array(src).map { |s| s.gsub ' ', '\\ ' }.join(' ')
        _tar File.open(dest, 'wb'), src, v, &filter
      end

      def tar_cz(dest, src, options={}, &filter)
        require 'zlib' unless defined? Zlib::GzipWriter
        logger and
          logger.trace "tar -czf #{dest} " + Array(src).map { |s| s.gsub ' ', '\\ ' }.join(' ')
        _tar Zlib::GzipWriter.new(File.open(dest, 'wb')), src, options, &filter
      end

    private

      def _tar(os, src, options, &filter)
        verbose = options[:v] || options[:verbose]
        require 'find' unless defined? Find
        unless defined? Archive::Tar::Minitar
          require 'archive/tar/minitar'
        end
        minitar = Archive::Tar::Minitar

        minitar::Output.open os do |outp|
          Array(src).each do |path|
            Find.find(path) do |entry|
              if filter and filter[entry]
                Find.prune if File.directory? entry
              else
                logger.trace " + #{entry}" if verbose
                minitar.pack_file entry, outp
              end
            end
          end
        end
      end
    end
  end
end

Capistrano.plugin :local_files, Capsaicin::Files::Local
