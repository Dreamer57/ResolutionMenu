//
//  MonitorShell.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/13.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class DisplayPreferencesShell : NSObject {
    
    static var commandTools = "/Users/yinrui/Documents/code/swift/github/displayplacer/src/displayplacer 'id:1"
    
    
    static func resMode3() {
        resCommand(3)
    }
    
    static func resMode6() {
        resCommand(6)
    }
    
    static func resMode8() {
        resCommand(8)
    }
    
    @objc
    static func rotationDegree0 () {
        degreeCommand(0)
    }
    
    @objc
    static func rotationDegree270 () {
        degreeCommand(270)
    }
    
    @objc
    static func rotationDegree90 () {
        degreeCommand(90)
    }
    
    static func degreeCommand(_ degree: Int) {
        let command = "\(commandTools) degree:\(degree)'"
        
        run(command)
    }
    
    static func resCommand(_ mode: Int) {
        let command = "\(commandTools) mode:\(mode)'"
        
        run(command)
    }
    
    static func run(_ command: String) {
        
        let result = ShellCommandRunner.runCommand(command)

        if result.exitCode == 0 {
//            print("Shell Output: \(result.output ?? "")")
        } else {
            print("Error: \(result.error ?? "")")
        }
    }
}
