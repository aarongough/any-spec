module AnySpec
  class TestRunner
  
    require 'yaml'
    
    attr_accessor :target_executable,
                  :specification_root,
                  :specification_extension
  
    def initialize( target_executable, test_specification_file )
      # Verify that the target executable exists and is in the current PATH
      @target_executable = `which #{target_executable}`.strip
      raise Exception, "The target executable you specified does not exist!" if(@target_executable.empty?)
      
      # Load the test specification file
      test_specification_file = File.expand_path(test_specification_file)
      raise Exception, "The test specification file you supplied does not exist." unless(File.exist? test_specification_file)
      test_spec = YAML::load_file(test_specification_file)
      @specification_root = test_spec["specification_root"]
      @specification_extension = test_spec["specification_extension"]
    end
  end
end