//
//  KeyLogger.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/15.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class KeyRecorder {
    private var pressedKeys: Set<String> = Set()

    func pressKey(_ key: String) {
        pressedKeys.insert(key)
        // 进行按下键的其他操作
    }

    func releaseKey(_ key: String) {
        pressedKeys.remove(key)
        // 进行释放键的其他操作
    }

    func isKeyPressed(_ key: String) -> Bool {
        return pressedKeys.contains(key)
    }

    func totalPressedKeys() -> Int {
        return pressedKeys.count
    }
    
    // debug
    func printPressedKeys() {
        let keys = pressedKeys.joined(separator: " + ")
        print("pressed \(totalPressedKeys()) key:\t\(keys)")
    }
}
