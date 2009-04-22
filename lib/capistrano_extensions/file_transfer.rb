require 'capistrano/configuration/actions/file_transfer'

module Capistrano
  class Configuration
    module Actions
      module FileTransfer
        def upload_tmp(from, options={}, &block)
          to = "/tmp/%s.%4.4x-%d.tmp" % [ File.basename(to), rand(2**16), Time.now.utc.to_i ]
          upload(from, to, options, &block)
        end
	  end
    end
  end
end

