require 'fileutils'

module CapistranoExtensions
  module Files
    module Remote

      def tail_f(file, n=10)
        cmd = "tail -n #{n} -f #{_q file}"
        _via == :system ? system(cmd) : stream(cmd)
      end

      def upload(*args)
        @config.upload(*args)
      end

      def download(*args)
        @config.download(*args)
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
        capture("pwd", :via => _via)
      end

      def mkdir(*args)
        options = args.pop if Hash === args.last
        _r 'mkdir', args
      end

      def mkdir_p(*args)
        options = args.pop if Hash === args.last
        _r 'mkdir -p', args
      end

      def rmdir(*args)
        options = args.pop if Hash === args.last
        _r 'rmdir', args
      end

      def ln(*args)
        options = args.pop if Hash === args.last
        _r 'ln', args, 2
      end

      def ln_s(*args)
        options = args.pop if Hash === args.last
        _r 'ln -s', args, 2
      end

      def ln_sf(*args)
        options = args.pop if Hash === args.last
        _r 'ln -sf', args, 2
      end

      def cp(*args)
        options = args.pop if Hash === args.last
        _r 'cp', args
      end

      def cp_r(*args)
        options = args.pop if Hash === args.last
        _r 'cp -r', args
      end

      def mv(*args)
        options = args.pop if Hash === args.last
        _r 'mv', args, 2
      end

      def rm(*args)
        options = args.pop if Hash === args.last
        _r 'rm', args
      end

      def rm_r(*args)
        options = args.pop if Hash === args.last
        _r 'rm -r', args
      end

      def rm_rf(*args)
        options = args.pop if Hash === args.last
        _r 'rm -rf', args
      end

      def install(*args)
        options = args.pop if Hash === args.last
        _r 'install', args, 2
      end

      def chmod(*args)
        options = args.pop if Hash === args.last
        _r 'chmod', args
      end

      def chmod_R(*args)
        options = args.pop if Hash === args.last
        _r 'chmod -R', args
      end

      def chown(*args)
        options = args.pop if Hash === args.last
        _r 'chown', args
      end

      def chown_R(*args)
        options = args.pop if Hash === args.last
        _r 'chown -R', args
      end

      def touch(*args)
        options = args.pop if Hash === args.last
        _r 'touch', args
      end

      def exists?(a, options={:verbose=>false})
        silence!(options) { _r "[ -f #{_q a} ]" }
      end

      def directory?(a, options={:verbose=>false})
        silence!(options) { _r "[ -d #{_q a} ]" }
      end

      def executable?(a, options={:verbose=>false})
        silence!(options) { _r "[ -x #{_q a} ]" }
      end


    private

      def silence!(quiet=false)
        quiet = (FalseClass===quiet[:verbose]) if Hash === quiet
        orig_quiet, @quiet = @quiet, quiet
        yield
      ensure
        @quiet = orig_quiet
      end

      def _r(cmd, args=nil, min=nil)
        case args
        when NilClass
          raise ArgumentError unless min.nil? or min.zero?
        when Array
          args = args.flatten
          raise ArgumentError if (min || 1) > args.length
          cmd = "#{cmd} #{_q(*args)}" if args.any?
        else
          raise ArgumentError if min.nil? or min < 1
          cmd = "#{cmd} #{_q args}"
        end

        case (v = _via)
        when :system
          @quiet or $stderr.puts cmd
          system cmd
        else
          invoke_command cmd, :via => _via
        end
      end

      def _q(*list)
        list.map { |l| "'#{l.gsub("'", "\\'")}'" }.join ' '
      end

      def _via
        case (v = files_via)
        when :local
          :system
        when :remote, NilClass
          (get(:run_method) if exists?(:run_method)) || :run
        else 
          v
        end
      end

    end
  end
end

Capistrano.plugin :remote_files, CapistranoExtensions::Files::Remote
