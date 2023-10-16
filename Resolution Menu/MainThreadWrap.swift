//
//  MainThreadWrap.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/17.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class MainThreadWrap {
    static func showAlert(_ message: String){
        // 用 async 异步，async 与 sync 影响的是当前线程，而不是主线程。
        // main 切换主线程。
        DispatchQueue.main.async {
            // 使用示例。不是主线程弹不出来。
            alert(message: message)
        }
        
    }
    
    // completionHandler 没用上，留下这种写法供后参考。
    private static func alert(message: String, completionHandler: (() -> Void)? = nil) {
        let alert = NSAlert()
        alert.messageText = message
        alert.addButton(withTitle: "好")
        alert.alertStyle = .informational
        
        alert.runModal()
    }
}
