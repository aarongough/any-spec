require File.expand_path(File.join(File.dirname(__FILE__), '..',  'test_helper.rb'))

class TestCaseTest < Test::Unit::TestCase
  
  def setup
    @test_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_cases', 'test1.rb'))
  end
  
  test "should load test case" do
    test_case = AnySpec::TestCase.new(@test_file, "ruby")
    assert_equal test_case.test_code, 'print "this is a test"'
    assert_equal test_case.assertion_code, 'assert_output "this is a test"'
    assert_equal "ruby", test_case.target_executable
    assert_equal @test_file, test_case.path
  end
  
  test "should run test case" do
    test_case = AnySpec::TestCase.new(@test_file, "ruby")
    result = test_case.run
    assert_equal true, result
  end
  
  test "test case that is not formatted correctly should raise exception" do
    assert_raises Exception do
      @test_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_cases', 'incorrect.blah'))
      test_case = AnySpec::TestCase.new(@test_file, "ruby")
    end
  end
  
  test "empty test case should raise exception" do
    assert_raises Exception do
      @test_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_cases', 'empty.blah'))
      test_case = AnySpec::TestCase.new(@test_file, "ruby")
    end
  end
  
  test "test case that does not exist should raise exception" do
    assert_raises Exception do
      @test_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'test_cases', 'does_not_exist.blah'))
      test_case = AnySpec::TestCase.new(@test_file, "ruby")
    end
  end
  
end