require 'helper'
require 'tmpdir'
require 'capsaicin/invocation'

class Capsaicin::InvocationTest < Test::Unit::TestCase

  def setup
    @ext = CapistranoMock.new
    class << @ext
	    include Capsaicin::Invocation
	  end
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
    
  def test_sudo_as
    check_as_methods :sudo_as, :sudo
  end

  def test_sudo_su
    check_as_methods(:sudo_su, :sudo) {|c,as| ["su #{as} -c '#{c}'", {}] }
  end

  def test_sudo_su_escapes_single_quotes
    check_as_methods(:sudo_su, :sudo,"echo 'abc'") do |c,as|
      ["su #{as} -c 'echo '\"'\"'abc'\"'\"''", {}]
    end
  end

  def test_sudo_su_to
    check_as_methods(:sudo_su_to, :run) do |c,as|
      ["echo \"uptime\" | sudo su - #{as}", {:shell=>false}]
    end
  end

  def test_run_without_override
    @ext.run 'uptime'
    assert_equal [%w(uptime) << {}], @ext.invocations[:run].last
  end

  def test_run_with_override
    @ext.set :override_run_method, :sudo
    @ext.set :override_runnner, :admin
    @ext.run 'uptime'
    assert_equal [%w(uptime)], @ext.invocations[:sudo].last
  end

private

  def check_run_methods(method,key)
    [:run, :sudo].each do |via|
	    @ext.send method, 'uptime'
	    assert_equal [%w(uptime) << {:via=>via}], @ext.invocations[key].last
	    @ext.set :run_method, :sudo
	  end
    [:sudo, :run].each do |via|
	    @ext.send method, 'uptime', &block=Proc.new{}
	    assert_equal [%w(uptime) << {:via=>via}, block], @ext.invocations[key].last
	    @ext.unset :run_method
    end
    @ext.send method, 'uptime', :via=>:sudo
    assert_equal [%w(uptime) << {:via=>:sudo}], @ext.invocations[key].last
  end    

  def check_as_methods(method,key,cmd='uptime',&p)
    p ||= lambda{|c,as| [c, {:as=>as}] }
    [nil, :admin].each do |as|
	    @ext.send method,cmd 
	    assert_equal [p[cmd,as]], @ext.invocations[key].last
	    @ext.set :runner, :admin
	  end
    @ext.send method, cmd, :as=>:busybody
    assert_equal [p[cmd,:busybody]], @ext.invocations[key].last
    [:admin, nil].each do |as|
	    @ext.send method, cmd, &block=Proc.new{}
	    assert_equal [p[cmd,as], block], @ext.invocations[key].last
	    @ext.unset :runner
    end
    @ext.send method, cmd, :as=>:busybody
    assert_equal [p[cmd,:busybody]], @ext.invocations[key].last
    @ext.send method, :as=>:busybody
    assert_equal [[{:as=>:busybody}]], @ext.invocations[:sudo].last
  end    
end
