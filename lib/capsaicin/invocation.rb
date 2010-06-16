module Capsaicin

  module Invocation
    
    def self.included(base)
      [:run, :sudo].each do |k|
	      base.send :alias_method, :"#{k}_without_override", k
	      base.send :alias_method, k, :"#{k}_with_override"
      end
    end
    
    # Allows overriding the default behavior of +run+ by setting
    # :override_run_method and (optionally) :override_runner
		def run_with_override(cmd, options={}, &block)
      if :run == (via = fetch(:override_run_method, :run))
        run_without_override cmd, options, &block
      else
        options = options.merge(:as=>as) if as = fetch(:override_runner, nil)
	      send via, cmd, options, &block
	    end
		end
    
    # Allows overriding the default behavior of +sudo+ by setting
    # :override_sudo_method and (optionally) :override_sudo_runner
		def sudo_with_override(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:as] ||= as if as = fetch(:override_sudo_runner, nil)
      args << options unless options.empty?
      if :sudo == (via = fetch(:override_sudo_method, :sudo))
	      sudo_without_override *args, &block
      else
	      send via, *args, &block
			end
		end
    
    # Automatically uses the :run_method variable to run things.
    # Equivalent to +invoke_command *args, :via=>fetch(:run_method, :run)+
    def vrun(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:via] ||= fetch(:run_method, :run)
      invoke_command *args.push(options), &block
    end

    # Automatically uses the :run_method variable to run things.
    # Equivalent to +capture *args, :via=>fetch(:run_method, :run)+
    def vcapture(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:via] ||= fetch(:run_method, :run)
      capture *args.push(options), &block
    end

    # Automatically uses the :run_method variable to run things.
    # Equivalent to +stream *args, :via=>fetch(:run_method, :run)+
    def vstream(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:via] ||= fetch(:run_method, :run)
      stream *args.push(options), &block
    end

    # Capistrano's system() override is only available from the base deployment strategy.
    # Also, we could do with a few more windows checks.
    def local_run(*args, &block)
      args.pop if Hash===args.last
      cmd = args.join(' ')
      if RUBY_PLATFORM =~ /win32|mingw|mswin/
        cmd.gsub!('/','\\') # Replace / with \\
        cmd.gsub!(/^cd /,'cd /D ') # Replace cd with cd /D
        cmd.gsub!(/&& cd /,'&& cd /D ') # Replace cd with cd /D
        logger.trace "executing locally: #{cmd}"
        Kernel.system cmd
      else
        logger.trace "executing locally: #{cmd}"
        Kernel.system cmd
      end
    end
    
    # Always uses :runner to sudo as someone. 
    # Equivalent to:  sudo "command", :as => fetch(:runner,nil)
    def sudo_as(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:as] ||= fetch(:runner, nil)
      sudo_without_override *args.push(options), &block
    end
    
    # Extremely helpful if you only have permission to: sudo su SOMEUSER -c 'command'
    def sudo_su(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      as      = options.delete(:as) || fetch(:runner, nil)
      args[0] = "su #{as} -c '#{args[0].gsub("'","'\"'\"'")}'"
      sudo_without_override *args.push(options), &block
    end
    
    # Extremely helpful if you only have permission to: sudo su - SOMEUSER
    def sudo_su_to(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:shell] = false
      cmd     = args[0].gsub(/[$\\`"]/) { |m| "\\#{m}" }
      as      = options.delete(:as) || fetch(:runner, nil)
      args[0] = "echo \"#{cmd}\" | #{sudo} su - #{as}"
      run_without_override *args.push(options), &block
    end
  end
end
