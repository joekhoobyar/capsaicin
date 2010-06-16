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
    check_run_methods :vrun, :invoke_command
  end
    
  def test_vcapture
    check_run_methods :vcapture, :capture
  end
    
  def test_vstream
    check_run_methods :vstream, :stream
  end

private

  def check_run_methods(method,key)
    [:run, :sudo].each do |via|
	    @ext.send method, 'uptime'
	    assert_equal [%w(uptime) << {:via=>via}], @ext.invocations[key].last
	    @ext.set :run_method, :sudo
	  end
    [:sudo, :run].each do |via|
	    @ext.send method, 'uptime', &p=Proc.new{}
	    assert_equal [%w(uptime) << {:via=>via}, p], @ext.invocations[key].last
	    @ext.unset :run_method
    end
    @ext.send method, 'uptime', :via=>:sudo
    assert_equal [%w(uptime) << {:via=>:sudo}], @ext.invocations[key].last
  end    
end
