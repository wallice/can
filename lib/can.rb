require 'rubygems'
require 'openssl'
require 'json'
require 'yaml'
require 'zlib'
require 'base64'
require 'digest/sha1'
require 'io/console'


module Can
  VERSION = '0.5.0'

  class Command

    def initialize file
      @file = file
    end

    def list name = nil
      data = read()
      data.each do |k, v|
        puts k
      end
    end

    def exists name
      data = read()
      data[name] ? true : false
    end    

    def get name
      data = read()
      data[name] || nil
    end    

    def copy value
      IO.popen('pbcopy', 'w') { |cc| cc.write(value) }
      value
    end  

    def set name, value
      data = read()
      data[name] = value
      write(data)
      p data
    end  

    def remove name
      data = read()
      data.delete name
      write(data)
    end  

    def encrypt file, password = nil
      password ||= ask_password()
      content = File.read file
      content = Utils.encrypt(content, password)
      content = Utils.neat(content)
    end  

    def decrypt file, password = nil
      password ||= ask_password()
      content = File.read file
      content = Utils.join(content)
      content = Utils.decrypt(content, password)
    end  

    private
    def ask_password
      print "Enter your password: "
      password = STDIN.noecho(&:gets)
      abort("The password is too short") if password.length < 1
      puts
      password
    end

    def read
      @password = ask_password()

      begin
        content = File.read @file
        # content = Utils.unzip(content)
        content = Utils.clean(content)
        content = Utils.decode(content)
        content = Utils.decrypt(content, @password)
      rescue
        content = ''
      end

      data = content.length > 0 ? JSON.parse(content) : {}
    end

    def write data
      content = JSON.dump(data)
      content = Utils.encrypt(content, @password)
      content = Utils.encode(content)
      content = Utils.neat(content)
      # content = Utils.zip(content)
      File.write(@file, content)
    end
  end

  class Utils

    def self.digest password
      Digest::SHA1.hexdigest(password)
    end

   def self.encrypt__ data, password
      secret = self.digest(password)
      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = secret
      cipher.iv  = iv = cipher.random_iv
      encrypted  = cipher.update(data) + cipher.final

      Base64.strict_encode64(encrypted) + '--' + Base64.strict_encode64(iv)
    end

   def self.encrypt data, password
      secret = self.digest(password)
      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = secret
      cipher.iv  = iv = cipher.random_iv
      encrypted  = cipher.update(data) + cipher.final

      bi = Base64.strict_encode64(iv)
      il = bi.length.to_s
      bl = Base64.strict_encode64(il)
      bd = Base64.strict_encode64(encrypted)
      bl + '--' + bi + '--' + bd
    end

    def self.decrypt data, password
      secret = self.digest(password)
      il, iv, encrypted = data.split('--').map {|v| Base64.strict_decode64(v)}

      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.decrypt
      cipher.key = secret
      cipher.iv = iv

      cipher.update(encrypted) + cipher.final
    end

    def self.decrypt__ data, password
      secret = self.digest(password)
      encrypted, iv = data.split('--').map {|v| Base64.strict_decode64(v)}

      cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      cipher.decrypt
      cipher.key = secret
      cipher.iv = iv

      cipher.update(encrypted) + cipher.final
    end

    def self.encode data
      data.unpack('H*').first
    end

    def self.decode data
      data.scan(/../).map { |x| x.hex }.pack('c*')
    end

    def self.zip data
      Zlib::Deflate.deflate data
    end

    def self.unzip data
      Zlib::Inflate.inflate data
    end

    def self.neat data
      data.scan(/.{1,64}/).join("\n")
    end

    def self.clean data
      data.split("\n").join('')
    end

  end

end
