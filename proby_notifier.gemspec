# -*- encoding: utf-8 -*-
require File.expand_path("../lib/proby_notifier/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "proby_notifier"
  s.license     = "MIT"
  s.version     = ProbyNotifier::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Wood", "Doug Barth"]
  s.email       = ["john@signalhq.com", "doug@signalhq.com"]
  s.homepage    = "http://github.com/signal/proby_notifier"
  s.summary     = %Q{A simple library for working with the Proby task monitoring application.}
  s.description = %Q{A simple library for working with the Proby task monitoring application.}

  s.rubyforge_project = "proby_notifier"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "rake", "~> 0.8.7"
  s.add_development_dependency "yard", "~> 0.6.4"
  s.add_development_dependency "bluecloth", "~> 2.1.0"
  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "shoulda", "~> 2.11.3"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

