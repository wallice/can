require 'openssl'
require 'base64'
require 'digest/sha1'

module Can

  class Command

    def initialize file
      @file = file
      @key  = Digest::SHA1.hexdigest('yourpass')
    end

    def read_file
      begin
        content = File.read @file
        content = decrypt(content, @key)
      rescue
        content = ''
      end

      # json = content.length > 0 ? uncompress(content) : '{}'
      json = content.length > 0 ? content : '{}'
      data = JSON.parse(json)
    end

    def encrypt data, key
      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = key
      cipher.iv  = iv = cipher.random_iv

      encrypted = cipher.update(data) + cipher.final

      Base64.strict_encode64(encrypted) + '--' + Base64.strict_encode64(iv)
    end

    def decrypt data, key
      encrypted, iv = data.split('--').map {|v| Base64.strict_decode64(v)}

      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.decrypt
      cipher.key = key
      cipher.iv = iv

      cipher.update(encrypted) + cipher.final
    end

    def compress data
      Zlib::Deflate.deflate data
    end

    def uncompress data
      Zlib::Inflate.inflate data
    end

    def write_file data
      json = JSON.dump(data)
      # content = compress(json)
      content = decrypt(json, @key)
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
