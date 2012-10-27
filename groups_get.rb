#!/usr/bin/env ruby 

# Takes 1 argument: an existing directory name (no trailing /) 
#    where the output will be stored.
# If no arguments: defaults to data as local directory name.
# Aborts if too many arguments are provided.

if ARGV.length == 0
   dir = "data"
elsif ARGV.length == 1 
   dir = ARGV[0]
else
   abort("Program aborted. Error: Too many arguments. One optional argument with a directory name is permitted")
end

# Get current time and format into a nicely readable string down to minutes / seconds.

time = Time.now

date = time.strftime("%m-%d-%y:%H:%M")

# Get the HTML files with the Google Groups data

`wget -q -O #{dir}/puppet-users-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/puppet-users/about`

`wget -q -O #{dir}/puppet-dev-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/puppet-dev/about`

`wget -q -O #{dir}/puppet-razor-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/puppet-razor/about`



