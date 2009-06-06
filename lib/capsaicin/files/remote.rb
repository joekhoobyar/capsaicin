require 'fileutils'

module Capsaicin
  module Files
    module Remote

      COMMANDS.each_with_index do |l,n|
        l.each do |m|
          k, f = m.split('_')
          f = ' -' + f if f
          class_eval <<-EODEF, __FILE__, __LINE__
            def #{m}(*args)
              options = args.pop if Hash === args.last
              _r '#{k}#{f}', args#{', ' + (n+1).to_s if n > 0}
            end
          EODEF
        end
      end

      def chmod(mode, list, options={})
        _r 'chmod', Array(list).unshift(mode.to_s(8))
      end

      def chmod_R(mode, list, options={})
        _r 'chmod -R', Array(list).unshift(mode.to_s(8))
      end

      def install(src, dest, options={})
        src = Array(src)
        case options[:mode]
        when Fixnum
          src << '-m' << options[:mode].to_s(8)
        when String
          src << '-m' << options[:mode]
        end
        _r 'install', src.push(dest)
      end

      FILE_TESTS.each do |m,t|
        class_eval <<-EODEF
          def #{m}(a, options={})
            _t "test #{t}", a
          end
        EODEF
      end

      def tail_f(file, n=10)
        cmd = "tail -n #{n} -f #{_q file}"
        case v = _via
        when :system, :local_run
          send v, cmd
        else
          stream cmd, :via => v
        end
      rescue Interrupt
        logger.trace "interrupted (Ctrl-C)" if logger
      end

      def upload(from, to, options={}, &block)
        case _via
        when :system, :local_run
          cp from, to
        else
          to2, to = to, "/tmp/#{File.basename to}-#{Time.now.utc.to_i}" if via.to_s[0,4] == 'sudo'
          @config.upload(from, to, options, &block)
          if to2
            run "chmod 0644 #{to}"
            cp to, to2
            run "rm -f #{to}"
          end
        end
      end

      def download(*args)
        case _via
        when :system, :local_run
          cp(*args)
        else
          @config.download(*args)
        end
      end
      
      def put(data, path, options={})
        case _via
        when :system, :local_run
          FileUtils::Verbose.copy_stream StringIO.new(from), to
        else
          path2, path = path, "/tmp/#{File.basename path}-#{Time.now.utc.to_i}" if _via.to_s[0,4] == 'sudo'
          @config.put(data, path, options)
          if path2
            run "chmod 0644 #{path}"
            cp path, path2
            run "rm -f #{path}"
          end
        end
      end

      def cd(dir, options={})
        if block_given?
          dir, dir2 = pwd, dir
          _r 'cd', dir2
          yield
        end  
        _r 'cd', dir
      end

      def pwd
        capture 'pwd', :via => _via
      end

      def tar_c(dest, src, options={}, &filter)
        filter and abort "tar_c: remote mode does not support a filtering proc"
        _r 'tar -cf', Array(src).unshift(dest)
      end

      def tar_cz(dest, src, options={}, &filter)
        filter and abort "tar_cz: remote mode does not support a filtering proc"
        _r 'tar -czf', Array(src).unshift(dest)
      end

      def tar_cj(dest, src, options={}, &filter)
        filter and abort "tar_cj: remote mode does not support a filtering proc"
        _r 'tar -cjf', Array(src).unshift(dest)
      end

      def tar_x(dest, options={}, &filter)
        filter and abort "tar_x: remote mode does not support a filtering proc"
        _r 'tar -xf', [dest]
      end

      def tar_xz(dest, options={}, &filter)
        filter and abort "tar_xz: remote mode does not support a filtering proc"
        _r 'tar -xzf', [dest]
      end

      def tar_xj(dest, src, options={}, &filter)
        filter and abort "tar_xj: remote mode does not support a filtering proc"
        _r 'tar -xjf', Array(src).unshift(dest)
      end

      def tar_t(src, options={}, &filter)
        filter and abort "tar_t: remote mode does not support a filtering proc"
        _t 'tar -tf', [src]
      end

      def tar_tz(src, options={}, &filter)
        filter and abort "tar_tz: remote mode does not support a filtering proc"
        _t 'tar -tzf', [src]
      end

      def tar_tj(src, options={}, &filter)
        filter and abort "tar_tj: remote mode does not support a filtering proc"
        _t 'tar -tjf', [src]
      end


    private

      def _t(cmd, args=nil, min=nil)
        cmd = _a cmd, args, min
        if _via == :system then
          local_run(cmd)
        else
          capture("#{cmd}; echo $?", :via => _via).strip == '0'
        end
      end

      def _r(cmd, args=nil, min=nil)
        cmd = _a cmd, args, min
        if _via != :system then
          invoke_command cmd, :via => _via
        else
          local_run cmd
        end          
      end

      def _a(cmd, args=nil, min=nil)
        case args
        when NilClass
          raise ArgumentError unless min.nil? or min.zero?
        when Array
          args = args.flatten
          raise ArgumentError if (min || 1) > args.length
          cmd = "#{cmd} #{_q(*args)}" if args.any?
        else
          raise ArgumentError if min and min < 1
          cmd = "#{cmd} #{_q args}"
        end
      end

      def _q(*list)
        list.map { |l| "'#{l.to_s.gsub("'", "\\'")}'" }.join ' '
      end

      def _via
        @config.fetch(:run_method, nil)
      end

    end
  end
end
