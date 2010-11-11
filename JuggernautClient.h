//
//  JuggernautClient.h
//  juggernaut-cocoa
//
//  Created by Fred Potter on 11/11/10.
//  Copyright 2010 Fred Potter. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *JuggernautDidReceiveMessageNotification;
extern NSString *JuggernautDidDisconnectNotification;
extern NSString *JuggernautDidConnectNotification;

@class SocketIoClient;

@interface JuggernautClient : NSObject {
  SocketIoClient *_socketIoClient;
  int _state;
  
  NSMutableArray *_queue;
  
  BOOL _shouldReconnect;
}

@property (nonatomic, assign) BOOL shouldReconnect;

- (id)initWithHost:(NSString *)host port:(int)port;

- (void)subscribe:(NSString *)channel;
- (void)unsubscribe:(NSString *)channel;

- (void)disconnect;

@end
