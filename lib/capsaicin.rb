unless Capistrano::Configuration.respond_to?(:instance)
  abort "capsaicin requires capistrano 2.0 or later"
end
require 'capistrano'

require File.join(File.dirname(__FILE__), %w(capsaicin sys))
require File.join(File.dirname(__FILE__), %w(capsaicin invocation))
require File.join(File.dirname(__FILE__), %w(capsaicin files))
require File.join(File.dirname(__FILE__), %w(capsaicin service))
