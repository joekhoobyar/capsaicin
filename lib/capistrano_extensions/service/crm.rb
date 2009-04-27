module CapistranoExtensions
  module Service
    module CRM

      DEFAULT_ACTIONS = [	[ :status, '-W' ],
                          [ :summary, "-x | awk '/^raw xml:/ { exit }; { print }'" ],
                          [ :start, "--meta -d 'target_role'" ],
                          [ :stop, "--meta -p 'target_role' -v 'stopped'" ] ]

      OCF_DEFAULT_ACTIONS = [ [ :validate, '-c -C' ],
                              [ :monitor, '-c -m' ] ]

      def crm(id,*args)
        svc_desc = next_description(:reset)
        svc_cmd = "/usr/sbin/crm_resource -r #{id.to_s.split(':').last}"
        svc_actions = DEFAULT_ACTIONS

        if Hash === args.last
          options = args.pop
          svc_desc = id.to_s.capitalize unless svc_desc or options.delete(:hide)
          svc_actions += args.shift if Array === args.first
        else
          options = {}
        end

        namespace id do
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

      def crm_ocf(id,*args)
        svc_desc = next_description(:reset)
        svc_cmd = "ocf_resource -g #{id.to_s.split(':').last}"
        svc_actions = DEFAULT_ACTIONS

        if Hash === args.last
          options = args.pop
          svc_desc = id.to_s.capitalize unless svc_desc or options.delete(:hide)
          svc_actions += args.shift if Array === args.first
        else
          options = {}
        end

        namespace id do
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
    end
  end
end

