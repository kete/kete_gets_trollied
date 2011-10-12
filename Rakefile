require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "kete_gets_trollied"
    gem.summary = %Q{Uses the trollied gem for adding item ordering to Kete.}
    gem.description = %Q{Uses the trollied gem for adding item ordering to Kete.}
    gem.email = "walter@katipo.co.nz"
    gem.homepage = "http://github.com/kete/kete_gets_trollied"
    gem.authors = ["Walter McGinnis"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency "trollied", ">= 0.1.4"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  # in the future may include own tests under dummy app or generators for kete app specific tests.
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "kete_gets_trollied #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
