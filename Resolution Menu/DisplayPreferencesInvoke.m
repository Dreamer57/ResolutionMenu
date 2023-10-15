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




@implementation DisplayPreferencesInvoke

+ (void)degree:(CGDirectDisplayID)display andDegree:(int)degree {
    // 一定要异步调用，同步调用的问题是，一边转，一边取degree，取不到及时的。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 构建动态生成的字符串
        char dynamicString[100];
        sprintf(dynamicString, "id:%d degree:%d", display, degree);
        
        // 初始化包含默认值和动态字符串的char*数组
        char* argv[] = {"", dynamicString};
        
        displayPreferences(2, argv);
    });
}

+ (void)res:(CGDirectDisplayID)display andMode:(int)mode {
    // 一定要异步调用，同步调用的问题是，一边转，一边取degree，取不到及时的。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 构建动态生成的字符串
        char dynamicString[100];
        sprintf(dynamicString, "id:%d mode:%d", display, mode);
        
        // 初始化包含默认值和动态字符串的char*数组
        char* argv[] = {"", dynamicString};
        
        displayPreferences(2, argv);
    });
}


@end

