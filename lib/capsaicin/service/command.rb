module Capsaicin
  module Service
    module Command

      # Check for the existance of a command-based service.
      def command?(start, stop)
        files.executable? start and files.executable? stop
      end

      # Defines a recipe to control a command-based service.
      #
      def command(id,start,stop,*args)
        options = Hash===args.last ? args.pop : {}

        svc_name = id.to_s
        svc_desc = next_description(:reset) || (svc_name.capitalize unless options.delete(:hide))
        extras = options.delete(:extras) || {}
        via = options.delete(:via)

        namespace id do

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:start]}" if svc_desc
          task :start, options do
            send(via || fetch(:run_method, :run), start)
          end

          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:stop]}" if svc_desc
          task :stop, options do
            send(via || fetch(:run_method, :run), stop)
          end

          unless extras.key? :restart
	          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[:restart]}" if svc_desc
	          task :restart, options do
	            stop
	            start
	          end
	        end
         
          extras.each do |k,cmd|
	          desc "#{svc_desc}: #{SVC_ACTION_CAPTIONS[k]}" if svc_desc
	          task k, options do
	            send(via || fetch(:run_method, :run), cmd)
	          end
          end
        
          instance_eval { yield } if block_given?
        end
      end
    end
  end
end

