module CapistranoExtensions
  module Files

    COMMANDS = [ %w(mkdir mkdir_p rmdir cp cp_r rm rm_r rm_rf
                    chmod chmod_R chown chown_R touch),
                %w(ln ln_s ln_sf mv install) ]

    FILE_TESTS = [
      %w(blockdev? -b),
      %w(chardev? -c),
      %w(directory? -d),
      %w(exists? -e),
      %w(file? -f),
      %w(grpowned? -G),
      %w(owned? -O),
      %w(pipe? -p),
      %w(readable? -r),
      %w(setgid? -g),
      %w(setuid? -u),
      %w(size? -s),
      %w(socket? -S),
      %w(sticky? -k),
      %w(symlink? -h),
      %w(writable? -w),
      %w(executable? -x)
    ]

    require File.join(File.dirname(__FILE__), %w(files local.rb))
    require File.join(File.dirname(__FILE__), %w(files remote.rb))

    class_eval(Local.public_instance_methods(false).map do |m|
      "def #{m}(*args, &block)\n  send(_via.to_s + '_files').#{m}(*args, &block)\nend"
    end.join("\n"), __FILE__, __LINE__)

    def _via
      @config.fetch(:files_via, :remote).to_sym != :local ? :remote : :local
    end
  end
end

Capistrano.plugin :files, CapistranoExtensions::Files
