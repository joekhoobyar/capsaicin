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
          case args.first
          when String; id = args.shift.intern
          when Symbol; id = args.shift
          end
          svc_cmd = "#{basedir || '/etc/init.d'}/#{id.to_s.split(':').last}"

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:status]}" if svc_desc
          task :default, options do
              send(basedir ? run_method : :sudo, "#{svc_cmd} status")
          end

          svc_actions.each do |svc_action|
            svc_action = svc_action.intern if String === svc_action
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              send(basedir ? run_method : :sudo, "#{svc_cmd} #{svc_action}")
            end
          end

          instance_eval { yield } if block_given?
        end
      end
    end
  end
end
