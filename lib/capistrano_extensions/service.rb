module CapistranoExtensions

  module Service

    require File.join(File.dirname(__FILE__), %w(service lsb.rb))
    require File.join(File.dirname(__FILE__), %w(service crm.rb))
    require File.join(File.dirname(__FILE__), %w(service windows.rb))

    SVC_ACTION_CAPTIONS = Hash.new do |h,k|
      h[k] = "#{k.to_s.capitalize} Service"
    end.update :status => 'Check Status', 
                :check => 'Check Config', 
                :summary => 'Status Summary'

    include LSB, CRM, Windows

  end

end

Capistrano.plugin :service, CapistranoExtensions::Service
