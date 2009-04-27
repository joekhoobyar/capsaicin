module CapistranoExtensions
  module Service
    module LSB

      DEFAULT_ACTIONS = %w(status start stop restart)


      # Defines a recipe to control a generic LSB service.
      #
      def lsb(id,*args)
        svc_desc = next_description(:reset)
        svc_cmd = "/etc/init.d/#{id.to_s.split(':').last}"
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
              sudo "#{svc_cmd} status"
          end

          svc_actions.each do |svc_action|
            svc_action = svc_action.intern
            desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[svc_action]}" if svc_desc
            task svc_action, options do
              sudo "#{svc_cmd} #{svc_action}"
            end
          end

          instance_eval { yield } if block_given?
        end
      end
    end
  end
end
