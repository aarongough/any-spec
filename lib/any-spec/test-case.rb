module AnySpec
  class TestCase
  
    attr_accessor :test_code,
                  :assertion_code,
                  :target_executable,
                  :path,
                  :last_assertion_result,
                  :message,
                  :test_output,
                  :exit_status,
                  :assertions     
  
    def initialize(path, target_executable)
      raise Exception, "\n\nNo test case exists at path: #{path}" unless(File.exist?(path))
      raise Exception, "\n\nTest case is empty: #{path}" if(File.size(path) == 0)
      raw_test = File.open(path).read
      test_parts = raw_test.split("----")
      raise Exception, "\n\nTest case formatted incorrectly: #{path}" unless(test_parts.length == 2)
      @test_code = test_parts[0].strip
      @assertion_code = test_parts[1].strip
      @path = path
      @target_executable = target_executable
    end
    
    def run
      temporary_filename = File.join( File.split(@path)[0], "#{Time.now.to_i}-any-spec" + File.extname(@path) )
      tmp = File.open(temporary_filename, "w")
      tmp.write(@test_code)
      tmp.close
      @test_output = `#{@target_executable} #{temporary_filename} 2>&1`
      @exit_status = $?.exitstatus
      @last_assertion_result = true
      @message = ""
      @assertions = 0
      AnySpec::Assertions.new(self).instance_eval(@assertion_code, @path)
      return @last_assertion_result
    ensure
      File.delete(temporary_filename)
    end
    
  end
end