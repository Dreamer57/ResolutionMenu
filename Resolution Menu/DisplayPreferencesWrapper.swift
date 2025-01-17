//
//  DisplayPreferencesWrapper.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

// async，在主线程上用
class DisplayPreferencesWrapper : NSObject {
    
    @objc
    static func rotationDegree0(_ displayId: CGDirectDisplayID) {
        rotationDegree(displayId, 0)
    }
    
    @objc
    static func rotationDegree270(_ displayId: CGDirectDisplayID) {
        rotationDegree(displayId, 270)
    }
    
    @objc
    static func rotationDegree90(_ displayId: CGDirectDisplayID) {
        rotationDegree(displayId, 90)
    }
    
    @objc
    static func rotationDegree180(_ displayId: CGDirectDisplayID) {
        rotationDegree(displayId, 180)
    }
    
    @objc
    static func rotationDegree(_ displayId: CGDirectDisplayID, _ degree: Int) {
        let cmd = "id:\(displayId) degree:\(degree)"
        preferences(cmd)
    }
    
    @objc
    static func resMode3(_ displayId: CGDirectDisplayID) {
        resMode(displayId, 3)
    }
    
    @objc
    static func resMode6(_ displayId: CGDirectDisplayID) {
        resMode(displayId, 6)
    }
    
    @objc
    static func resMode8(_ displayId: CGDirectDisplayID) {
        resMode(displayId, 8)
    }
    
    @objc
    static func resMode(_ displayId: CGDirectDisplayID, _ mode: Int) {
        let cmd = "id:\(displayId) mode:\(mode)"
        preferences(cmd)
    }
    
    static func preferences(_ cmd: String) {
        
        // 构建动态生成的字符串
        //        let cmd = "id:\(display) degree:\(degree)"
        
        // 初始化包含默认值和动态字符串的字符串数组
        // let argv = ["DisplayPlacer", cmd]
        let argv = ["", cmd]
        
        // 创建 C 风格的字符串数组
        var cArgs = argv.map { strdup($0) }
        cArgs.append(nil) // 在最后添加一个 nil 以表示结束
        
        // global .default async 与 sync 区别：
        // async 切换线程执行，sync 不会切换线程
        // 这里是通过 UI 点击触发，所以是主线程
        // 这里一定要切换线程，用另一个线程去做，不然会和 UI 抢资源
        // 导致 CGDisplayRotation(screenId) 获取不到旋转后的新值
        // 根本原因是，屏幕旋转后，重置分辨率后，屏幕上的App需要重新排列，UI 需要适应或渲染，这个时候一定不能用主线程，不然就是互相争夺
//        DispatchQueue.global(qos: .default).async {
        // 这个也是同步不切换线程，看样子猜测，这应该只会有一个线程，才能保证顺序
        // 好了，到此为止了。
        DispatchQueue(label: "com.yr.display.serial").async {
            // 调用 C 函数 displayPreferences
            displayPreferences(Int32(cArgs.count - 1), &cArgs)
            
            // 释放分配的内存
            for arg in cArgs {
                if arg != nil {
                    free(arg)
                }
            }
        }
    }
}
