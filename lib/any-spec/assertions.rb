module AnySpec
  class Assertions
  
    def initialize(test_case_instance)
      @test_case = test_case_instance
    end
  
    def flunk(message = "Flunked.")
      __wrap_assertion do
        @test_case.last_assertion_result = false
        @test_case.message = message
      end
    end
  
    def assert( expression, message = "Was not true")
      __wrap_assertion do
        unless(expression)
          @last_assertion_result = false
          @message = message
        end
      end
    end
    
    def assert_output(expected, output = @output)
      assert( output == expected, "Expected: '#{expected}' but was '#{output}'")
    end
    
    def __wrap_assertion
      return if(@test_case.last_assertion_result == false)
      yield
    end
  
  end
end