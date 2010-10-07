module AnySpec
  class TestCase
  
    attr_accessor :test_code,
                  :assertion_code,
                  :target_executable,
                  :path,
                  :last_assertion_result,
                  :message
        
    include AnySpec::Assertions          
  
    def initialize(path, target_executable)
      @path = path
      @target_executable = target_executable
      raw_test = ""
      File.open(path) {|file| raw_test = file.read }
      puts "Warning: file empty - #{path}" and return if(raw_test.empty?)
      test_parts = raw_test.split("----")
      @test_code = test_parts[0].strip
      @assertion_code = test_parts[1].strip
    end
    
    def run(silence = false)
      temporary_filename = File.join( File.split(@path)[0], "#{Time.now.to_i}-any-spec" + File.extname(@path) )
      tmp = File.open(temporary_filename, "w")
      tmp.write(@test_code)
      tmp.close
      @output = `#{@target_executable} #{temporary_filename} 2>&1`
      @exitstatus = $?.exitstatus
      @last_assertion_result = true
      @message = ""
      eval(@assertion_code, binding, @path)
      return @last_assertion_result
    ensure
      File.delete(temporary_filename)
    end
    
  end
end