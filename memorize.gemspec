# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{memorize}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roger Leite"]
  s.date = %q{2010-10-16}
  s.email = %q{roger.barreto@gmail.com}
  s.files = ["lib/memorize/action.rb", "lib/memorize/keys.rb", "lib/memorize.rb", "README.textile", "MIT-LICENSE", "Rakefile"]
  s.homepage = %q{http://github.com/rogerleite/memorize}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Allows Rails applications to do and control cache of actions}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
