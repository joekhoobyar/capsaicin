require 'capistrano/recipes/deploy/strategy/base'
require 'tempfile'

module Capistrano
  module Deploy
    module Strategy
      class LocalCopy < Base

        def deploy!
          logger.debug "compressing local copy to #{filename}"
          local_files.tar_cz filename, '.', :verbose=>false do |item|
            if (item=item[2..-1]) and item.length > 0
              name = File.basename item
              name == "." || name == ".." || copy_prune.include?(name) ||
                copy_exclude.any?{|p| File.fnmatch(p, item, File::FNM_DOTMATCH)} ||
                (! File.directory?(item) && copy_directory_only.any?{|p| item[0,p.length+1]==p+'/'})
            end
          end
          files.upload filename, remote_filename
          begin
            files.tar_xz remote_filename, :chdir=>configuration[:releases_path], :verbose=>true
          ensure
            files.rm_f remote_filename rescue nil
          end
        ensure
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
            @copy_exclude ||= Array(configuration.fetch(:copy_exclude, %w(.*)))
          end

          def copy_prune
            @copy_prune ||= Array(configuration.fetch(:copy_exclude, %w(.svn .git)))
          end

          def copy_directory_only
            @copy_directory_only ||= Array(configuration.fetch(:copy_directory_only, %w(log tmp)))
          end

          def filename
            @filename ||= File.join(Dir.tmpdir, "#{configuration.fetch(:application, 'local_copy')}.tgz")
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
