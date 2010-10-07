module AnySpec
  class TestRunner
  
    require 'yaml'
    
    attr_accessor :target_executable,
                  :specification_root,
                  :specification_extension,
                  :test_case_paths,
                  :test_cases
  
    def initialize( target_executable, test_specification_file )
      # Verify that the target executable exists and is in the current PATH
      @target_executable = `which #{target_executable}`.strip
      raise Exception, "The target executable you specified does not exist!" if(@target_executable.empty?)
      # Load the test specification file
      test_specification_file = File.expand_path(test_specification_file)
      raise Exception, "The test specification file you supplied does not exist." unless(File.exist? test_specification_file)
      test_spec = YAML::load_file(test_specification_file)
      @specification_root = test_spec["specification_root"]
      @specification_extension = test_spec["specification_extension"]
      # Find and load test-case file paths
      @test_case_paths = Dir[File.join(File.split(test_specification_file)[0], @specification_root, '**',  "*" + @specification_extension)].sort
      # Instantiate the test cases
      @test_cases = @test_case_paths.map do |test_case|
        AnySpec::TestCase.new(test_case, @target_executable)
      end
    end
    
    def run_tests(silence = false)
      @test_cases.each do |test_case|
        result = test_case.run(silence)
      end
    end
  end
end