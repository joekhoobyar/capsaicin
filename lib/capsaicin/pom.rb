Capistrano::Configuration.instance.load do
  set :pom_file, 'pom.xml'
  
	set(:pom_doc) do
	  require 'rexml/document'
	  File.open(pom_file, 'r') { |f| REXML::Document.new(f) } or abort "Cannot read XML: #{pom_xml}" 
	end
	
	set(:pom_artifact_id) do
	  t = pom_doc.root.elements['/project/artifactId/text()'].to_s.strip rescue ''
	  t.length > 0 or abort "Cannot read /project/artifactId element from #{pom_xml}"
	  t
	end
	
	set(:pom_version) do
	  x = pom_doc
	  until 0 < (t = x.root.elements['/project/version/text()'].to_s.strip rescue '').length
	    p = x.root.elements['/project/parent/relativePath/text()'].to_s.strip rescue ''
	    break if p.length == 0
	    p = File.join p, pom_file
	    x = File.open(p, 'r') { |f| REXML::Document.new(f) } or abort "Cannot read parent XML: #{p}"
	  end
	  t.length > 0 or abort "Cannot read /project/version element from #{pom_xml} or parent(s)"
	  t
	end
	
	set(:pom_final_name) { [pom_artifact_id, pom_version].compact.join '-' }
end 
