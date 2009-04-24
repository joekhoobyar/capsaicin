module CapistranoExtensions
  module Command

    def self.included(base) #:nodoc:
      base.instance_eval do
        alias_method :request_pty_if_necessary_without_pre_exec, :request_pty_if_necessary
        alias_method :request_pty_if_necessary, :request_pty_if_necessary_with_pre_exec
      end
    end

  private

    def request_pty_if_necessary_with_pre_exec(channel, &block)
      pre = options[:pre_exec] or return request_pty_if_necessary_without_pre_exec(channel, &block)

      request_pty_if_necessary_without_pre_exec(channel) do |ch,succ|
        if succ
          ch.exec(pre) do |_ch,_succ|
            _succ or logger.important "could not pre-exec #{pre} after opening channel"
            block[_ch, _succ]
          end
        else
          block[ch, false]
        end
      end
    end
  end

  Capistrano::Command.send :include, Command
end


