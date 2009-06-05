require 'test/unit'
require 'helper'
require 'capsaicin/files'
require 'capsaicin/files/local'

class TestLocalFiles < Test::Unit::TestCase

  def setup
    @local = CapistranoMock.new
    @local.extend Capsaicin::Files::Local
  end
  
  def test_exists
    assert @local.exists?(__FILE__)
    assert_equal "test -e #{__FILE__}", @local.logbuf.string.strip
  end
  
  def test_not_exists
    assert ! @local.exists?(__FILE__+'/nope')
  end
  
  def test_readable
    assert @local.readable?(__FILE__)
    assert_equal "test -r #{__FILE__}", @local.logbuf.string.strip
  end
  
  def test_not_readable
    assert ! @local.readable?(__FILE__+'/nope')
  end
  
  def test_file
    assert @local.file?(__FILE__)
    assert_equal "test -f #{__FILE__}", @local.logbuf.string.strip
  end
  
  def test_not_file
    assert ! @local.file?(__FILE__+'/nope')
  end
  
  def test_directory
    assert @local.directory?(File.dirname(__FILE__))
    assert_equal "test -d #{File.dirname __FILE__}", @local.logbuf.string.strip
  end
  
  def test_not_directory
    assert ! @local.directory?(__FILE__)
  end
end
