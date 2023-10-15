//
//  ExecutableRunner.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class ExecutableRunner {
    let executableURL: URL
    let arguments: [String]

    init(executableURL: URL, arguments: [String]) {
        self.executableURL = executableURL
        self.arguments = arguments
    }

    func run() -> (output: String, error: String, success: Bool) {
        let task = Process()
        task.executableURL = executableURL
        task.arguments = arguments

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        task.standardOutput = outputPipe
        task.standardError = errorPipe

        do {
            try task.run()
            task.waitUntilExit()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

            let success = task.terminationStatus == 0
            if let output = String(data: outputData, encoding: .utf8), let error = String(data: errorData, encoding: .utf8) {
                return (output, error, success)
            }
        } catch {
            return ("", "Error: \(error)", false)
        }

        return ("", "", false)
    }
    
    static func run(executableURL: URL, arguments: [String]) -> (output: String, error: String, success: Bool) {
            let task = Process()
            task.executableURL = executableURL
            task.arguments = arguments

            let outputPipe = Pipe()
            let errorPipe = Pipe()

            task.standardOutput = outputPipe
            task.standardError = errorPipe

            do {
                try task.run()
                task.waitUntilExit()

                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

                let success = task.terminationStatus == 0
                if let output = String(data: outputData, encoding: .utf8), let error = String(data: errorData, encoding: .utf8) {
                    return (output, error, success)
                }
            } catch {
                return ("", "Error: \(error)", false)
            }

            return ("", "", false)
        }
}
