#!/usr/bin/ruby
#
# Creator: Brian Michel
# Purpose: Being able to add rules to limit network connectivity to a specific endpoint.
#
require "rubygems"
require "optparse"
$VERSION = "0.0.2"

def flush_rules
   puts %x[sudo ipfw -q flush]
   print "Okay, you should be good now!"
end

def create_rules(endpoint, delay, packetloss, connectionspeed)
  endpointArray = %x[dig #{endpoint} +short]
  splitArray = endpointArray.split("\n")
  if splitArray.count > 1 #say if our host resolves to more than one IP
    splitArray.delete_at(0)
  end
  count = 1
  splitArray.each do |_endpoint|
    puts %x[sudo ipfw add pipe #{(count * 2) - 1} ip from any to #{_endpoint}]
    puts %x[sudo ipfw add pipe #{(count * 2)} ip from #{_endpoint} to any]
    puts %x[sudo ipfw pipe #{(count * 2) - 1} config delay #{delay}ms bw #{connectionspeed}MBit/s plr #{packetloss}]
    puts %x[sudo ipfw pipe #{(count * 2)} config delay #{delay}ms bw #{connectionspeed}MBit/s plr #{packetloss}]
    count += 1
  end
end

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: Cholesterol.rb -e endpoint -s speed -p packetloss -d delay"
  opts.separator ''
  opts.on('-v', '--version', 'Display Version') do
    puts $VERSION; exit
  end
  opts.on('-i', '--interactive', "I'll guide you through setup!") do |n|
    options[:interactive] = n
  end
  opts.on('-p', '--packet-loss (0-100)', Float, "Packet Loss Percentage" ) do |n|
    options[:packetloss] = n/100
  end
  opts.on('-e', '--endpoint (i.e. 10.0.0.1)', "Endpoint You Wish To Slow Up") do |n|
    options[:endpoint] = n
  end
  opts.on('-f', '--flush', "Flush Old Rules") do |n|
    flush_rules
    exit
  end
  opts.on('-d', '--delay NUM', Integer, "Delay In Milliseconds") do |n|
    options[:delay] = n
  end
  opts.on('-s', '--speed NUM', Integer, "Connection Speed in MBit/s") do |n|
    options[:speed] = n
  end
  opts.on('-h', '--help', "Show this screen") do
    puts optparse; exit
  end
end

optparse.parse!(ARGV)

if ARGV.length >= 4 || ARGV[0] == "-i" || ARGV[0] == "--interactive"
  puts optparse; exit
end

if options[:interactive]
  print "Looks like you're trying to foul up your network, ya? (y/n): "
  if gets.chomp() != 'y'
    print "Oh, are you trying to fix it from using this script before? (y/n): "
    if gets.chomp() == 'y'
      flush_rules
      exit
    end
  else
    print "What's the IP address of the end point? "
    endpoint = gets.chomp()
    print "How much delay in ms do you want? "
    delay = gets.chomp()
    print "How fast do you want your connection in Mbit/s? "
    speed = gets.chomp()
    print "What percentage of packet loss do you want? (0-100) "
    packetloss = gets.chomp()
    create_rules(endpoint, delay, packetloss.to_f/100.0, speed)
    puts "Huzzah, things should be thoroughly messed up now, congrats!"
  end
else
  create_rules(options[:endpoint], options[:delay], options[:packetloss], options[:speed])
end