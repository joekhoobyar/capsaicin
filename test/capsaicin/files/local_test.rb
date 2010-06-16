require 'helper'
require 'tmpdir'
require 'capsaicin/files'
require 'capsaicin/files/local'

class Capsaicin::Files::LocalTest < Test::Unit::TestCase

  def setup
    @local = CapistranoMock.new
    @local.extend Capsaicin::Files::Local
  end
  
  def teardown
    @tmpdir and FileUtils.rm_rf(@tmpdir)
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
  
  def test_writable
    assert @local.writable?(Dir.tmpdir)
    assert_equal "test -w #{Dir.tmpdir}", @local.logbuf.string.strip
  end
  
  def test_not_writable
    assert ! @local.writable?(__FILE__+'/nope')
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

  def test_mkdir
    assert @local.mkdir(d = tmpdir('test-mkdir'))
    assert File.directory?(d)
    assert_equal "mkdir #{d}", @local.logbuf.string.strip
  end

  def test_mkdir_not_p
    assert_raise Errno::ENOENT do
      @local.mkdir(tmpdir('test-mkdir','p'))
    end
    assert ! File.directory?(d = tmpdir('test-mkdir','p'))
    assert_equal "mkdir #{d}", @local.logbuf.string.strip
  end

  def test_mkdir_p
    assert @local.mkdir_p(d = tmpdir('test-mkdir','p'))
    assert File.directory?(d)
    assert_equal "mkdir -p #{d}", @local.logbuf.string.strip
  end

  def test_mkdir_p_one
    assert @local.mkdir_p(d = tmpdir('test-mkdir-p'))
    assert File.directory?(d)
    assert_equal "mkdir -p #{d}", @local.logbuf.string.strip
  end

  def test_rmdir
    FileUtils.mkdir(d = tmpdir('test-rmdir'))
    assert @local.rmdir(d)
    assert ! File.directory?(d)
    assert ! File.exists?(d)
    assert_equal "rmdir #{d}", @local.logbuf.string.strip
  end

  def test_cp
    assert_nil @local.cp(__FILE__, f = tmpdir('test-cp'))
    assert_equal File.read(__FILE__), File.read(f)
    assert_equal "cp #{__FILE__} #{f}", @local.logbuf.string.strip
  end

  def test_cp_r
    assert_nil @local.cp_r(File.dirname(__FILE__), d = tmpdir('test-cp-r'))
    assert_equal File.read(__FILE__), File.read(File.join(d,File.basename(__FILE__)))
    assert_equal "cp -r #{File.dirname __FILE__} #{d}", @local.logbuf.string.strip
  end

  def test_rm
    FileUtils.cp(__FILE__, f = tmpdir('test-cp'))
    assert @local.rm(f)
    assert ! File.exists?(f)
    assert_equal "rm #{f}", @local.logbuf.string.strip
  end

  def test_rm_missing
    assert_raise Errno::ENOENT do
	    assert @local.rm(tmpdir('test-cp'))
	  end
    assert_equal "rm #{tmpdir('test-cp')}", @local.logbuf.string.strip
  end

  def test_rm_f
    FileUtils.cp(__FILE__, f = tmpdir('test-cp'))
    assert @local.rm_f(f)
    assert ! File.exists?(f)
    assert_equal "rm -f #{f}", @local.logbuf.string.strip
  end

  def test_rm_f_missing
    assert @local.rm_f(f = tmpdir('test-cp'))
    assert ! File.exists?(f)
    assert_equal "rm -f #{f}", @local.logbuf.string.strip
  end

  def test_rm_r
    FileUtils.cp_r(File.dirname(__FILE__), d = tmpdir('test-cp-r'))
    assert @local.rm_r(d)
    assert ! File.directory?(d)
    assert ! File.exists?(d)
    assert_equal "rm -r #{d}", @local.logbuf.string.strip
  end

  def test_rm_r_missing
    assert_raise Errno::ENOENT do
	    assert @local.rm_r(tmpdir('test-cp-r'))
	  end
    assert_equal "rm -r #{tmpdir('test-cp-r')}", @local.logbuf.string.strip
  end

  def test_rm_rf
    FileUtils.cp_r(File.dirname(__FILE__), d = tmpdir('test-cp-r'))
    assert @local.rm_rf(d)
    assert ! File.directory?(d)
    assert ! File.exists?(d)
    assert_equal "rm -rf #{d}", @local.logbuf.string.strip
  end

  def test_rm_rf_missing
    assert @local.rm_rf(d = tmpdir('test-cp-r'))
    assert ! File.directory?(d)
    assert ! File.exists?(d)
    assert_equal "rm -rf #{d}", @local.logbuf.string.strip
  end

protected

  def tmpdir(*args)
    @tmpdir ||= "#{Dir.tmpdir}/capsaicin".tap do |d|
	    FileUtils.rm_rf d
	    FileUtils.mkdir_p d
	  end
	  File.join @tmpdir, *args
  end
end
