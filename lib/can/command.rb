
module Can

  class Command

    def initialize file
      @file = file
    end

    def read_file
      begin
        content = File.read @file
      rescue
        content = ''
      end

      json = content.length > 0 ? Zlib::Inflate.inflate(content) : '{}'
      data = JSON.parse(json)
    end

    def write_file data
      json = JSON.dump(data)
      content = Zlib::Deflate.deflate(json)
      File.write(@file, content)
    end

    def exists name
      data = read_file()
      data[name] ? true : false
    end    

    def get_value name
      data = read_file()
      data[name] || nil
    end    

    def copy_value value
      IO.popen('pbcopy', 'w') { |cc| cc.write(value) }
      value
    end  

    def set_value name, value
      data = read_file()
      data[name] = value
      write_file data
    end  

    def remove_value name
      data = read_file()
      data.delete name
      write_file data
    end  

  end

end
