require File.expand_path(File.join(File.dirname(__FILE__), '..',  'test_helper.rb'))

class TestCaseTest < Test::Unit::TestCase
  
  def setup
    @test_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_cases', 'test1.rb'))
  end
  
  test "should load test case" do
    test_case = AnySpec::TestCase.new(@test_file)
    test_case.test_code = 'print "this is a test"'
    test_case.assertion_code = 'assert_output "this is a test"'
  end
  
  test "should run test case" do
    test_case = AnySpec::TestCase.new(@test_file)
    result = test_case.run(true)
    assert_equal ".", result
  end
  
end