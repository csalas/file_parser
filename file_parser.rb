#!/usr/bin/env ruby

# Please copy your configuration file to the same folder where you have placed this source code file. 
# To execute the program write the following instruction in the Ruby console:
# ruby file_parser.rb <configuration file name> <parameter name>
# for example:   ruby file_parser.rb config.txt log_file_path

class ConfigurationFileParser

  def main
      @configuration_file = ARGV[0].strip    
      @required_parameter = ARGV[1].strip.downcase
      search_parameter_value
  end  

  def search_parameter_value
      text=File.read(@configuration_file)
      text.gsub!(/\r\n?/, "\n")
      text.each_line do |line|
          @parameter_existence_status = false
          unless /#/.match(line) and line.strip.index('#')==0     # ignore all comments of the configuration file.
              if /#{@required_parameter}/.match(line) and 
                line.strip.index(@required_parameter)==0 and /=/.match(line.strip) and parameter_name_matches?(line)    # choosing a requested parameter of the text archive. 
                      puts get_line_parameter_value(line) 
                      return get_line_parameter_value(line) 
              end          
          end  
      end
      
  end
  
  def get_line_parameter_value(line)
    if parameter_located?
        line_parameter_value = line.partition('=').last.strip 
        line_parameter_value = line_parameter_value.slice(0..(line_parameter_value.index(/$|\s/)))
        return_formatted_value(line_parameter_value)
    else 
        return nil
    end        
  end

  def parameter_located?
    @parameter_existence_status
  end
   
  def parameter_name_matches?(line)
    line_parameter_name = line.slice(0..(line.index('='))).chop.strip.downcase
    parameter_located!  if line_parameter_name.length == @required_parameter.length 
    @parameter_existence_status
  end   

  def return_formatted_value(line_parameter_value)
       line_parameter_value = line_parameter_value.strip
       return line_parameter_value.to_i if is_integer?(line_parameter_value)
       return line_parameter_value.to_f if is_float?(line_parameter_value)   
       return true if line_parameter_value=="true" or line_parameter_value=="on" or line_parameter_value=="yes"
       return false if line_parameter_value=="false" or line_parameter_value=="off" or line_parameter_value=="no"
       return line_parameter_value
  end

  def is_integer?(line_parameter_value)
    line_parameter_value.to_i.to_s == line_parameter_value.to_s
  end
  
  def is_float?(line_parameter_value)
    line_parameter_value.to_f.to_s == line_parameter_value.to_s
  end

private

  def parameter_located!
    @parameter_existence_status = true
  end

end
  
if __FILE__ == $0
  cfp = ConfigurationFileParser.new
  cfp.main
end
