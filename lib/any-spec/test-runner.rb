module AnySpec
  class TestRunner
  
    require 'yaml'
    
    attr_accessor :target_executable,
                  :specification_root,
                  :specification_extension,
                  :test_case_paths,
                  :test_cases,
                  :report
  
    def initialize( target_executable, test_specification_file )
      # Verify that the target executable exists and is in the current PATH
      @target_executable = target_executable.strip
      # Load the test specification file
      @test_specification_file = File.expand_path(test_specification_file)
      raise Exception, "The test specification file you supplied does not exist." unless(File.exist? @test_specification_file)
      test_spec = YAML::load_file(@test_specification_file)
      @specification_root = test_spec["specification_root"]
      @specification_extension = test_spec["specification_extension"]
      # Find and load test-case file paths
      @test_case_paths = Dir[File.join(File.split(@test_specification_file)[0], @specification_root, '**',  "*" + @specification_extension)].sort
      # Instantiate the test cases
      @test_cases = @test_case_paths.map do |test_case|
        AnySpec::TestCase.new(test_case, @target_executable)
      end
    end
    
    def run_tests(silence = false)
      @report = ""
      @silence = silence
      message "\nLoaded suite: #{@test_specification_file}\n"
      message "Targeting: #{@target_executable}\n"
      message "\nStarted\n"
      start_time = Time.now
      assertions = 0
      failed_tests = []
      @test_cases.each do |test_case|
        result = test_case.run
        message "." if(result)
        message "F" if(!result)
        assertions += test_case.assertions
        failed_tests << test_case if(!result)
      end
      message "\nFinished in #{(Time.now - start_time).to_f} seconds.\n\n"
      failed_tests.each_index do |x|
        test_case = failed_tests[x]
        message "  #{x + 1}) Failure:\n"
        message "In file: " + test_case.path.gsub(File.split(@test_specification_file)[0], "") + "\n"
        message test_case.message + "\n\n"
      end
      pass_rate = format("%.2f",(100.0 - ((failed_tests.length.to_f) / @test_cases.length) * 100))
      message "#{@test_cases.length} tests, #{assertions} assertions, #{failed_tests.count} failures, #{pass_rate}% pass rate\n\n"
      return @test_cases
    end
    
    def message(string)
      if(@silence)
        @report << string
      else
        print string
        $stdout.flush
      end
    end
    
  end
end