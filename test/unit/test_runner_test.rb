require File.expand_path(File.join(File.dirname(__FILE__), '..',  'test_helper.rb'))

class TestRunnerTest < Test::Unit::TestCase
  
  def setup
    @spec_file = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', 'example_test_specification.yml'))
    @spec = YAML::load_file(@spec_file)
  end
  
  test "should create new TestRunner instance" do
    test_runner = AnySpec::TestRunner.new("ruby", @spec_file)
    assert_equal `which ruby`.strip, test_runner.target_executable
    assert_equal @spec["specification_root"], test_runner.specification_root
    assert_equal @spec["specification_extension"], test_runner.specification_extension
  end
  
end