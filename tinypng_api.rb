=begin
/*

The MIT License (MIT)

Copyright (c) 2014 Zhussupov Zhassulan zhzhussupovkz@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/
=end

require 'net/http'
require 'net/https'
require 'json'
require 'openssl'
require 'base64'

class TinypngApi

  def initialize api_key
    @api_key = api_key
    @api_url = 'https://api.tinypng.com/shrink'
  end
  
  def shrink_png options = { :input => 'ruby.png', :output => 'ruby-output.png' }
    uri = URI.parse(@api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    req.basic_auth "api", @api_key
    res = http.request(req, File.read(options[:input]))
    raise "Error returned data format" if res.code != "201"
    image = http.get(res["location"]).body
    if options.key?(:output) == true
      output = options[:output].to_s
    else
      output = options[:input].to_s.gsub(/.png/, '-output.png')
    end
    File.new("#{output}", 'wb').write(image)
    data = res.body
    result = JSON.parse(data)
    puts "Image '" + options[:input] + "' shrink: OK"
    puts "Input image size: " + result['input']['size'].to_s + " bytes"
    puts "Output image size: " + result['output']['size'].to_s + "bytes"
  end

end