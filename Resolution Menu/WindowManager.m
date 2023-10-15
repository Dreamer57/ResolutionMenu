//
//  WindowManager.m
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/16.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

#import "WindowManager.h"

@implementation WindowManager

+ (AXUIElementRef)getFrontmostWindow {
    NSRunningApplication *frontmostApp = [NSWorkspace.sharedWorkspace frontmostApplication];
    if (frontmostApp) {
        pid_t processID = frontmostApp.processIdentifier;
        AXUIElementRef appElement = AXUIElementCreateApplication(processID);

        CFTypeRef frontmostWindow;
        if (AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute, &frontmostWindow) == kAXErrorSuccess) {
            return (AXUIElementRef)frontmostWindow;
        }
    }
    return nil;
}

+ (void)setFrontmostWindowToMaximized {
    AXUIElementRef frontmostWindow = [self getFrontmostWindow];
    if (frontmostWindow) {
//        AXUIElementSetAttributeValue(frontmostWindow, kAXZoomButtonAttribute, kCFBooleanTrue); // 不可写
        NSRect screenSizeRect = [[NSScreen mainScreen] frame];
            int screenWidth = screenSizeRect.size.width;
            int screenHeight = screenSizeRect.size.height;

            NSPoint point = NSMakePoint((CGFloat) 0, (CGFloat) 0);
            NSSize size = NSMakeSize((CGFloat) screenWidth, (CGFloat) screenHeight);

            CFTypeRef positionStorage = (CFTypeRef)(AXValueCreate((AXValueType)kAXValueCGPointType, (const void *)&point));
            AXUIElementSetAttributeValue(frontmostWindow, kAXPositionAttribute, positionStorage);

            CFTypeRef sizeStorage = (CFTypeRef)(AXValueCreate((AXValueType)kAXValueCGSizeType, (const void *)&size));
            AXUIElementSetAttributeValue(frontmostWindow, kAXSizeAttribute, sizeStorage);
//        printf("width: %d, height: %d.", screenWidth, screenHeight);
    }
}

@end
