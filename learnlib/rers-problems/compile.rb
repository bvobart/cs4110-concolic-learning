#!/usr/bin/env ruby
require 'colorize'

Dir.glob('./*').each do |dir|
  match = /Problem([0-9]+)/.match(dir)
  next if match.nil?

  id = match[1]
  command = "gcc Problem#{id}/Problem#{id}.c -o Problem#{id}/a.out"

  print "[#{Time.now.to_s}] "
  puts command.yellow
  system command
  puts
end

puts "[#{Time.now.to_s}] Finished compiling all programs!"
