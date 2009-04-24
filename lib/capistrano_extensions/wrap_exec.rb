require 'capistrano/command'

module CapistranoExtensions
  module WrapExec

    def self.included(base) #:nodoc:
      base.instance_eval do
        alias_method :environment_without_wrap_exec, :environment
        alias_method :environment, :environment_with_wrap_exec
      end
    end

  private

    def environment_with_wrap_exec
      [options[:pre_exec], environment_without_wrap_exec, options[:post_exec]].compact.join "\n"
    end
  end

  Capistrano::Command.send :include, WrapExec
end


