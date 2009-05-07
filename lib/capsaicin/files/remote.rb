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

      def upload(*args)
        case _via
        when :system, :local_run
          cp(*args)
        else
          @config.upload(*args)
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
        list.map { |l| "'#{l.gsub("'", "\\'")}'" }.join ' '
      end

      def _via
        @config.fetch(:run_method, nil)
      end

    end
  end
end

Capistrano.plugin :remote_files, Capsaicin::Files::Remote
