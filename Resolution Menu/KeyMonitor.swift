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
        
//        DispatchQueue.global(qos: .default).async {
            
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
