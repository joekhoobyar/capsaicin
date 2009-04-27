module CapistranoExtensions
  module Service
    module Windows

      DEFAULT_ACTIONS = [:start, :stop]

      STATUS_REGEX = /STATE +: +([0-9])+ +([^ ]+)/

      # Check for the existance of a generic Windows NT service.
      def windows?(id)
        `sc query "#{id}"` !~ / FAILED /
      end

      # Defines a recipe to control a generic Windows NT service.
      #
      def windows(id,*args)
        svc_name = id.to_s
        svc_desc = next_description(:reset)
        svc_actions = DEFAULT_ACTIONS 

        if Hash === args.last
          options = args.pop
          svc_desc = id.to_s.capitalize unless svc_desc or options.delete(:hide)
        else
          options = {}
        end
        svc_actions += args.pop if Array === args.last

        case args.first
        when String; id = args.shift.intern
        when Symbol; id = args.shift
        end

        namespace id do
          [:default, :status].each do |k|
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:status]}" if svc_desc
            task k, options do
              output = `sc query "#{id}"`
              if output =~ STATUS_REGEX
                logger.trace "Service status: #{svc_name}: #{$2} (#{$1})" if logger
              else
                logger.error output if logger
                abort "Failed to get service status for #{svc_name}"
              end
            end
          end

          DEFAULT_ACTIONS.each do |svc_action|
            svc_action = svc_action.intern
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              system "net #{svc_action} \"#{id}\""
            end
          end

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:restart]}" if svc_desc
          task :restart, options do
            `sc query "#{id}"` =~ STATUS_REGEX
            $1 == '4' or stop
            start
          end
        
          instance_eval { yield } if block_given?
        end
      end
    end
  end
end

