module CapistranoExtensions

  module Service

    SVC_ACTION_CAPTIONS = Hash.new do |h,k|
      h[k] = "#{k.to_s.capitalize} Service"
    end.update :status => 'Check Status', 
                :check => 'Check Config', 
                :summary => 'Status Summary'

    %w(lsb crm windows command).each do |k|
      require File.join(File.dirname(__FILE__), 'service', k+'.rb')
    end

    include LSB, CRM, Windows, Command

  end

end

Capistrano.plugin :service, CapistranoExtensions::Service
