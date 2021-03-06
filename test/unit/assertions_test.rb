require File.expand_path(File.join(File.dirname(__FILE__), '..',  'test_helper.rb'))

class AssertionsTest < Test::Unit::TestCase
  
  require 'ostruct'
  
  def setup
    @test_case = OpenStruct.new
    @test_case.last_assertion_result = true
    @test_case.message = ""
    @test_case.assertions = 0
  end
  
  test "assert_block should pass when block returns true" do
    AnySpec::Assertions.new(@test_case).assert_block {true}
    assert_equal true, @test_case.last_assertion_result
    assert_equal "", @test_case.message
  end
  
  test "assert_block should increment assertion counter" do
    AnySpec::Assertions.new(@test_case).assert_block {true}
    assert_equal 1, @test_case.assertions
    AnySpec::Assertions.new(@test_case).assert_block {true}
    assert_equal 2, @test_case.assertions
  end
  
  test "assert_block should fail when block returns false" do
    AnySpec::Assertions.new(@test_case).assert_block {false}
    assert_equal false, @test_case.last_assertion_result
    assert_equal "assert_block failed", @test_case.message
  end
  
  test "flunk should flunk" do
    AnySpec::Assertions.new(@test_case).flunk
    assert_equal false, @test_case.last_assertion_result
    assert @test_case.message.include? "Flunked."
  end
  
  test "assert should assert truthiness" do
    AnySpec::Assertions.new(@test_case).assert(true)
    assert_equal true, @test_case.last_assertion_result
    assert_equal "", @test_case.message
  end
  
  test "assert should fail on false" do
    AnySpec::Assertions.new(@test_case).assert(false)
    assert_equal false, @test_case.last_assertion_result
    assert @test_case.message.include? "false is not true"
  end
  
  test "assert should fail on nil" do
    AnySpec::Assertions.new(@test_case).assert(nil)
    assert_equal false, @test_case.last_assertion_result
    assert @test_case.message.include? "nil is not true"
  end
  
  test "assert_output should pass when output matches" do
    @test_case.test_output = "test"
    AnySpec::Assertions.new(@test_case).assert_output("test")
    assert_equal true, @test_case.last_assertion_result
    assert_equal "", @test_case.message
  end
  
  test "assert_output should fail when output does not match" do
    @test_case.test_output = "test2"
    AnySpec::Assertions.new(@test_case).assert_output("test")
    assert_equal false, @test_case.last_assertion_result
    assert @test_case.message.include? "Expected output to be:"
    assert @test_case.message.include? '<"test">'
    assert @test_case.message.include? 'but was:'
    assert @test_case.message.include? '<"test2">'
  end
  
  test "assert_execution_success should pass when exit_status == 0" do
    @test_case.exit_status = 0
    @test_case.test_output = ""
    AnySpec::Assertions.new(@test_case).assert_execution_success
    assert_equal true, @test_case.last_assertion_result
    assert_equal '', @test_case.message
  end
  
  test "assert_execution_success should fail when exit_status != 0" do
    @test_case.test_output = "test2"
    @test_case.exit_status = 1
    AnySpec::Assertions.new(@test_case).assert_execution_success
    assert_equal false, @test_case.last_assertion_result
    assert @test_case.message.include? "Execution of test case failed when it was expected to succeed:"
    assert @test_case.message.include? "test2"
  end
  
  test "assert_execution_failure should fail when exit_status == 0" do
    @test_case.test_output = "test2"
    @test_case.exit_status = 0
    AnySpec::Assertions.new(@test_case).assert_execution_failure
    assert_equal false, @test_case.last_assertion_result
    assert @test_case.message.include? "Execution of test case succeeded when it was expected to fail:"
    assert @test_case.message.include? "test2"
  end
  
  test "assert_execution_failure should pass when exit_status != 0" do
    @test_case.exit_status = 1
    @test_case.test_output = ""
    AnySpec::Assertions.new(@test_case).assert_execution_failure
    assert_equal true, @test_case.last_assertion_result
    assert_equal '', @test_case.message
  end
  
end