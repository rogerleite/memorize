require 'rubygems'
require 'rubygems/specification'
require 'rake'
require 'rake/gempackagetask'
 
GEM = "memorize"
GEM_VERSION = "0.3.0"
SUMMARY = "Allows Rails applications to do and control cache of actions"
AUTHOR = "Roger Leite"
EMAIL = "roger.barreto@gmail.com"
HOMEPAGE = "http://github.com/rogerleite/memorize"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.require_paths = ['lib']
  s.files = FileList['lib/**/*.rb', '[A-Z]*'].to_a
  
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
 
desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end
 
desc "Create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end
