//
//  WindowManager.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/15.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation
//import Carbon
import CoreGraphics
import ApplicationServices

class WindowManagerSwift : NSObject {
    static func getFrontmostWindow() -> AXUIElement? {
        if let frontmostApp = NSWorkspace.shared.frontmostApplication {
            let processID = frontmostApp.processIdentifier
            let appElement = AXUIElementCreateApplication(processID)

            var frontmostWindow: AnyObject?
            if AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &frontmostWindow) == .success {
                return frontmostWindow as! AXUIElement
            }
        }
        return nil
    }

    @objc
    static func setFrontmostWindowToMaximized() {
        if let frontmostWindow = getFrontmostWindow() {
            
            // 先设位置
            setWindowAttribute(window: frontmostWindow, attribute: kAXPositionAttribute, value: CGPoint(x: 0, y: 0))
            
            // 设置窗口大小为最大化
            setWindowAttribute(window: frontmostWindow, attribute: kAXSizeAttribute, value: CGSize(width: NSScreen.main!.frame.width, height: NSScreen.main!.frame.height))
        }
    }
    
    @objc
    static func maximizeFrontmostWindow() {
        
        if let frontmostWindow = getFrontmostWindow() {
            let screenSizeRect = NSScreen.main?.frame
            let screenWidth = screenSizeRect?.size.width ?? 0
            let screenHeight = screenSizeRect?.size.height ?? 0
            
            var point = CGPoint(x: 0, y: 0)
            var size = CGSize(width: screenWidth, height: screenHeight)
            
            let positionStorage = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!, &point) // 后面没 !
            let sizeStorage = AXValueCreate(.cgSize, &size)! // 后面有 !
            
            
            AXUIElementSetAttributeValue(frontmostWindow, kAXPositionAttribute as CFString, positionStorage as CFTypeRef) // as
            
            
            AXUIElementSetAttributeValue(frontmostWindow, kAXSizeAttribute as CFString, sizeStorage) // !
            
        }
        
        
        
        
        
        
        
        
        
//        // 新窗口大小
//
//
//        if let mainScreen = NSScreen.main {
//            let screenWidth = mainScreen.frame.width
//            let screenHeight = mainScreen.frame.height
//
//            let point = CGPoint(x: 0, y: 0)
//            let size = CGSize(width: screenWidth, height: screenHeight)
//
//            if let positionStorage = AXValue.from(point, type: .cgPointType),
//               let sizeStorage = AXValue.from(size, type: .cgSizeType)
//            {
//                AXUIElementSetAttributeValue(win, kAXPositionAttribute as CFString, positionStorage)
//                AXUIElementSetAttributeValue(win, kAXSizeAttribute as CFString, sizeStorage)
//            }
//        }
        
        
        //            // 获取窗口的当前大小
        //            var windowSize: CFTypeRef?
        //            if AXUIElementCopyAttributeValue(frontmostWindow, kAXSizeAttribute as CFString, &windowSize) == .success {
        //                let size = windowSize as! AXValue
        //                var cgSize = CGSize.zero
        //                AXValueGetValue(size, .cgSize, &cgSize)
        //                print("窗口大小：\(cgSize)")
        //
        //            }
        
        
    }
    
//    // 不行
//    private static func setWindowProperty(window: AXUIElement, property: CFString, value: Any) {
//        AXUIElementSetAttributeValue(window, property, value as CFTypeRef)
//    }
    
    private static func setWindowAttribute(window: AXUIElement, attribute: String, value: Any) {
           let error = AXUIElementSetAttributeValue(window, attribute as CFString, packAXValue(value))

//           guard error == .success else {
//               throw error
//           }
       }

    
    
    // Checks if the value is one supported by AXValue and if so, wraps it.
       // If the value is a UIElement, unwraps it to an AXUIElement.
    static fileprivate func packAXValue(_ value: Any) -> AnyObject {
           switch value {
//           case let val as UIElement:
//               return val.element
           case var val as CFRange:
               return AXValueCreate(AXValueType(rawValue: kAXValueCFRangeType)!, &val)!
           case var val as CGPoint:
               return AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!, &val)!
           case var val as CGRect:
               return AXValueCreate(AXValueType(rawValue: kAXValueCGRectType)!, &val)!
           case var val as CGSize:
               return AXValueCreate(AXValueType(rawValue: kAXValueCGSizeType)!, &val)!
           default:
               return value as AnyObject // must be an object to pass to AX
           }
       }

    
    
//
//    /// Sets the value of `attribute` to `value`.
//       ///
//       /// - warning: Unlike read-only methods, this method throws if the attribute doesn't exist.
//       ///
//       /// - throws:
//       ///   - `Error.AttributeUnsupported`: `attribute` isn't supported.
//       ///   - `Error.IllegalArgument`: `value` is an illegal value.
//       ///   - `Error.Failure`: A temporary failure occurred.
//       open func setAttribute(_ attribute: Attribute, value: Any) throws {
//           try setAttribute(attribute.rawValue, value: value)
//       }
//
//       open func setAttribute(_ attribute: String, value: Any) throws {
//           let error = AXUIElementSetAttributeValue(element, attribute as CFString, packAXValue(value))
//
//           guard error == .success else {
//               throw error
//           }
//       }
}
