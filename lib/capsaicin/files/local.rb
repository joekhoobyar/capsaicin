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

      def put(from, to)
        copy_stream StringIO.new(from), to
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
        logger and logger.trace "tar -cf #{dest} #{Array(src).map{|s| s.gsub ' ', '\\ '}.join(' ')}"
        _tar File.open(dest, 'wb'), src, options, &filter
      end

      def tar_cz(dest, src, options={}, &filter)
        require 'zlib' unless defined? Zlib::GzipWriter
        logger and logger.trace "tar -czf #{dest} #{Array(src).map{|s| s.gsub ' ', '\\ ' }.join(' ')}"
        _tar Zlib::GzipWriter.new(File.open(dest, 'wb')), src, options, &filter
      end

      def tar_t(src, options={}, &block)
        logger and logger.trace "tar -tf #{src}"
        _lstar File.open(src, 'wb'), options, &block
      end

      def tar_tz(src, options={}, &block)
        require 'zlib' unless defined? Zlib::GzipWriter
        logger and logger.trace "tar -tzf #{src}"
        _lstar Zlib::GzipReader.new(File.open(src, 'rb')), options, &block
      end

      def tar_x(src, options={}, &block)
        logger and logger.trace "tar -xf #{src}"
        _untar File.open(src, 'wb'), options[:chdir]||'.', options, &block
      end

      def tar_xz(src, options={}, &block)
        require 'zlib' unless defined? Zlib::GzipWriter
        logger and logger.trace "tar -xzf #{src}"
        _untar Zlib::GzipReader.new(File.open(src, 'rb')), options[:chdir]||'.', options, &block
      end

    private

      def _tar(os, src, options, &filter)
        verbose = options[:v] || options[:verbose]
        minitar = _minitar
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
      
      def _untar(is, dest, files=[], options={}, &callback)
        verbose = options[:v] || options[:verbose]
        minitar = _minitar
        minitar::Input.open is do |inp|
          if File.exist?(dest) and ! File.directory?(dest)
            raise "Can't unpack to a non-directory."
          elsif ! File.exist? dest
            FileUtils.mkdir_p dest
          end
          inp.each do |entry|
            logger.trace " - #{entry}" if verbose
            if files.empty? or files.include?(entry.full_name)
              inp.extract_entry(dest, entry, &callback)
            end
          end
        end
      end

      def _lstar(is, options={}, &block)
        verbose = options[:v] || options[:verbose]
        files, minitar = [], _minitar
        minitar::Input.open is do |inp|
          inp.each do |entry|
            if block.nil? then files << entry else
              f = block[entry]
              files << f unless f.nil?
            end
            logger.trace " - #{entry}" if verbose
          end
        end
        files
      end

      def _minitar
        require 'find' unless defined? Find
        require 'archive/tar/minitar' unless defined? Archive::Tar::Minitar
        Archive::Tar::Minitar
      end
      
      def fu_output_message(msg)
        logger.trace msg if logger
      end
    end
  end
end
