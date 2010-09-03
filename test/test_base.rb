require 'helper'

context "Base" do
  setup do
    @base = DZEN::Base.new
  end

  test "configure" do
    @base.configure { |c| c.interval = 42 }
    assert_equal 42, @base.config.interval
  end

  test "add before_run handler" do
    @base.add_before_run { 42 }
    assert @base.instance_eval{@before_run_handler}
    assert_equal 1, @base.instance_eval{@before_run_handler}.length
    assert_equal 42, @base.instance_eval{@before_run_handler}.first.call
  end

  test "set order" do
    @base.order = [:cpu, :load, :clock]
    assert_equal [:cpu, :load, :clock], @base.instance_eval{@order}
  end

  test "add app handler" do
    @base.add_handler(:cpu, {}) { }
    assert_equal 1, @base.instance_eval{@apps}.size
    @base.add_handler(:load, {}) { }
    assert_equal 2, @base.instance_eval{@apps}.size
  end

  test "sort apps" do
    @base.add_handler(:load, {}) { }
    @base.add_handler(:cpu, {}) { }
    assert_equal [:load, :cpu], @base.instance_eval{@apps}.map{|a|a.first}
    @base.order = [:cpu, :load]
    @base.sort_apps!
    assert_equal [:cpu, :load], @base.instance_eval{@apps}.map{|a|a.first}
  end

  class OutputHandler
    attr_accessor :output
    def initialize
      @output = ''
    end

    def to_s
      @output.to_s
    end

    def puts(msg)
      @output << msg << "\n"
    end

    def print(msg)
      @output << msg
    end
  end

  test "run it" do
    output = OutputHandler.new
    @base.configure do |c|
      c.interval = 0.1
      c.delimiter = '|'
      c.output = output
    end
    @base.add_handler(:one, {}) { "1" }
    @base.add_handler(:two, {}) { "2" }
    t = Thread.new { @base.run! }
    sleep @base.config.interval*2
    t.kill
    assert_equal "1|2\n", output.to_s
  end
end
