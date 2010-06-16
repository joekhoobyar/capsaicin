require 'stringio'
require 'test/unit'
require 'rubygems'
require 'capistrano/logger'
require 'capistrano/configuration/variables'

class CapistranoMock

  include Capistrano::Configuration::Variables
  
  attr_reader :invocations

  def logbuf
    @logbuf ||= StringIO.new
  end

  def logger
    if @logger.nil?
      @logger = Capistrano::Logger.new :output=>logbuf
      @logger.level = Capistrano::Logger::MAX_LEVEL
    end
    @logger
  end

  %w(invoke_command capture stream).each do |k|
    class_eval %Q{
  def #{k}(*args, &block)
    args = [args]
    args << block if block
    ((@invocations ||= {})[:#{k}] ||= []) << args
  end
}
  end

end
