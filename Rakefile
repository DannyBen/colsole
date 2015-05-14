require 'rake/testtask'

task :default do 
	system "rake -T"
end

desc "run tests"
Rake::TestTask.new do |t|
	t.libs << 'test'
end

desc "run example"
task :example do
	system "ruby -w example.rb"
end

desc "build gem"
task :build do
	system "gem build colsole.gemspec"	
	files = Dir["*.gem"]
	files.each {|f| mv f, "gems" }
end