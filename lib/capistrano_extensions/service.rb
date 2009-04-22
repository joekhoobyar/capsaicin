module Service

	LSB_DEFAULT_ACTIONS = %w(start stop restart status)

	SVC_ACTION_CAPTIONS = Hash.new(:status => 'Service Status', :check => 'Config Check') do |h,k|
		h[k] = "#{k.to_s.capitalize} Service"
	end

	def ocf
	end

	def lsb(id,*args)
		svc_desc = next_description(:reset)
		svc_cmd = "/etc/init.d/#{id}"
		svc_actions = LSB_DEFAULT_ACTIONS 

		if Hash === args.last
			options = args.pop
			svc_actions += args.shift if Array === args.first
		else
			options = {}
		end

		svc_actions.each do |svc_action|
			svc_action = svc_action.intern
			desc "#{SVC_ACTION_CAPTIONS[svc_action]}: #{svc_desc}"
			task svc_action, options do
				sudo "#{svc_cmd} #{svc_action}"
			end
		end
	end

end

Capistrano.plugin :service, Service
