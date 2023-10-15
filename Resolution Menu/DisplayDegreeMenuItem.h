//
//  DisplayDegreeMenuItem.h
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisplayDegreeMenuItem : NSMenuItem

+ (NSArray *)getMenuItemsForDisplay:(CGDirectDisplayID)display;

@end
