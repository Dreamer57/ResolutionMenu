//
//  AppDelegate.m
//  Resolution Menu
//
//  Created by Robbert Klarenbeek on 23-12-13.
//  Copyright (c) 2013 Robbert Klarenbeek. All rights reserved.
//

#import "AppDelegate.h"
#import "DisplayModeMenuItem.h"
#import "DisplayDegreeMenuItem.h"
#import <IOKit/graphics/IOGraphicsLib.h>
#import "ResolutionMenu-Swift.h"
#include "DisplayPreferences/Headers/Bridging-Header.h"
#include "WindowManager.h"

static NSString *const kStatusMenuTemplateName = @"StatusMenuTemplate";

// 搞了差不多3小时，局部变量被释放，资源释放线程结束。
static KeyboardMonitor *keyMonitor;

//static KeyMonitor *keyMonitorEvent;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    // 不用了，没用。
    // 通知、观察者模式：
    // 通知的底层实现通常包括使用线程切换
    // 观察者模式通常在单线程环境中被使用
    // 如果只是简单的功能，而且涉及的线程切换非常频繁，那么主动线程切换可能会更高效，因为它可以更精确地控制线程的切换时机。然而，如果通知频率较低，或者需要在多个地方共享状态更新，观察者模式可能更为方便和有效。
    // 在这里添加监听通知的代码
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"Notification" object:nil];
        
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.menu = self.menu;
    _statusItem.image = [NSImage imageNamed:kStatusMenuTemplateName];
    _statusItem.highlightMode = YES;
    
//    keyMonitorEvent = [[KeyMonitor alloc] init];
//    [keyMonitorEvent start];
    
    
//    keyMonitor = [[KeyboardMonitor alloc] init];
//    [keyMonitor start];
    
//    // 创建一个 dispatch group
//    dispatch_group_t group = dispatch_group_create();
//
//    // 在 dispatch group 中异步执行任务
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @autoreleasepool {
    // 搞了差不多3小时，主要是keylogger变量被释放了。
             keyMonitor = [[KeyboardMonitor alloc] init];
//            [keylogger start]; // 启动 Keylogger
            [keyMonitor threadStart]; // 独立线程 Keylogger

            // 可以在这里执行其他后台任务或操作
//            [NSRunLoop currentRunLoop]; // 启动当前线程的运行循环，以保持线程活跃

//        }
//    });

//    // 在主线程或其他线程中等待 dispatch group 的完成
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"线程已经结束");
//    });



}

//- (void)handleNotification:(NSNotification *)notification {
//
////    printf("notification arrive");
//
//    NSDictionary *userInfo = notification.userInfo;
//    if (userInfo) {
//        // 处理通知携带的信息
//        if ([userInfo[@"type"] isEqual: @"alert"]) {
//            NSAlert *alert = [[NSAlert alloc] init];
//            [alert setMessageText: userInfo[@"info"]];
//            [alert addButtonWithTitle: @"好"];
//            [alert runModal];
//        }
//
//        else if ([userInfo[@"type"] isEqual: @"max"]) {
//            [WindowManager setFrontmostWindowToMaximized];
//
////            [WindowManagerSwift setFrontmostWindowToMaximized];
//        }
//    }
//
//
//}


//- (void)maximizeFrontmostWindow {
//    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
//    NSRunningApplication *frontmostApplication = [workspace frontmostApplication];
//
//    if (frontmostApplication) {
//        pid_t pid = [frontmostApplication processIdentifier];
//        AXUIElementRef appElement = AXUIElementCreateApplication(pid);
//
//        if (appElement) {
//            CFArrayRef windows;
//            if (AXUIElementCopyAttributeValues(appElement, kAXWindowsAttribute, 0, 100, &windows) == kAXErrorSuccess) {
//                for (CFIndex i = 0; i < CFArrayGetCount(windows); i++) {
//                    AXUIElementRef windowElement = CFArrayGetValueAtIndex(windows, i);
//                    // 这里你可以执行任何你想要的窗口操作
//                }
//
//                CFRelease(windows);
//            }
//
//            CFRelease(appElement);
//        }
//    }
//}



