//
//  KeyboardMonitor.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/13.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Cocoa

// 没用，系统按键会和软件冲突。
class KeyMonitor: NSObject {
    private var monitor: Any?
    
    override init() {
        super.init()
        
    }
    
    deinit {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    @objc
    func start() {
        
        
        
        
        if AccessibilityChecker.checkAccessibilityPermission() {
            print("辅助功能权限已启用。")
        } else {
            print("辅助功能权限未启用。")
        }
        
        
        
        
        
        
        //        DispatchQueue.global(qos: .default).async {
        // 会重复触发，比如一直按着a，会一直触发keyDown，keyCode 0。
        // shortcuts 的问题是，只能在mask键后加一个正常键，如：ctrl+cmd+a、cmd+opt+a
        // 实现不了多个正常键，如：ctrl+cmd+a+b。
        // 总之，就用我自己的 IOKit HID 方式。
        self.monitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.keyDown, .flagsChanged],
            handler: { (event) in
                print(event.keyCode)
                if event.keyCode == 21 && event.modifierFlags.contains(.control) && event.modifierFlags.contains(.command) {
                    self.handleKeyPress()
                }
            }
        )
        
        //            // 在这里执行其他后台任务
        //
        //            // 最后，在后台线程中，确保运行 run loop，以便监听 HID 事件
        //            CFRunLoopRun()
        //
        //        }
        
        
    }
    
    func handleKeyPress() {
        // 在这里执行你希望执行的代码
        print("Control + Command + 4 被按下")
    }
    
    
    
}
