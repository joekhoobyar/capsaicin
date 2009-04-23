# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jk-capistrano-extensions}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Khoobyar"]
  s.date = %q{2009-04-23}
  s.description = %q{      Joe Khoobyar's Capistrano Extensions
}
  s.email = %q{joe@ankhcraft.com}
  s.files = [".gitignore", "README", "Rakefile", "lib/capistrano_extensions/files.rb", "lib/capistrano_extensions/files/local.rb", "lib/capistrano_extensions/files/remote.rb", "lib/capistrano_extensions/service.rb", "lib/jk_capistrano_extensions.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/joekhoobyar/capistrano-extensions/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Joe Khoobyar's Capistrano Extensions}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
