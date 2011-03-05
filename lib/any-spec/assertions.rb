module AnySpec
  class Assertions
  
    def initialize(test_case_instance)
      @test_case = test_case_instance
    end
  
    def flunk
      message = "Flunked.".indent(3).red
      assert_block(message) { false }
    end
  
    def assert( expression )
      message = "#{expression.inspect} is not true".indent(3).red
      assert_block(message) { expression == true }
    end
    
    def assert_output(expected, output = @test_case.test_output)
      message = "Expected output to be:\n<#{expected.inspect}> but was:\n<#{output.inspect}>".indent(3).red
      assert_block(message) { output == expected }
    end
    
    def assert_execution_success
      message = "Execution of test case failed when it was expected to succeed:\n".indent(3).red
      message += @test_case.test_output.prefix_each_line_with("# ").indent(4).grey
      assert_block(message) { @test_case.exit_status == 0 }
    end
    
    def assert_execution_failure
      message = "      Execution of test case succeeded when it was expected to fail:\n"
      message += @test_case.test_output.prefix_each_line_with("# ").indent(4).grey
      assert_block(message) { @test_case.exit_status != 0 }
    end
    
    def assert_block(message = "assert_block failed")
      return if(@test_case.last_assertion_result == false)
      @test_case.assertions += 1
      unless( yield )
        @test_case.last_assertion_result = false
        @test_case.message = message
      end
    end
  
  end
end