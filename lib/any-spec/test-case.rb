module AnySpec
  class TestCase
  
    attr_accessor :test_code,
                  :assertion_code,
                  :target_executable,
                  :path
                  
  
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
      tmp.flush
      output = `#{@target_executable} #{temporary_filename} 2>&1`
      eval(@assertion_code, binding, @path)
    end
    
  end
end