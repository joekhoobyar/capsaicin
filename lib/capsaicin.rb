unless Capistrano::Configuration.respond_to?(:instance)
  abort "capsaicin requires capistrano 2.0 or later"
end
require 'capistrano'

require File.join(File.dirname(__FILE__), %w(capsaicin sys))
require File.join(File.dirname(__FILE__), %w(capsaicin invocation))
require File.join(File.dirname(__FILE__), %w(capsaicin files))
require File.join(File.dirname(__FILE__), %w(capsaicin service))
require File.join(File.dirname(__FILE__), %w(capsaicin ui))

Capistrano.plugin :files, Capsaicin::Files
Capistrano.plugin :local_files, Capsaicin::Files::Local
Capistrano.plugin :remote_files, Capsaicin::Files::Remote
