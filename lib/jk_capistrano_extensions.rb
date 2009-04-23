unless Capistrano::Configuration.respond_to?(:instance)
  abort "jk-capistrano-extensions requires Capistrano 2"
end
require 'capistrano'

require "#{File.dirname(__FILE__)}/capistrano_extensions/invocation.rb"
require "#{File.dirname(__FILE__)}/capistrano_extensions/files.rb"
require "#{File.dirname(__FILE__)}/capistrano_extensions/service.rb"
