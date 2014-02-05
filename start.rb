#!/usr/bin/env ruby
# encoding: utf-8

require "optparse"
require_relative 'tinypng_api'

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Command-line tool for shrink images by https://www.tinypng.com.\n"
  opts.banner += "Copyright (c) 2014 Zhussupov Zhassulan zhzhussupovkz@gmail.com.\n"
  opts.banner += "While using this program, get API key from https://www.tinypng.com.\nUsage: start.rb [options]"

  opts.on('-h', '--help', "show this help page") do
    puts opts
    exit
  end

  opts.on('-i', '--input FILENAME', "filename for input file") do |e|
    options[:input] = e
  end

  opts.on('-o', '--output FILENAME', "filename for output file") do |e|
    options[:output] = e
  end
end

optparse.parse!
if options.empty?
  p optparse
  exit
end

tiny = TinypngApi.new 'your api key'

t1 = Time.now
tiny.shrink_png options
t2 = (Time.now - t1).round(2).to_s

puts "Shrink image at #{t2} sec"
