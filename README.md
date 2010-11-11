# Juggernaut for Cocoa

A Cocoa interface to Alex MacCaw's [Juggernaut](https://github.com/maccman/juggernaut) realtime push system.  Works on Mac or iPhone.

## Subscribe

    JuggernautClient *client = [[JuggernautClient alloc] initWithHost:@"localhost" port:8080];
    [client subscribe:@"channel1"];

