module CapistranoExtensions
  module Service
    module Windows

      DEFAULT_ACTIONS = [:start, :stop]

      # Check for the existance of a generic Windows NT service.
      def windows?(id, verbose=false)
        logger.trace "executing locally: sc query \"#{id}\"" if logger and verbose
        $1.to_i if `sc query "#{id}"` =~ /STATE +: +([0-9])+ +([^ ]+)/
      ensure
        logger.trace "   service status => #{$2} (#{$1})" if logger and verbose
      end

      # Defines a recipe to control a generic Windows NT service.
      #
      def windows(id,*args)
        options = Hash===args.last ? args.pop : {}

        svc_name = id.to_s
        svc_desc = next_description(:reset) || (svc_name.capitalize unless options.delete(:hide))
        svc_actions = DEFAULT_ACTIONS 
        svc_actions += args.pop if Array === args.last

        namespace id do
          case args.first
          when String; id = args.shift.intern
          when Symbol; id = args.shift
          end

          [:default, :status].each do |k|
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:status]}" if svc_desc
            task k, options do
              service.windows? id, true or
                abort "Failed to get service status for #{svc_name}"
            end
          end

          DEFAULT_ACTIONS.each do |svc_action|
            svc_action = svc_action.intern if String === svc_action
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              local_run "net #{svc_action} \"#{id}\""
            end
          end

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:restart]}" if svc_desc
          task :restart, options do
            case service.windows?(id)
            when 4, 2; stop
            when NilClass; abort "Failed to get service status for #{svc_name}"
            end
            start
          end
        
          instance_eval { yield } if block_given?
        end
      end
    end
  end
end

