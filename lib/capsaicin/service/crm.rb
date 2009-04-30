module Capsaicin
  module Service
    module CRM

      DEFAULT_ACTIONS = [	[ :status, '-W' ],
                          [ :summary, "-x | awk '/^raw xml:/ { exit }; { print }'" ],
                          [ :start, "--meta -d 'target_role'" ],
                          [ :stop, "--meta -p 'target_role' -v 'stopped'" ] ]

      OCF_DEFAULT_ACTIONS = [ [ :validate, '-c -C' ],
                              [ :monitor, '-c -m' ] ]

      # Defines a recipe to control a cluster-managed service, using heartbeat or pacemaker.
      #
      def crm(id,*args)
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
          svc_cmd = "/usr/sbin/crm_resource -r #{id.to_s.split(':').last}"

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:status]}" if svc_desc
          task :default, options do
              sudo "#{svc_cmd} -W"
          end

          svc_actions.each do |svc_action,svc_args|
            svc_action = svc_action.intern unless Symbol===svc_action
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              sudo "#{svc_cmd} #{svc_args}"
            end
          end

          instance_eval { yield } if block_given?
        end
      end

      # Defines a recipe providing additional controls for a cluster-managed service, 
      # using the ocf_resource tool which interoperates with heartbeat or pacemaker.
      #
      # For more information about ocf_resource and other add-ons for heartbeat/pacemaker,
      # see http://github.com/joekhoobyar/ha-tools
      #
      def crm_ocf(id,*args)
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
          svc_cmd = "ocf_resource -g #{id.to_s.split(':').last}"

          svc_actions.each do |svc_action,svc_args|
            svc_action = svc_action.intern if String === svc_action
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              sudo "#{svc_cmd} #{svc_args}"
            end
          end

          instance_eval { yield } if block_given?
        end
      end
    end
  end
end

