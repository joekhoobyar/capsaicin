require 'stringio'
require 'rubygems'
require 'capistrano/logger'

class CapistranoMock

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

end
