# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{capistrano-extensions}
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Khoobyar"]
  s.date = %q{2009-04-29}
  s.description = %q{Various capistrano extensions}
  s.email = %q{joe@ankhcraft.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Rakefile",
    "VERSION.yml",
    "lib/capistrano_extensions/files.rb",
    "lib/capistrano_extensions/files/local.rb",
    "lib/capistrano_extensions/files/remote.rb",
    "lib/capistrano_extensions/invocation.rb",
    "lib/capistrano_extensions/service.rb",
    "lib/capistrano_extensions/service/command.rb",
    "lib/capistrano_extensions/service/crm.rb",
    "lib/capistrano_extensions/service/lsb.rb",
    "lib/capistrano_extensions/service/windows.rb",
    "lib/capistrano_extensions/sys.rb",
    "lib/jk_capistrano_extensions.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/joekhoobyar/capistrano-extensions}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Joe Khoobyar's Capistrano Extensions}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 0"])
      s.add_runtime_dependency(%q<archive-tar-minitar>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, [">= 0"])
      s.add_dependency(%q<archive-tar-minitar>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 0"])
    s.add_dependency(%q<archive-tar-minitar>, [">= 0"])
  end
end
