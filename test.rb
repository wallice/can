#!/usr/bin/env ruby

require 'openssl'
require 'base64'
require 'zlib'
require 'digest/sha1'

data = 'Very, very confidential data.'
key  = Digest::SHA1.hexdigest('password')

def encrypt data, key
  cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv  = iv = cipher.random_iv
  encrypted  = cipher.update(data) + cipher.final

  enc = Base64.strict_encode64(encrypted) + '--' + Base64.strict_encode64(iv)
  enc = encode enc
  enc = compress enc
  enc
end

def decrypt data, key
  data = uncompress data
  data = decode data
  encrypted, iv = data.split('--').map {|v| Base64.strict_decode64(v)}
  cipher = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
  cipher.decrypt
  cipher.key = key
  cipher.iv = iv

  cipher.update(encrypted) + cipher.final
end

def encode(s)
  s.unpack('H*').first
end

def decode(s)
  s.scan(/../).map { |x| x.hex }.pack('c*')
end

def compress data
  Zlib::Deflate.deflate data
end

def uncompress data
  Zlib::Inflate.inflate data
end

puts mess = encrypt(data, key)
puts back = decrypt(mess, key)
