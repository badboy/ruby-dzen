require 'rake/testtask'
begin
  require 'mg'
rescue LoadError
  abort "Please `gem install mg`"
end

MG.new("ruby-dzen.gemspec")

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test
