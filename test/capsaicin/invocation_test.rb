require 'helper'
require 'tmpdir'
require 'capsaicin/invocation'

class Capsaicin::InvocationTest < Test::Unit::TestCase

  def setup
    @ext = CapistranoMock.new
    @ext.extend Capsaicin::Invocation
  end
  
  def teardown
  end

  def test_vrun
    @ext.vrun 'uptime'
    assert_equal [%w(uptime) << {:via=>:run}], @ext.invocations[:invoke_command].last
    @ext.vrun 'uptime', :via=>:sudo
    assert_equal [%w(uptime) << {:via=>:sudo}], @ext.invocations[:invoke_command].last
    @ext.vrun('uptime', &p=Proc.new{})
    assert_equal [%w(uptime) << {:via=>:run}, p], @ext.invocations[:invoke_command].last
  end
    
  def test_capture
    @ext.vcapture 'uptime'
    assert_equal [%w(uptime) << {:via=>:run}], @ext.invocations[:capture].last
    @ext.vcapture 'uptime', :via=>:sudo
    assert_equal [%w(uptime) << {:via=>:sudo}], @ext.invocations[:capture].last
    @ext.vcapture('uptime', &p=Proc.new{})
    assert_equal [%w(uptime) << {:via=>:run}, p], @ext.invocations[:capture].last
  end
    
  def test_stream
    @ext.vstream 'uptime'
    assert_equal [%w(uptime) << {:via=>:run}], @ext.invocations[:stream].last
    @ext.vstream 'uptime', :via=>:sudo
    assert_equal [%w(uptime) << {:via=>:sudo}], @ext.invocations[:stream].last
    @ext.vstream('uptime', &p=Proc.new{})
    assert_equal [%w(uptime) << {:via=>:run}, p], @ext.invocations[:stream].last
  end
    
end
