require File.expand_path(File.join(File.dirname(__FILE__), '..',  'test_helper.rb'))

class TestRunnerTest < Test::Unit::TestCase
  
  def setup
    @spec_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'example_test_specification.yml'))
    @spec = YAML::load_file(@spec_file)
  end
  
  test "should create new TestRunner instance" do
    test_runner = AnySpec::TestRunner.new("ruby", @spec_file)
    assert_equal 'ruby', test_runner.target_executable
    assert_equal @spec["specification_root"], test_runner.specification_root
    assert_equal @spec["specification_extension"], test_runner.specification_extension
    assert_equal 4, test_runner.test_case_paths.length
    assert_equal 4, test_runner.test_cases.length
  end
  
  test "should raise error when specification file does not exist" do
    assert_raises Exception do
      test_runner = AnySpec::TestRunner.new("ruby", "~/blah/foo/blag.bar")
    end
  end
  
  test "should run test cases" do
    test_runner = AnySpec::TestRunner.new("ruby", @spec_file)
    results = test_runner.run_tests(true)
    assert_equal 4, results.length
  end
  
end