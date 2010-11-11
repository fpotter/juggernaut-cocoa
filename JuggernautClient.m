//
//  JuggernautClient.m
//  juggernaut-cocoa
//
//  Created by Fred Potter on 11/11/10.
//  Copyright 2010 Fred Potter. All rights reserved.
//

#import "JuggernautClient.h"
#import "SocketIoClient.h"

NSString *JuggernautDidReceiveMessageNotification = @"JuggernautDidReceiveMessageNotification";
NSString *JuggernautDidDisconnectNotification = @"JuggernautDidDisconnectNotification";
NSString *JuggernautDidConnectNotification = @"JuggernautDidConnectNotification";

enum {
  JNStateDisconnected,
  JNStateConnecting,
  JNStateConnected,
};

@interface JuggernautClient (FP_Private) <SocketIoClientDelegate>
- (void)connect;
- (void)disconnect;
- (void)reconnect;
@end

@implementation JuggernautClient

@synthesize shouldReconnect = _shouldReconnect;

- (id)initWithHost:(NSString *)host port:(int)port {
  if (self = [super init]) {
    _socketIoClient = [[SocketIoClient alloc] initWithHost:host port:port];
    _socketIoClient.delegate = self;
    _state = JNStateDisconnected;
    
    _queue = [[NSMutableArray array] retain];
    
    _shouldReconnect = YES;
  }
  return self;
}

- (void)dealloc {
  [_socketIoClient release];
  [_queue release];
  [super dealloc];
}

- (void)subscribe:(NSString *)channel {
  
  NSString *command = [NSString stringWithFormat:@"{ \"type\" : \"subscribe\", \"channel\" : \"%@\" }", channel];
  
  if (_state == JNStateConnected) {
    [_socketIoClient send:command isJSON:NO];
  } else {
    [_queue addObject:command];
    [self connect];
  }
}

- (void)unsubscribe:(NSString *)channel {
  NSString *command = [NSString stringWithFormat:@"{ \"type\" : \"subscribe\", \"channel\" : \"%@\" }", channel];
  
  if (_state == JNStateConnected) {
    [_socketIoClient send:command isJSON:NO];
  } else {
    [_queue addObject:command];
    [self connect];
  }  
}

- (void)disconnect {
  [_socketIoClient disconnect];
}

- (void)doQueue {
  for (NSString *command in _queue) {
    [_socketIoClient send:command isJSON:NO];
  }
}

- (void)onConnect {
  _state = JNStateConnected;
  
  [self doQueue];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:JuggernautDidConnectNotification
                                                      object:nil
                                                    userInfo:nil];  
}

- (void)onDisconnect {
  _state = JNStateDisconnected;

  [[NSNotificationCenter defaultCenter] postNotificationName:JuggernautDidDisconnectNotification
                                                      object:nil
                                                    userInfo:nil];  
  
  if (_shouldReconnect) {
    [self reconnect];
  }
}

- (void)connect {
  if (_state == JNStateConnected || _state == JNStateConnecting) {
    return;
  }
  
  _state = JNStateConnecting;
  [_socketIoClient connect];
}

- (void)checkIfConnected {
  if (_state != JNStateConnected) {
    [self connect];
    [self performSelector:@selector(checkIfConnected) withObject:nil afterDelay:3.0];
  }
}

- (void)reconnect {
  [self disconnect];
  [self connect];
  [self performSelector:@selector(checkIfConnected) withObject:nil afterDelay:3.0];
}

# pragma mark Socket IO Delegate Methods

- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON {
  [[NSNotificationCenter defaultCenter] postNotificationName:JuggernautDidReceiveMessageNotification
                                                      object:message
                                                    userInfo:nil];  
  
}

- (void)socketIoClientDidConnect:(SocketIoClient *)client {
  [self onConnect];
}

- (void)socketIoClientDidDisconnect:(SocketIoClient *)client {
  [self onDisconnect];
}


@end
