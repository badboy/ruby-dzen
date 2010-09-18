# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name           = "ruby-dzen"
  s.version        = "0.0.1"
  s.date           = "2010-09-18"
  s.summary        = "A small wrapper DSL for dzen2's in-text formatting"
  s.homepage       = "http://github.com/badboy/ruby-dzen"
  s.email          = "badboy@archlinux.us"
  s.authors        = ["badboy"]
  s.has_rdoc       = false
  s.require_path   = "lib"
  s.files          = %w( README.md Rakefile LICENSE )
  s.files         += Dir.glob("lib/**/*")
  s.files         += Dir.glob("test**/*")
  s.description    = <<-desc
  ruby-dzen is a small wrapper for dzen2's in-text formatting
  With its simple DSL you can define what dzen2 display by using pure ruby code.

  Just define your app modules in a file, execute it and pipe the output to dzen.

  The simplest example is the following:
    app :hello do
      "hello"
    end
  desc
end
