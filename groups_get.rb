#!/usr/bin/env ruby 

require 'yaml'

# Takes 2 arguments: 
# 1: Optional existing directory name (no trailing /) where the output will be stored.
#    Defaults to data in local directory.
# 2: Optional directory name (no trailing /) where config.yaml is stored.
#    Defaults to local directory.
# Aborts if too many arguments are provided.
# Note: You will need both of these arguments to run it from cron.

if ARGV.length == 0
   datadir = "data"
   configdir = "."
elsif ARGV.length == 1 
   datadir = ARGV[0]
   configdir = "."
elsif ARGV.length == 2
   datadir = ARGV[0]
   configdir = ARGV[1]
else
   abort("Program aborted. Error: Too many arguments. \nTwo optional arguments with a data directory name and config.yaml directory name are permitted")
end

puts "datadir: #{datadir}"
puts "configdir: #{configdir}"

# Get current time and format into a nicely readable string down to minutes / seconds.

time = Time.now

date = time.strftime("%m-%d-%y:%H:%M")

# Get the HTML files with the Google Groups data

# pull data from config.yaml

config = YAML::load_file("#{configdir}/config.yaml")

config.keys.each do |groups|
  config[groups].each do |lists|
    `wget -q -O #{datadir}/#{lists}-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/#{lists}/about`
  end
end

