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

# Get current time and format into a nicely readable string down to minutes / seconds.

time = Time.now

date = time.strftime("%m-%d-%y:%H:%M")
monthname = time.strftime("%B")

# Get the HTML files with the Google Groups data

# pull data from config.yaml

config = YAML::load_file("#{configdir}/config.yaml")

# Get files
config.keys.each do |groups|
  config[groups].each do |lists|
    datafile = "#{datadir}/#{lists}-#{date}.txt"
    `wget -q -O #{datafile} --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/#{lists}/about`

# Open and initialize YAML file for monthly posts data

  monthlypostsfile = "#{datadir}/#{lists}-#{date}-monthly.yaml"

  open(monthlypostsfile, 'w') { |mpf|
    mpf.puts "---"
    mpf.puts "\"Monthly Posts\":"

# Loop through files and pull monthly numbers
  File.open(datafile) do |monthly_data| monthly_posts = []
    monthly_data.each do |line|
      if line =~ /browse_frm\/month/
        line = line.delete "&nbsp;" # get rid of &nbsp;
        month = line[/(19|20)\d\d[-](0[1-9]|1[012])/] # match date
        posts = line[/\>(\d*)/] # match 1st number after >
        posts = posts.delete ">" # delete > from string
        mpf.puts "  #{month}: \'#{posts}\'"
      end
      
    end
  end
  }

  # Open and initialize text file for user posts intermediate data
  # This is needed since user posts and name are on 2 separate lines

  userpostsfile = "#{datadir}/#{lists}-#{date}-users.txt"

  open(userpostsfile, 'w') { |upf|

  # Loop through files and pull user numbers
  File.open(datafile) do |monthly_data| monthly_posts = []
    monthly_data.each do |line|
      
      if line =~ /This month/
        upf.puts "This Month"
      end 

      if line =~ /All time/
        upf.puts "All time"
      end

      if line =~ /<td width=1% align="right" nowrap>/
        userposts = line[/\>(\d*)/] # match 1st number after >
        userposts = userposts.delete ">" # delete > from string    
        upf.print "#{userposts}:"
      end

      if line =~ /padr5/
        username = line[/top>(.*)/]
        username["top>"] = ""
        username["</a></td>"] = ""
        upf.puts "#{username}"
      end
    end
  end
  }

  # Open and initialize yaml file for user posts data
  
  userpostsyamlfile = "#{datadir}/#{lists}-#{date}-users.yaml"

  open(userpostsyamlfile, 'w') { |upyf|
    upyf.puts "---"

  # Loop through files and pull user numbers
  File.open(userpostsfile) do |monthly_user_data| monthly_user_posts = []
    monthly_user_data.each do |line|
    
      if line =~ /This Month/
        upyf.puts "\"Posts for #{monthname}\":"
      elsif line =~ /All time/
        upyf.puts "\"All time\":"
      else
        line = line.split(':')
        upyf.puts "  #{line.last.chomp}: #{line.first}"
      end

    end
  end
  }

  end
end

