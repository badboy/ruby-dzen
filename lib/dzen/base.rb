# encoding: utf-8

require 'ostruct'

module DZEN
  # Subclass this and define own options
  # to implement a different output
  class Base
    Config = {
      :delimiter => '',
      :ending => '',
      :interval => 3,
      :output => $stdout,
      :output_method => :puts,
      :color => {
        :start => nil,
        :end => nil
      }
    }

    # Gets the actual used config
    attr_reader :config

    # Public: Initialize a new dzen2 output instance
    #
    # config - A Hash containing the config keys
    #
    # Returns a newly initialized DZEN::Base instance
    def initialize(config={})
      @config = OpenStruct.new(self.class::Config.merge(config))

      @before_run_handler = []
      @apps = []
      @order = []
    end

    # Public: Configure the instance.
    #
    # The block will be yielded the current configuration.
    #
    # Returns the config
    def configure
      yield @config
      @config
    end

    # Public: Add before_run handler.
    #
    #  It's possible to define more than one before_run handler.
    #
    # blk - The block to be run when starting
    def add_before_run(&blk)
      @before_run_handler << blk
    end

    # Public: Set the order of apps.
    #
    # apps - Array of app names in sorted order.
    #
    # Returns the passed order array.
    def order=(apps)
      @order = apps
    end

    # Public: Add new handler for an app.
    #
    # name   - Name of the app.
    # option - Some options [not used yet].
    # blk    - The actual handler block.
    def add_handler(name, options, &blk)
      @apps << [name, options||{}, blk]
    end

    # Sort the apps as defined by @order
    # Any not-listed app is not added to the actual output array
    def sort_apps!
      return if @order.empty?
      @apps = @order.map do |app|
        @apps.find { |e| e.first == app }
      end
    end

    # Public: Run the instance in an endless loop
    #
    # These endless loop may be stopped by sending it a SIGINT
    # It runs the before_run handler first, then executes the
    # defined app modules each interval
    def run!
      trap(:INT) { @output.puts; exit 0; }

      sort_apps!

      @before_run_handler.each do |handler|
        @config.output.puts handler.call
      end

      loop do
        normal_text = @apps.map { |(name, options, callback)|
          if options[:cache]
            # TODO: implement the cache
            callback.call
          else
            callback.call
          end
        }.join(@config.delimiter)

        @config.output.send(@config.output_method, @config.start) if @config.start
        @config.output.print(normal_text)
        @config.output.send(@config.output_method, @config.ending) if @config.ending
        @config.output.flush
        sleep @config.interval
      end
    rescue Errno::EPIPE
    exit 0
  end
  end

  # Default Dzen2 output
  # The in-text formating commands are used as defined at
  # http://dzen.geekmode.org/dwiki/doku.php?id=dzen:command-and-option-list
  class Default < Base
    Config = {
      :delimiter => "^fg(#333333)^p(5;-2)^ro(2)^p()^fg()^p(5)",
      :ending => "^p(6)\n",
      :interval => 3,
      :output => $stdout,
      :output_method => :puts,
      :color => {
        :start => proc{|c| "^fg(#{c})"},
        :end => proc{|c| "^fg()" }
      }
    }
  end

  # Simple Terminal-aware output.
  # May be used within a simple "watch" command
  # Maybe integration in screen is possible
  class Terminal < Base
    Colors = {
      :black => 30,
      :red => 31,
      :green => 32,
      :yellow => 33,
      :blue => 34,
      :magenta => 35,
      :cyan => 36,
      :white => 37
    }

    Config = {
      :delimiter => " | ",
      :start => "\r",
      :interval => 3,
      :output => $stdout,
      :output_method => :print,
      :color => {
        :start => proc{|c|
          Colors[c] && "\e[#{Colors[c]}m"
        },
        :end => proc{|c| Colors[c] && "\e[0m" }
      }
    }
  end
end

# Expose DSL
include DZEN::Macros

# Run DZEN instance if any
at_exit { @@dzen.run! if $!.nil? && run? }
