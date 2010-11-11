//
//  juggernaut-cocoa.m
//  juggernaut-cocoa
//
//  Created by Fred Potter on 11/11/10.
//  Copyright 2010 Fred Potter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JuggernautClient.h"

@interface JuggernautHandler : NSObject {
}
@end

@implementation JuggernautHandler

- (void)didConnect:(NSNotification *)notification {
  printf("Juggernaut Connected.\n");
}

- (void)didDisconnect:(NSNotification *)notification {
  printf("Juggernaut Disconnected.\n");
}

- (void)didReceiveMessage:(NSNotification *)notification {
  printf("Juggernaut recieved message:\n%s\n", 
         [[notification object] UTF8String]);
}

@end

int main (int argc, const char * argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  
  NSMutableArray *channels = [NSMutableArray array];
  
  NSString *host = nil;
  int port = 0;
  
  if (argc > 1) {
    host = [NSString stringWithUTF8String:argv[1]];
  }
  
  if (argc > 2) {
    port = [[NSString stringWithUTF8String:argv[2]] intValue];
  }

  for (int i = 3; i < argc; i++) {
    [channels addObject:[NSString stringWithUTF8String:argv[i]]];
  }
  
  if (host == nil || port == 0 || [channels count] == 0) {
    printf("usage: %s <host> <port> <channel> [channel2]\n", argv[0]);
    [pool drain];
    return -1;
  }
  
  printf("Subscribing to %s at %s:%d...\n", [[channels componentsJoinedByString:@", "] UTF8String], [host UTF8String], port);
  
  JuggernautHandler *handler = [[JuggernautHandler alloc] init];
  
  [[NSNotificationCenter defaultCenter] addObserver:handler
                                           selector:@selector(didConnect:)
                                               name:JuggernautDidConnectNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:handler
                                           selector:@selector(didDisconnect:)
                                               name:JuggernautDidDisconnectNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:handler
                                           selector:@selector(didReceiveMessage:)
                                               name:JuggernautDidReceiveMessageNotification
                                             object:nil];
  
  JuggernautClient *client = [[JuggernautClient alloc] initWithHost:host port:port];
  
  for (NSString *channel in channels) {
    [client subscribe:channel];
  }

  // Sleep forever
  NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
  while (YES) {
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
  }
    
  [pool drain];
  return 0;
}
