require 'rake/testtask'
require 'rdoc/task'

task :default do 
	system "rake -T"
end

# test task
Rake::TestTask.new {|t| t.libs << 'test'}

Rake::RDocTask.new do |rdoc|
	files = ['README.md', 'lib/colsole.rb']
	rdoc.rdoc_files.add(files)
	rdoc.main = "README.md"
	rdoc.title = "Colsole Docs"
	rdoc.rdoc_dir = 'doc/rdoc'

	rdoc.options << '--line-numbers'
	rdoc.options << '--all'
	# rdoc.options << '--ri'
end

desc "Run example"
task :example do
	system "ruby -w example.rb"
end

desc "Build gem"
task :build do
	system "gem build colsole.gemspec"	
	files = Dir["*.gem"]
	files.each {|f| mv f, "gems" }
end