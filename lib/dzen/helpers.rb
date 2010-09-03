# encoding: utf-8

module DZEN
  # Some small helpers used in app module outputs.
  #
  # You have to
  #   include DZEN::Helpers
  # in your app file to actually use them.
  module Helpers

    # Public: Colorize a given string using the callbacks
    #         defined by DZEN::Base (or its subclass).
    #
    # c    - The color string, like "red" or "#ff0000"
    #        Make sure the implementation of config.color callbacks
    #        can interpret this colors.
    # text - The text to be colored.
    #
    # Returns the colored string.
    def _color(c, text)
      config = dzen.config.color
      %|#{config[:start].call(c)}#{text}#{config[:end].call(c)}|
    end

    # Public: Colorize a number based on wether it's
    #         below a critical value or not.
    #
    # n        - The number to colorize.
    # critical - The critical value.
    # options  - A Hash of colors for the different colors
    #            :normal   - for the value equal or below `critical`
    #            :critical - for the value above `critical`
    #
    # Returns the colored string.
    def color_critical(n, critical, options = {})
      options = { :normal => "#ff8700", :critical => "red" }.merge(options)
      if n.to_i == 0
        n.to_s
      elsif n.to_i < critical
        _color(options[:normal], n.to_i)
      else
        _color(options[:critical], n.to_i)
      end
    end
  end
end
