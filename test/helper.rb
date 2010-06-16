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

  %w(invoke_command capture stream run).each do |k|
    class_eval %Q{
  def #{k}(*args, &block)
    args = [args]
    args << block if block
    (@invocations ||= Hash.new{|h,k| h[k]=[]})[:#{k}] << args
  end
}
  end

  def sudo(*args, &block)
    return 'sudo' if args.empty?
    args = [args]
    args << block if block
    ((@invocations ||= {})[:sudo] ||= []) << args
  end

end
