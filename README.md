Network Destroyer Ruby Script
=============================

This is a script that came out of the need to make the iPhone simulator perform as if it were attached to a crappy network. As you can imagine this is much easier to perform on the device, but may not be as convenient. 

Prerequisites
-------------
 * OS X 10.6+ (I've only tested this on OS X, but should work with anything with ipfw installed)
 * Ruby (duh)
 
Usage
-----
 >example: ruby NetworkDestroyer.rb -e 10.0.0.1 -s 10 -p 57 -d 250

 * -e specifies the endpoint you wish you limit your connection with
 * -s specifies the speed at which you wish to limit your connection
 * -p specifies the percentage of packet loss you wish to occur on the connection
 * -d specifies the amount of delay you wish to occur on the connection

Additionally, you can use the -h or --help switch to receive the entire help output as such, 
>Usage: NetworkDestroyer.rb -e endpoint -s speed -p packetloss -d delay

>   
	-v, --version                    Display Version
    -i, --interactive                I'll guide you through setup!
    -p, --packet-loss (0-100)        Packet Loss Percentage
    -e, --endpoint (i.e. 10.0.0.1)   Endpoint You Wish To Slow Up
    -f, --flush                      Flush Old Rules
    -d, --delay NUM                  Delay In Milliseconds
    -s, --speed NUM                  Connection Speed in MBit/s
    -h, --help                       Show this screen

Planned Features
----------------
 There are no more planned features for the future, yet. I'm sure this may evolve or die on the vine as most of my projects are prone to do.

Contributing
------------
 Feel free to go ahead and fork, change, modify this code as you see fit. I'll go ahead and add an MIT license in here soon enough.