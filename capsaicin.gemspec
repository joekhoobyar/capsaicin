# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{capsaicin}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Khoobyar"]
  s.date = %q{2009-06-03}
  s.description = %q{Spicy capistrano extensions for various needs}
  s.email = %q{joe@ankhcraft.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/capsaicin.rb",
    "lib/capsaicin/bundle.rb",
    "lib/capsaicin/files.rb",
    "lib/capsaicin/files/local.rb",
    "lib/capsaicin/files/remote.rb",
    "lib/capsaicin/invocation.rb",
    "lib/capsaicin/service.rb",
    "lib/capsaicin/service/command.rb",
    "lib/capsaicin/service/crm.rb",
    "lib/capsaicin/service/lsb.rb",
    "lib/capsaicin/service/windows.rb",
    "lib/capsaicin/sys.rb",
    "lib/capsaicin/ui.rb"
  ]
  s.homepage = %q{http://github.com/joekhoobyar/capsaicin}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{capsaicin}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Joe Khoobyar's spicy capistrano extensions}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.0"])
      s.add_runtime_dependency(%q<archive-tar-minitar>, [">= 0.5"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.0"])
      s.add_dependency(%q<archive-tar-minitar>, [">= 0.5"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.0"])
    s.add_dependency(%q<archive-tar-minitar>, [">= 0.5"])
  end
end
