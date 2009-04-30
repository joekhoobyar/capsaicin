module Capsaicin
  module UI
    module AskPass
      def password_prompt(prompt='Password: ')
        if cap_askpass = ENV['CAP_ASKPASS']
          `#{cap_askpass} "#{prompt}"`.strip
        else
          password_prompt_console
        end
      end
    end
    
    (class << Capistrano::CLI; self; end).class_eval do
      alias :password_prompt_console :password_prompt
      include AskPass
      alias :password_prompt_askpass :password_prompt
    end
  end
end

