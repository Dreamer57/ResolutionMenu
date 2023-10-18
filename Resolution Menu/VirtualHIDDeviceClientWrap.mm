//
//  VirtualHIDDeviceClientWrap.m
//  VirtualHIDDeviceClient
//
//  Created by 殷瑞 on 2023/10/18.
//

#import <Foundation/Foundation.h>
#include "VirtualHIDDeviceClientWrapper.h"
#include "VirtualHIDDeviceClient.h"

@implementation VirtualHIDDeviceClientWrapper

VirtualHIDDeviceClient *client1;

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.client = new VirtualHIDDeviceClient();
        client1 = new VirtualHIDDeviceClient();
    }
    
    return self;
}

- (void)dealloc {
    delete client1;
}

- (void)start {
    client1->start();
}

- (void)stop {
    client1->stop();
}

- (void) pressKey:(UInt8)key {
    client1->pressKey(key);
}

- (void)keyDown:(UInt8)key {
    client1->keyDown(key);
}

- (void)keyUp {
    client1->keyUp();
}

-(BOOL)isReady {
    return client1->isReady();
}


- (void)unlock {
    client1->unlock();
}

@end
