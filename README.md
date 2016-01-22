[![Build Status](https://travis-ci.org/terma/goodmanager.svg?branch=master)](https://travis-ci.org/terma/goodmanager) [![Coverage Status](https://coveralls.io/repos/terma/goodmanager/badge.svg?branch=master&service=github)](https://coveralls.io/github/terma/goodmanager?branch=master)

# goodmanager
Automatically exported from code.google.com/p/goodmanager

### MacOS

To start, use:

sudo launchctl load /Library/LaunchDaemons/org.firebird.gds.plist

To stop, use:

sudo launchctl unload /Library/LaunchDaemons/org.firebird.gds.plist

To check whether it is running, you can telnet to port 3050:

telnet localhost 3050

When Firebird is running, the output would contain:

Connected to localhost.

And you will be prompted to enter a command. Just enter anything and since that is not proper Firebird protocol command, the server will close the connection.

To ensure that Firebird is running on port 3050 (and not some other server), you can run the following command (in another Terminal) while the Telnet is waiting for your input:

ps ax | grep fb_inet_server

It should contain:

/Library/Frameworks/Firebird.framework/Resources/bin/fb_inet_server

Connect by isql
 connect localhost:/Library/Frameworks/Firebird.framework/Resources/manager.fdb 
