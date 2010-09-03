# encoding: utf-8

module DZEN
  module Macros
    def self.included(mod)
      @@dzen = nil
    end

    # Public: Configure the instance.
    #
    # The block will be yielded the current configuration.
    #
    # Example:
    #   configure do |c|
    #     c.interval = 3
    #   end
    #
    # Returns the config
    def configure(&blk)
      dzen.configure(&blk)
    end

    # Public: Set the order of apps.
    #
    # apps - App names in sorted order.
    #
    # Returns the passed order array.
    def order(*apps)
      dzen.order = apps
    end

    # Public: Add before_run handler.
    #
    # blk - The block to be run when starting
    def before_run(&blk)
      dzen.add_before_run(&blk)
    end

    # Public: Add new handler for an app.
    #
    # name   - Name of the app.
    # option - Some options [not used yet].
    # blk    - The actual handler block.
    def app(name, options=nil, &blk)
      dzen.add_handler(name, options, &blk)
    end

    # Public: Gets the current DZEN instance.
    #
    # Define TERMINAL or ENV['TERMINAL'] to use DZEN::Terminal
    # instead of DZEN::Default.
    #
    # Returns a newly created or currently existing DZEN instance.
    def dzen
      return @@dzen unless @@dzen.nil?

      @@dzen = DZEN::Terminal.new if defined?(::TERMINAL) || !!ENV['TERMINAL']
      @@dzen = DZEN::Default.new unless @@dzen

      @@dzen
    end

    # Public: Gets wether to run the DZEN output at exit or not.
    #
    # Returns a boolean.
    def run?
      !!@@dzen
    end
  end
end
