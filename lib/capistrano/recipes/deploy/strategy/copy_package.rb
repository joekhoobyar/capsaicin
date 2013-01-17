require 'capistrano/recipes/deploy/strategy/copy'

module Capistrano # :nodoc:
  module Deploy # :nodoc:
    module Strategy # :nodoc:
      
      # Specialized copy strategy that expects the compressed package to exist after the source is built.
      class CopyPackage < Copy
        
		    # Returns the location of the local package file.
		    # Returns +nil+ unless :package_file has been set. If :package_file
		    # is +true+, a default file location will be returned.
		    def package_file
		      @package_file ||= begin
		        file = configuration[:package_file]
		        file = "#{package_name}.#{compression.extension}" if TrueClass === file
		        File.expand_path(configuration[:package_file], copy_dir) rescue nil
		      end
		    end

		    # Returns the package name.  Used as a default basename for :package_file
        def package_name
          @package_name ||= configuration[:package_name] || "#{configuration[:application]}-#{File.basename(destination)}"
        end

	      # Returns the basename of the release_path, which will be used to
	      # name the local copy and archive file.
	      def destination
	        @destination ||= copy_dir
	      end
        
      private

	      # Returns the name of the package file to be considered.
	      def filename
	        @filename ||= package_file || File.join(copy_dir, "#{package_name}.#{compression.extension}")
	      end

        # Returns the value of the :copy_dir variable, defaulting to the current directory.
        def copy_dir
          @copy_dir ||= configuration[:copy_dir] || '.'
        end

        # Don't build an archive file.
        def copy_repository_to_server  ; end
        def compress_repository        ; end
        def copy_cache_to_staging_area ; end
        def remove_excluded_files      ; end
        def rollback_changes           ; end
                    
	      # Distributes the file to the remote servers
	      def distribute!
	        files.upload(filename, remote_filename)
	        decompress_remote_file
	      end
      
#     
#        def xx
#          logger.debug "compressing local copy to #{filename}"
#          local_files.tar_cz filename, '.', :verbose=>false do |item|
#            if (item=item[2..-1]) and item.length > 0
#              name = File.basename item
#              name == "." || name == ".." || copy_prune.include?(name) ||
#                copy_exclude.any?{|p| File.fnmatch(p, item, File::FNM_DOTMATCH)} ||
#                (! File.directory?(item) && copy_directory_only.any?{|p| item[0,p.length+1]==p+'/'})
#            end
#          end
#	      end

      end

    end
  end
end
