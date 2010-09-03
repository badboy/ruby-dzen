require 'helper'
require 'ostruct'

context "Base" do
  class TestClass
    include DZEN::Helpers

    def dzen
      OpenStruct.new({
        :config => OpenStruct.new({:color => {
                     :start => proc{|c|"<c(#{c})>"},
                     :end   => proc{|c|"</c(#{c})>"}
                     }
                   })
      })
    end
  end

  setup do
    @test = TestClass.new
  end

  test "_color" do
    assert_equal %|<c(red)>foo</c(red)>|, @test._color('red', 'foo')
  end

  test "color_critical" do
    colors = { :normal => 'white', :critical => 'red' }
    assert_equal %|0|, @test.color_critical(0, 0, colors)
    assert_equal %|<c(white)>5</c(white)>|, @test.color_critical(5, 6, colors)
    assert_equal %|<c(red)>7</c(red)>|, @test.color_critical(7, 6, colors)
  end
end
