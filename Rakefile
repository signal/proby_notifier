require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'yard'

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = ENV['TEST'] || "test/**/*_test.rb"
  test.verbose = true
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "proby_notifier #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end

desc 'Delete rdoc, yard, and other generated files'
task :clobber => [:clobber_rdoc, :clobber_yard]

desc 'Delete yard generated files'
task :clobber_yard do
  puts 'rm -rf doc .yardoc'
  FileUtils.rm_rf ['doc', '.yardoc']
end

