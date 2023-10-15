//
//  WindowManager.h
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/16.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <ApplicationServices/ApplicationServices.h>

@interface WindowManager : NSObject

+ (AXUIElementRef)getFrontmostWindow;
+ (void)setFrontmostWindowToMaximized;

@end
