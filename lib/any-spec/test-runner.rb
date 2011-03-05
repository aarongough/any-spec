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
      message "\nStarted\n"
      start_time = Time.now
      assertions = 0
      failed_tests = []
      @test_cases.each do |test_case|
        result = test_case.run
        message ".", :green if(result)
        message "F", :red if(!result)
        assertions += test_case.assertions
        failed_tests << test_case if(!result)
      end
      message "\n\n"
      message "Failures:\n\n" unless failed_tests.empty?
      failed_tests.each_index do |x|
        test_case = failed_tests[x]
        message "  #{x + 1}) " + test_case.path.gsub(File.split(@test_specification_file)[0], "") + "\n"
        message test_case.message + "\n\n"
      end
      message "\n\nFinished in #{(Time.now - start_time).to_f} seconds.\n"
      pass_rate = format("%.2f",(100.0 - ((failed_tests.length.to_f) / @test_cases.length) * 100))
      result_color = failed_tests.count == 0 ? :green : :red
      message "#{@test_cases.length} tests, #{assertions} assertions, #{failed_tests.count} failures, #{pass_rate}% pass rate\n", result_color
      return @test_cases
    end
    
    def message(string, color = :white)
      if(@silence)
        @report << string
      else
        case color
          when :white then print( "\e[37m" )
          when :red then print( "\e[31m" )
          when :green then print( "\e[32m" )
          when :grey then print( "\e[90m")
        end
        print string + "\e[0m"
        $stdout.flush
      end
    end
    
  end
end