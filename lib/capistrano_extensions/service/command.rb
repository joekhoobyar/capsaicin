module CapistranoExtensions
  module Service
    module Command

      # Check for the existance of a generic Windows NT service.
      def command?(start, stop)
        files.executable? start and files.executable? stop
      end

      # Defines a recipe to control a generic Windows NT service.
      #
      def command(id,start,stop,*args)
        options = Hash===args.last ? args.pop : {}

        svc_name = id.to_s
        svc_desc = next_description(:reset) || (svc_name.capitalize unless options.delete(:hide))
        extras = args.pop if Array === args.last
        via = options.delete(:via)

        namespace id do

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:start]}" if svc_desc
          task :start, options do
            send(via || fetch(:run_method, :local_run), start)
          end

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:stop]}" if svc_desc
          task :stop, options do
            send(via || fetch(:run_method, :local_run), stop)
          end

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:restart]}" if svc_desc
          task :restart, options do
            stop
            start
          end
        
          instance_eval { yield } if block_given?
        end
      end
    end
  end
end

