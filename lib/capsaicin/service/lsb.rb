module Capsaicin
  module Service
    module LSB

      DEFAULT_ACTIONS = %w(status start stop restart)

      # Check for the existance of a generic LSB initscript.
      def lsb?(id, basedir="/etc/init.d")
        files.exists? "#{basedir}/#{id.to_s.split(':').last}"
      end

      # Defines a recipe to control a generic LSB service.
      #
      def lsb(id,*args)
        options = Hash===args.last ? args.pop : {}

        basedir = options.delete(:basedir)
        svc_name = id.to_s
        svc_desc = next_description(:reset) || (svc_name.capitalize unless options.delete(:hide))
        svc_actions = DEFAULT_ACTIONS 
        svc_actions += args.pop if Array === args.last

        namespace id do
          svc_id = Symbol === id ? id.to_s : id.split(':').last
          svc_cmd = case basedir
                    when String; basedir + '/' + svc_id
                    when NilClass; '/etc/init.d' + svc_id
                    when Symbol; fetch(basedir) + '/' + svc_id
                    when Proc; basedir.call + '/' + svc_id
                    end

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:status]}" if svc_desc
          task :default, options do
            status
          end

          svc_actions.each do |svc_action|
            svc_action = svc_action.intern if String === svc_action
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              _run_method = basedir ? fetch(:run_method, :sudo) : :sudo
              send(_run_method, "#{svc_cmd} #{svc_action}")
            end
          end

          instance_eval { yield } if block_given?
        end
      end
    end
  end
end
