//
//  NotificationWrap.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/16.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class NotificationWrap : NSObject {
    
    static func sendAlert(_ info: String){
        send("alert", info: info)
    }
    
    static func sendMax(){
        send("max")
    }
    
    static func send(_ type: String, info: String = ""){
        // 在需要发送通知的地方
        let userInfo: [AnyHashable: Any] = ["type": type, "info": info] // 通知携带的信息
        let notification = Notification(name: Notification.Name("Notification"), object: nil, userInfo: userInfo)

        // 发送通知
        NotificationCenter.default.post(notification)
    }
}
