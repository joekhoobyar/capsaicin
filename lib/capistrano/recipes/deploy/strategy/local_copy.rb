require 'capistrano/recipes/deploy/strategy/base'

module Capistrano
  module Deploy
    module Strategy
      class LocalCopy < Base

        def deploy!
          logger.debug "compressing local copy to #{filename}"
          local_files.tar_cz filename, '.', :verbose=>true do |item|
            name = File.basename item
            name == "." || name == ".." || copy_exclude.any?{|p| File.fnmatch(p, item)}
          end

          #File.open(File.join(destination, "REVISION"), "w") { |f| f.puts(revision) }
          files.upload filename, remote_filename
          #files.tar_xz remote_filename, configuration[:releases_path], :verbose=>true
          #run "cd #{configuration[:releases_path]} && #{decompress(remote_filename).join(" ")} && rm #{remote_filename}"
        ensure
          files.rm_f remote_filename rescue nil
          FileUtils.rm filename rescue nil
          FileUtils.rm_rf destination rescue nil
        end

        def check!
        end

        private

          def local_copy_dir
            @local_copy_dir ||= configuration.fetch(:local_copy_dir, '.')
          end

          def copy_exclude
            @copy_exclude ||= Array(configuration.fetch(:copy_exclude, %w(log .svn .git)))
          end

          def copy_directory_only
            @copy_directory_only ||= Array(configuration.fetch(:copy_directory_only, %w(tmp)))
          end

          def filename
            @filename ||= File.join(tmpdir, "#{configuration.fetch(:application, 'local_copy')}.tgz")
          end

          def remote_dir
            @remote_dir ||= configuration[:copy_remote_dir] || "/tmp"
          end

          def remote_filename
            @remote_filename ||= File.join(remote_dir, File.basename(filename))
          end
      end

    end
  end
end
