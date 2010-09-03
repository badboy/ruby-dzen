#!/usr/bin/env ruby
# encoding: utf-8

require 'dzen'

include DZEN::Helpers

# configure the output
# these are the defaults,
# change them if necessary, otherwise you can remove this block
# `interval` and `output` are just two possible options,
# see dzen/base.rb for more options
configure do |c|
  c.interval = 3

  # output can be anything,
  # just make sure it has #puts and #print
  c.output = $stdout
end

before_run do
  "--- loading ---#{DZEN::Base::Config[:ending]}"
end

# change order if necessary
# without this the apps are displayed in the order they are defined
# if an app is defined but not in this order list,
# it wont be displayed at all
#order :pidgin, :gajim, :loadavg

# each little app has to return a string to be displayed

# show hdd temperature
# the hddtemp daemon should be running
app :hdd_temp do
  "HDD: #{`nc localhost 7634`.split(/\|/)[-2]}°C"
end

# show cpu temperature using the `sensors` program
# and display the current frequency
app :cpu do
  "CPU: #{`sensors`.scan(/Core \d:\s+\+(\d+)\.\d/).flatten.map{|e|"#{e}°C"}.join("/")} " +
  IO.read("/proc/cpuinfo").scan(/^cpu MHz\s+:\s+(\d+)/).flatten.map{|e|"%.1fGhz" % (e.to_i/1000.0)}.join("/")
end

# display the current load average
app :loadavg do
  IO.read('/proc/loadavg').split(/ /)[0,3].join(' ')
end

# display the time
app :time do
  Time.now.strftime("%d.%m.%Y %H:%M")
end
