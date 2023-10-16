//
//  AccessibilityChecker.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/16.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class AccessibilityChecker {
    static func checkAccessibilityPermission() -> Bool {
        return AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
    }
    
    // 同上，不同格式。
    func isAccessibilityEnabled() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}
