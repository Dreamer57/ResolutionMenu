//
//  DisplayPreferencesInvoke.h
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisplayPreferencesInvoke : NSObject

+ (void) res1;
+ (void) res2;
+ (void) res3;

+ (void) degree0;
+ (void) degree270;
+ (void) degree90;
+ (void) degree180;

+ (void)degree:(CGDirectDisplayID)display andDegree:(int)degree;

+ (void)res:(CGDirectDisplayID)display andMode:(int)mode;
@end





