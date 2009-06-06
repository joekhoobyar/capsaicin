module Capsaicin

  module Invocation

    # Automatically uses the :run_method variable to run things.
    # Equivalent to +invoke_command *args, :via=>fetch(:run_method, :run)+
    def vrun(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      options[:via] = fetch(:run_method, :run)
      invoke_command *args.push(options), &block
    end

    # Automatically uses the :run_method variable to run things.
    # Equivalent to +capture *args, :via=>fetch(:run_method, :run)+
    def vcapture(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      options[:via] = fetch(:run_method, :run)
      capture *args.push(options), &block
    end

    # Automatically uses the :run_method variable to run things.
    # Equivalent to +stream *args, :via=>fetch(:run_method, :run)+
    def vstream(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      options[:via] = fetch(:run_method, :run)
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
      options = Hash===args.last ? args.pop.dup :  {}
      options[:as] = fetch(:runner, nil)
      sudo *args.push(options), &block
    end
    
    # Extremely helpful if you only have permission to: sudo su SOMEUSER -c "command"
    def sudo_su(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      args[0] = "su #{fetch(:runner, nil)} -c '#{args[0]}'"
      sudo *args.push(options), &block
    end
    
    # Extremely helpful if you only have permission to: sudo su - SOMEUSER
    def sudo_su_to(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      options[:shell] = false
      cmd = args[0].gsub(/[$\\`"]/) { |m| "\\#{m}" }
      args[0] = "echo \"#{cmd}\" | #{sudo} su - #{fetch(:runner, nil)}"
      run *args.push(options), &block
    end
  end
end
