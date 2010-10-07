require File.expand_path(File.join(File.dirname(__FILE__), '..',  'test_helper.rb'))

class AssertionsTest < Test::Unit::TestCase
  
  require 'ostruct'
  
  def setup
    @test_case = OpenStruct.new
    @test_case.last_assertion_result = true
    @test_case.message = ""
  end
  
  test "flunk should flunk" do
    AnySpec::Assertions.new(@test_case).flunk
    assert_equal false, @test_case.last_assertion_result
    assert_equal "Flunked.", @test_case.message
  end
  
end