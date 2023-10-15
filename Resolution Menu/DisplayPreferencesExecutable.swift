//
//  DisplayPreferencesExecutable.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class DisplayPreferencesExecutable : NSObject {
    
    static var executableURL = URL(fileURLWithPath: "/Users/yinrui/Documents/code/swift/github/displayplacer/src/displayplacer")
    
    
    static func resMode3() {
        resCommand(1, 3)
    }
    
    static func resMode6() {
        resCommand(1, 6)
    }
    
    static func resMode8() {
        resCommand(1, 8)
    }
    
    @objc
    static func rotationDegree0 () {
        degreeCommand(1, 0)
    }
    
    @objc
    static func rotationDegree270 () {
        degreeCommand(1, 270)
    }
    
    @objc
    static func rotationDegree90 () {
        degreeCommand(1, 90)
    }
    
    static func degreeCommand(_ id:Int, _ degree: Int) {
        let arguments = ["id:\(id) degree:\(degree)"]
        run(arguments)
    }
    
    static func resCommand(_ id: Int, _ mode: Int) {
        let arguments = ["id:\(id) mode:\(mode)"]
        run(arguments)
    }
    
    static func run(_ arguments: [String]) {
        
        let result = ExecutableRunner.run(executableURL: executableURL, arguments: arguments)

        if result.success {
//            print("Output: \(result.output)")
        } else {
            print("Error: \(result.error)")
        }

    }
}
