module AnySpec
  module Assertions
  
    def flunk(message = "Flunked.")
      __wrap_assertion do
        @last_assertion_result = false
        @message = message
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
    
    def assert_output(expected)
      assert( @output == expected, "Expected: '#{expected}' but was '#{@output}'")
    end
    
    def __wrap_assertion
      return if(@last_assertion_result == false)
      yield
    end
  
  end
end