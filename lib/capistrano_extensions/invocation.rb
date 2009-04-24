module CapistranoExtension
  module Invocation
    def sudo_as(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      options[:as] = fetch(:runner, nil)
      sudo *args.push(options), &block
    end
    
    def sudo_su(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      args[0] = "su #{fetch(:runner, nil)} -c '#{args[0].gsub '\'', '\'"\'"\''}'"
      sudo *args.push(options), &block
    end
    
    def sudo_su_to(*args, &block)
      options = Hash===args.last ? args.pop.dup :  {}
      options[:shell] = false
      args[0] = "echo '#{args[0].gsub /(['\n])/, "\\#{n}"}' | #{sudo} su - #{fetch(:runner, nil)}"
      run *args.push(options), &block
    end
  end
  Capistrano::Configuration.send :include, Invocation
end

