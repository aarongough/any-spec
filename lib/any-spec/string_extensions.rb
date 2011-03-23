class String
    
  def indent(level)
    return self.lines.map {|line|
      ("  " * level) + line
    }.join
  end
  
  def prefix_each_line_with(string)
    return self.lines.map {|line|
      string + line
    }.join
  end
  
  def red
    self.colorize(:red)
  end
  
  def green
    self.colorize(:green)
  end
  
  def white
    self.colorize(:white)
  end
  
  def grey
    self.colorize(:grey)
  end
  
  def colorize(color)
    reset_string = "\e[0m"
    case color
      when :white then color_string = "\e[37m" 
      when :red then color_string = "\e[31m"
      when :green then color_string = "\e[32m"
      when :grey then color_string = "\e[90m"
    end
    return color_string + self + reset_string
  end
    
end