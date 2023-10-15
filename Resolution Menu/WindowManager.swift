////
////  WindowManager.swift
////  Resolution Menu
////
////  Created by 殷瑞 on 2023/10/15.
////  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
////
//
//import Foundation
//import Carbon
//import CoreGraphics
//import ApplicationServices
//
//class WindowManagerSwift : NSObject {
//    static func getFrontmostWindow() -> AXUIElement? {
//        if let frontmostApp = NSWorkspace.shared.frontmostApplication {
//            let processID = frontmostApp.processIdentifier
//            let appElement = AXUIElementCreateApplication(processID)
//
//            var frontmostWindow: AnyObject?
//            if AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &frontmostWindow) == .success {
//                return frontmostWindow as! AXUIElement
//            }
//        }
//        return nil
//    }
//
//    @objc
//    static func maximizeFrontmostWindow() {
//        
//        if let frontmostWindow = getFrontmostWindow() {
//                let screenSizeRect = NSScreen.main?.frame
//                let screenWidth = screenSizeRect?.size.width ?? 0
//                let screenHeight = screenSizeRect?.size.height ?? 0
//
//                let point = CGPoint(x: 0, y: 0)
//                let size = CGSize(width: screenWidth, height: screenHeight)
//
//            let positionStorage = AXValueCreate(.cgPoint, point.po)
//                let sizeStorage = AXValueCreate(.cgSize, size)
//
//                if let positionStorage = positionStorage {
//                    AXUIElementSetAttributeValue(frontmostWindow, kAXPositionAttribute as CFString, positionStorage)
//                }
//                if let sizeStorage = sizeStorage {
//                    AXUIElementSetAttributeValue(frontmostWindow, kAXSizeAttribute as CFString, sizeStorage)
//                }
//            }
//        
//        
////        if let frontmostWindow = getFrontmostWindow() {
////            // 设置窗口大小为最大化
////            setWindowProperty(window: frontmostWindow, property: kAXSizeAttribute as CFString, value: CGSize(width: NSScreen.main!.frame.width, height: NSScreen.main!.frame.height))
////        }
//        
////        // 新窗口大小
////
////
////        if let mainScreen = NSScreen.main {
////            let screenWidth = mainScreen.frame.width
////            let screenHeight = mainScreen.frame.height
////
////            let point = CGPoint(x: 0, y: 0)
////            let size = CGSize(width: screenWidth, height: screenHeight)
////
////            if let positionStorage = AXValue.from(point, type: .cgPointType),
////               let sizeStorage = AXValue.from(size, type: .cgSizeType)
////            {
////                AXUIElementSetAttributeValue(win, kAXPositionAttribute as CFString, positionStorage)
////                AXUIElementSetAttributeValue(win, kAXSizeAttribute as CFString, sizeStorage)
////            }
////        }
//        
//        
//        //            // 获取窗口的当前大小
//        //            var windowSize: CFTypeRef?
//        //            if AXUIElementCopyAttributeValue(frontmostWindow, kAXSizeAttribute as CFString, &windowSize) == .success {
//        //                let size = windowSize as! AXValue
//        //                var cgSize = CGSize.zero
//        //                AXValueGetValue(size, .cgSize, &cgSize)
//        //                print("窗口大小：\(cgSize)")
//        //
//        //            }
//        
//        
//    }
//    
//    private static func setWindowProperty(window: AXUIElement, property: CFString, value: Any) {
//        AXUIElementSetAttributeValue(window, property, value as CFTypeRef)
//    }
//}
