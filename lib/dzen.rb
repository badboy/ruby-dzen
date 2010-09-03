# encoding: utf-8

require 'dzen/cache'
require 'dzen/helpers'
require 'dzen/macros'
require 'dzen/base'

module DZEN
  VERSION = '0.0.1'

  @@app_file = lambda do
    ignore = [
      /lib\/dzen.*\.rb/,   # Library
      /\(.*\)/,            # Generated code
      /custom_require\.rb/ # RubyGems require
    ]

    path = caller.map { |line| line.split(/:\d/, 2).first }.find do |file|
      next if ignore.any? { |pattern| file =~ pattern }
      file
    end

    path || $0
  end.call

  #
  # File name of the application file. Inspired by Sinatra
  #
  def self.app_file
    @@app_file
  end

  #
  # Runs application if application file is the script being executed
  #
  def self.run?
    self.app_file == $0
  end
end
