# Juggernaut for Cocoa

A Cocoa interface to Alex MacCaw's [Juggernaut](https://github.com/maccman/juggernaut) realtime push system.  Works on Mac or iPhone.

You might find this a useful alternative to Apple's Push Notification Service for in-app push scenarios.  This can work while running in the simulator, while Apple's push service only works on the real device.

NOTE: Juggernaut supports several different transports, but this uses just websocket.

## Subscribing

    JuggernautClient *client = [[JuggernautClient alloc] initWithHost:@"localhost" port:8080];

    [client subscribe:@"channel1"];

## Getting Messages

Incoming messages are posted as notifications.  You'll add an observer...

    [[NSNotificationCenter defaultCenter] addObserver:handler
                                             selector:@selector(didReceiveMessage:)
                                                 name:JuggernautDidReceiveMessageNotification
                                               object:nil];

and handle the notification...

    - (void)didReceiveMessage:(NSNotification *)notification {
        NSString *message = [notification object];
     
        // Message will look like {"data":"some message","channel":"channel1"}
        // and you can run this through your own JSON parser.
    }


## Depends on

* AsyncSocket [http://code.google.com/p/cocoaasyncsocket/](http://code.google.com/p/cocoaasyncsocket/)
* Cocoa WebSocket [https://github.com/erichocean/cocoa-websocket](https://github.com/erichocean/cocoa-websocket)
* SocketIo Client for Cocoa [https://github.com/fpotter/socketio-cocoa](https://github.com/fpotter/socketio-cocoa)
 
## Getting the code

If you have git 1.7+ ...

    git clone git://github.com/fpotter/juggernaut-cocoa.git --recursive
    
or, earlier ...

    git clone git://github.com/fpotter/juggernaut-cocoa.git juggernaut-cocoa
    cd juggernaut-cocoa
    git submodule init
    git submodule update
    cd socketio-cocoa
    git submodule init
    git submodule update
 
## Adding to your project

Copy the `AsyncSocket.h`, `AsyncSocket.m`, `WebSocket.h`, `WebSocket.m`, `SocketIoClient.h`, `SocketIoClient.m`, `JuggernautClient.h`, `JuggernautClient.m` files to your project.

**If you're building for iOS**, make sure you add a reference to the `CFNetwork` framework or you'll see compile errors from AsyncSocket.

