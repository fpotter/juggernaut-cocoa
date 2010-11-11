# Juggernaut for Cocoa

A Cocoa interface to Alex MacCaw's [Juggernaut](https://github.com/maccman/juggernaut) realtime push system.  Works on Mac or iPhone.

## Subscribe

    JuggernautClient *client = [[JuggernautClient alloc] initWithHost:@"localhost" port:8080];

    [client subscribe:@"channel1"];

## Depends on

* AsyncSocket [http://code.google.com/p/cocoaasyncsocket/](http://code.google.com/p/cocoaasyncsocket/)
* Cocoa WebSocket [https://github.com/erichocean/cocoa-websocket](https://github.com/erichocean/cocoa-websocket)
* SocketIo Client for Cocoa [https://github.com/fpotter/socketio-cocoa](https://github.com/fpotter/socketio-cocoa)
 
## Adding to your project

Copy the `AsyncSocket.h`, `AsyncSocket.m`, `WebSocket.h`, `WebSocket.m`, `SocketIoClient.h`, `SocketIoClient.m` files to your project.

If you're building for iOS, make sure you add a reference to the `CFNetwork` framework or you'll see compile errors from AsyncSocket.

