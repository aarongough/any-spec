module AnySpec
  class TestCase
  
    attr_accessor :test_code,
                  :assertion_code
  
    def initialize(path)
      raw_test = ""
      File.open(path) {|file| raw_test = file.read }
      puts "Warning: file empty - #{path}" and return if(raw_test.empty?)
      test_parts = raw_test.split("----")
      @test_code = test_parts[0].strip
      @assertion_code = test_parts[1].strip
    end
    
    def run(silence = false)
      return "."
    end
  end
end