Cholesterol Ruby Script
=============================

This is a script that came out of the need to make the iPhone simulator perform as if it were attached to a crappy network. As you can imagine this is much easier to perform on the device, but may not be as convenient. 

Prerequisites
-------------
 * OS X 10.6+ (I've only tested this on OS X, but should work on anything with ipfw installed)
 * Ruby (duh)
 
Usage
-----
 >example: ruby Cholesterol.rb -e 10.0.0.1 -s 10 -l 57 -d 250

 * -e specifies the endpoint(s)* you wish you limit your connection with
 * -s specifies the speed at which you wish to limit your connection (default is 100Mbit)
 * -l specifies the percentage of packet loss you wish to occur on the connection (default is 0%)
 * -d specifies the amount of delay you wish to occur on the connection (default is 0ms)

 *make sure to enclose multiple endpoints in quotes if using a space between the comma delimiter.

Additionally, you can use the -h or --help switch to receive the entire help output as such, 
>Usage: Cholesterol.rb -e endpoint -s speed -l packetloss -d delay
>
    -v, --version                    Display Version
    -i, --interactive                I'll guide you through setup!
    -l, --packet-loss [0-100]        Packet Loss Percentage
    -e, --endpoint [IP or Hostname]  Endpoint(s) To Slow Connectivity To (i.e. "www.google.com, www.wikipedia.org")
    -f, --flush                      Flush Old Rules
    -d, --delay [NUM]                Delay In Milliseconds
    -s, --speed [NUM]                Connection Speed in MBit/s
    -p, --problem                    Problem?
    -h, --help                       Show this screen


Planned Features
----------------
 There are no more planned features for the future, yet. I'm sure this may evolve or die on the vine as most of my projects are prone to do.

Contributing
------------
 Feel free to go ahead and fork, change, modify this code as you see fit. I'll go ahead and add an MIT license in here soon enough.

Changes
-------
* 11/26/2010 - Added support for multiple host addition. i.e. "www.google.com, www.wikipedia.org" will make both sets of rules.
* 11/26/2010 - Added support if user enters no endpoint. This will cause everything to be clogged, also set default values if the 		user does not configure the script themselves. Added experimental -p option. 
* 10/27/2010 - Added in hostname resolution and rule setting for all resolved IPs