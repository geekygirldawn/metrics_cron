#!/usr/bin/env ruby

time = Time.now

date = time.strftime("%m-%d-%y:%H:%M")

`wget -q -O data/puppet-users-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/puppet-users/about`

`wget -q -O data/puppet-dev-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/puppet-dev/about`

`wget -q -O data/puppet-razor-#{date}.txt --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" http://groups.google.com/group/puppet-razor/about`



