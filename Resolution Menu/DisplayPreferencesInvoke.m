//
//  DisplayPreferencesInvoke.m
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayPreferencesInvoke.h"
#import "Header.h"

// sync，不在主线程上用
@implementation DisplayPreferencesInvoke

+ (void)res1 {
    [self res:1 andMode:3];
}
+ (void)res2 {
    [self res:1 andMode:6];
}
+ (void)res3 {
    [self res:1 andMode:8];
}

+ (void)degree0 {
    [self degree:1 andDegree:0];
}
+ (void)degree270 {
    [self degree:1 andDegree:270];
}
+ (void)degree90 {
    [self degree:1 andDegree:90];
}
+ (void)degree180 {
    [self degree:1 andDegree:180];
}


+ (void)degree:(CGDirectDisplayID)display andDegree:(int)degree {
    // 构建动态生成的字符串
    char dynamicString[100];
    sprintf(dynamicString, "id:%d degree:%d", display, degree);
    
    [self preferences:display andCmd:dynamicString];
}

+ (void)res:(CGDirectDisplayID)display andMode:(int)mode {
    // 构建动态生成的字符串
    char dynamicString[100];
    sprintf(dynamicString, "id:%d mode:%d", display, mode);
    
    [self preferences:display andCmd:dynamicString];
}

+ (void)preferences:(CGDirectDisplayID)display andCmd:(char[])cmd {
    // sync 不在主线程上
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    dispatch_queue_t myQueue = dispatch_queue_create("com.yr.display.serial", DISPATCH_QUEUE_SERIAL);
    // 不切换线程也不会有问题，但保持统一。
    // 算了，线程切换开销大。
//    dispatch_async(dispatch_queue_create("com.yr.display.serial", DISPATCH_QUEUE_SERIAL), ^{
        // 初始化包含默认值和动态字符串的char*数组
        char* argv[] = {"", cmd};
        
        displayPreferences(2, argv);
//    });
}


@end

