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
		  via = options[:via] || fetch(:override_run_method, :run)
      if cmd.include?(sudo) or :run == via
        run_without_override cmd, options, &block
      else
        options = options.dup
        as = fetch(:override_runner, nil) and options[:as] ||= as
	      send via, cmd, options, &block
	    end
		end
    
    # Allows overriding the default behavior of +sudo+ by setting
    # :override_sudo_method and (optionally) :override_sudo_runner
		def sudo_with_override(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      as = fetch(:override_sudo_runner, nil) and options[:as] ||= as
      args << options unless options.empty?
      if :sudo == (via = fetch(:override_sudo_method, :sudo))
        options[:via] = :run
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
      options[:as] ||= fetch(:runner, nil)
      return sudo_as(options, &block) if args.empty?   # compatibility with capistrano's +sudo+
      args[0] = "su #{options.delete(:as)} -c '#{args[0].gsub("'","'\"'\"'")}'"
      sudo_without_override *args.push(options), &block
    end
    
    # Extremely helpful if you only have permission to: sudo su - SOMEUSER
    def sudo_su_to(*args, &block)
      options = Hash===args.last ? args.pop.dup : {}
      options[:as] ||= fetch(:runner, nil)
      return sudo_as(options, &block) if args.empty?   # compatibility with capistrano's +sudo+
      options[:shell] = false
      cmd     = args[0].gsub(/[$\\`"]/) { |m| "\\#{m}" }
      args[0] = "echo \"#{cmd}\" | #{sudo_without_override} su - #{options.delete(:as)}"
      run_without_override *args.push(options), &block
    end
  end
end
