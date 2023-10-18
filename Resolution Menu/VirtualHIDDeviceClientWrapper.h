//
//  VirtualHIDDeviceClientWrapper.h
//  VirtualHIDDeviceClient
//
//  Created by 殷瑞 on 2023/10/18.
//

#ifndef VirtualHIDDeviceClientWrapper_h
#define VirtualHIDDeviceClientWrapper_h

#import <Cocoa/Cocoa.h>
//#include "VirtualHIDDeviceClient.h"

@interface VirtualHIDDeviceClientWrapper : NSObject

- (instancetype) init;
- (void)dealloc;

- (void)start;
- (void)stop;

- (void) pressKey: (UInt8)key;
- (void) keyDown: (UInt8)key;
- (void) keyUp: (UInt8)key;
- (BOOL) isReady;

- (void)unlock;

@end

#endif /* VirtualHIDDeviceClientWrapper_h */