- (void)dealloc
{
    // Cleanup the system status bar menu, probably not strictly necessary at this point
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

- (IBAction)rotationNormal:(id)sender
{
    [DisplayPreferencesExecutable rotationDegree0];
}

- (IBAction)rotation270:(id)sender
{
    [DisplayPreferencesExecutable rotationDegree270];
}

- (IBAction)rotation90:(id)sender
{
    [DisplayPreferencesExecutable rotationDegree90];
}

- (IBAction)openDisplayPreferences:(id)sender
{
    [[NSWorkspace sharedWorkspace] openFile:@"/System/Library/PreferencePanes/Displays.prefPane"];
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
//    bool degreeInited = false;
    int i = 0;
    // First, clear the previous items
    for (NSMenuItem *menuItem in menu.itemArray) {
        if ([menuItem hasSubmenu] || [menuItem isKindOfClass:[DisplayModeMenuItem class]]) {
            // Remove all DisplayModeMenuItems and submenus above the first separator
            // DisplayModeMenuItem 是动态添加的
            // 只清除 DisplayModeMenuItem，不会清除固定的 MenuItem。
            [menu removeItem:menuItem];
        } else if ([menuItem isKindOfClass:[DisplayDegreeMenuItem class]]) {
//            degreeInited = true;
            [menu removeItem:menuItem];
        } else if ([menuItem isSeparatorItem]) {
            // Break at the first separator; this way submenu's below the separator stay intact
            // 遇到第二条分隔线 break
            i ++;
//            if (i == 2) break;
        }
    }
    
    // Loop through all displays (max 16)
    uint32_t numberOfDisplays;
    CGDirectDisplayID displays[16];
    CGGetOnlineDisplayList(sizeof(displays) / sizeof(displays[0]), displays, &numberOfDisplays);
    for (int i = 0; i < numberOfDisplays; i++) {
        CGDirectDisplayID display = displays[i];
        
        // The menu to add the display modes to, by default directly into the main menu
        NSMenu *containerMenu = menu;
        
        // However, if we have multiple displays, put each list of display modes into its own submenu
        if (numberOfDisplays > 1) {
            NSMenu *subMenu = [NSMenu new];
            NSMenuItem *subMenuItem = [NSMenuItem new];
            
            // Use IOKit to get the (localized) device name
            NSDictionary *deviceInfo = (__bridge NSDictionary *)IODisplayCreateInfoDictionary(CGDisplayIOServicePort(display), kIODisplayOnlyPreferredName);
            NSDictionary *localizedNames = [deviceInfo objectForKey:[NSString stringWithUTF8String:kDisplayProductName]];
            subMenuItem.title = [localizedNames objectForKey:[[localizedNames allKeys] objectAtIndex:0]];
            
            subMenuItem.submenu = subMenu;
            [containerMenu insertItem:subMenuItem atIndex:i];
            containerMenu = subMenu;
        }
        
        //        if (!degreeInited) {
                    NSArray *degreeItems = [DisplayDegreeMenuItem getMenuItemsForDisplay:displays[i]];
                    for (NSMenuItem *menuItem in degreeItems) {
                        // Add to the top of the menu, in reverse order (highest resolution first)
                        [containerMenu insertItem:menuItem atIndex:0];
                    }
        //        }
        
        // Add the display modes to the container menu (either the main menu or a display submenu)
        NSArray *menuItems = [DisplayModeMenuItem getMenuItemsForDisplay:displays[i]];
        for (NSMenuItem *menuItem in menuItems) {
            // Add to the top of the menu, in reverse order (highest resolution first)
            [containerMenu insertItem:menuItem atIndex:5];
        }
        

    }
}

@end
