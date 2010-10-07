module AnySpec
  class Assertions
  
    def initialize(test_case_instance)
      @test_case = test_case_instance
    end
  
    def flunk
      message = "Flunked."
      assert_block(message) { false }
    end
  
    def assert( expression )
      message = "#{expression.inspect} is not true"
      assert_block(message) { expression == true }
    end
    
    def assert_output(expected, output = @test_case.test_output)
      message = "Expected #{expected.inspect} but was #{output.inspect}"
      assert_block(message) { output == expected }
    end
    
    def assert_execution_success
      message = @test_case.test_output
      assert_block(message) { @test_case.exit_status == 0 }
    end
    
    def assert_execution_failure
      message = @test_case.test_output
      assert_block(message) { @test_case.exit_status != 0 }
    end
    
    def assert_block(message = "assert_block failed")
      return if(@test_case.last_assertion_result == false)
      unless( yield )
        @test_case.last_assertion_result = false
        @test_case.message = message
      end
    end
  
  end
end