#!/usr/bin/ruby
#
# Creator: Brian Michel
# Purpose: Being able to add rules to limit network connectivity to a specific endpoint.
#
require "rubygems"
require "optparse"
$VERSION = "0.0.3"

def problem?
  File.open("problem.txt").each { |line|
    puts line
  }
end

def colored_message(text, color, exitcolor="0m")
  puts "\033[#{color}#{text}\033[#{exitcolor}"
end
def flush_rules
   puts %x[sudo ipfw -q flush]
   puts "Okay, you should be good now!"
end

def create_rule(count, endpoint, delay, connectionspeed, packetloss)
  if count != nil
    puts %x[sudo ipfw add pipe #{(count * 2) - 1} ip from any to #{endpoint}]
    puts %x[sudo ipfw add pipe #{(count * 2)} ip from #{endpoint} to any]
    puts %x[sudo ipfw pipe #{(count * 2) - 1} config delay #{delay}ms bw #{connectionspeed}MBit/s plr #{packetloss}]
    puts %x[sudo ipfw pipe #{(count * 2)} config delay #{delay}ms bw #{connectionspeed}MBit/s plr #{packetloss}]
  else #if we do not pass any endpoint into the function, it only needs to create two rules to block everything.˝
    puts %x[sudo ipfw add pipe 1 ip from any to #{endpoint}]
    puts %x[sudo ipfw add pipe 2 ip from #{endpoint} to any]
    puts %x[sudo ipfw pipe 1 config delay #{delay}ms bw #{connectionspeed}MBit/s plr #{packetloss}]
    puts %x[sudo ipfw pipe 2 config delay #{delay}ms bw #{connectionspeed}MBit/s plr #{packetloss}]
  end 
end

def create_rules(endpoint, delay, packetloss, connectionspeed)
  if endpoint == nil #catch to see if the user has not entered an endpoint, if not, block it all!
    endpoint = "any"
    colored_message("****No endpoint given, clogging everything.****", "31m")
  else
    endpoints = endpoint.split(",")
    endpoints.each do |r|
      colored_message("****Creating rule for: #{r.strip}****", "31m")
    end
  end
  
  colored_message("Stuffing the tubes...", "36;44m")
  if endpoint != "any"
    count = 1
    endpoints.each do |endpoint|
      endpointArray = %x[dig #{endpoint.strip} +short]
      splitArray = endpointArray.split("\n")
      if splitArray.count > 1 #say if our host resolves to more than one IP
        splitArray.delete_at(0)
      end
      
      splitArray.each do |digendpoint|
        create_rule(count, digendpoint, delay, connectionspeed, packetloss)
        count += 1
      end
    end
  else
    create_rule(nil, endpoint, delay, connectionspeed, packetloss)
  end
  colored_message("Tubes stuffed!", "36;44m")
end

# Make hash and set default values
options = {}
options[:packetloss] = 0
options[:delay] = 0
options[:speed] = 100

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: Cholesterol.rb -e endpoint -s speed -l packetloss -d delay"
  opts.separator ''
  opts.on('-v', '--version', 'Display Version') do
    puts "Cholesterol Version:" + $VERSION + " Created by Brian Michel 2010"; exit
  end
  opts.on('-i', '--interactive', "I'll guide you through setup!") do |n|
    options[:interactive] = n
  end
  opts.on('-l', '--packet-loss [0-100]', Float, "Packet Loss Percentage" ) do |n|
    options[:packetloss] = n/100
  end
  opts.on('-e', '--endpoint [IP or Hostname]', "Endpoint(s) To Slow Connectivity To (i.e. \"www.google.com, www.wikipedia.org\")") do |n|
    options[:endpoint] = n
  end
  opts.on('-f', '--flush', "Flush Old Rules") do |n|
    flush_rules
    exit
  end
  opts.on('-d', '--delay [NUM]', Integer, "Delay In Milliseconds") do |n|
    options[:delay] = n
  end
  opts.on('-s', '--speed [NUM]', Integer, "Connection Speed in MBit/s") do |n|
    options[:speed] = n
  end
  opts.on('-p', '--problem', "Problem?") do |n|
    options[:problem] = n;
  end
  opts.on('-h', '--help', "Show this screen") do
    puts optparse; exit
  end
end

if ARGV.length == 0
  puts optparse; exit
end

optparse.parse!(ARGV)

if options[:interactive]
  print "Looks like you're trying to foul up your network, ya? (y/n): "
  if gets.chomp() != 'y'
    print "Oh, are you trying to fix it from using this script before? (y/n): "
    if gets.chomp() == 'y'
      flush_rules
      exit
    end
  else
    print "What's the IP/host of the end point? "
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
  if options[:problem]
    problem?
    exit
  end
  create_rules(options[:endpoint], options[:delay], options[:packetloss], options[:speed])
end