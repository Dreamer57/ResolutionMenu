//
//  ShellCommand.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/13.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

import Foundation

class ShellCommandRunner {
    static func runCommand(_ command: String) -> (output: String?, error: String?, exitCode: Int32) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        task.standardOutput = outputPipe
        task.standardError = errorPipe

        task.launch()
        task.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        let output = String(data: outputData, encoding: .utf8)
        let error = String(data: errorData, encoding: .utf8)

        return (output, error, task.terminationStatus)
    }
}
