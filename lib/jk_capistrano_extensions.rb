unless Capistrano::Configuration.respond_to?(:instance)
  abort "jk-capistrano-extensions requires Capistrano 2"
end
require 'capistrano'

require File.join(File.dirname(__FILE__), %w(capistrano_extensions sys))
require File.join(File.dirname(__FILE__), %w(capistrano_extensions invocation))
require File.join(File.dirname(__FILE__), %w(capistrano_extensions files))
require File.join(File.dirname(__FILE__), %w(capistrano_extensions service))
