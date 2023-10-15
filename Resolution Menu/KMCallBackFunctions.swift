//
//  CallBackFunctions.swift
//  Keylogger
//
//  Created by Skrew Everything on 16/01/17.
//  Copyright © 2017 Skrew Everything. All rights reserved.
//

import Foundation
import Cocoa
//import ResolutionMenu

class KMCallBackFunctions: NSObject
{
    static var CAPSLOCK = false
//    static var calander = Calendar.current
    static var prev = ""
    
    static var ctrl = false
    static var cmd = false
    static var opt = false
    static var shift = false
    
//    static let lock = NSLock()
//    static var isRunning = false
    
    static let Handle_DeviceMatchingCallback: IOHIDDeviceCallback = { context, result, sender, device in
        
        let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()

        
        let product = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString) as! String

        print(product)
        
//        if (product == "IQUNIX-AVER80-BT1") {
//            let inputReportSize = 64
//            var inputBuffer = [UInt8](repeating: 0, count: inputReportSize)
//            IOHIDDeviceRegisterInputReportCallback(device, &inputBuffer, inputReportSize, Handle_IOHIDInputReportCallback, context)
//            print("RegisterInputReport")
//        }
        
    }
    
    static let Handle_DeviceRemovalCallback: IOHIDDeviceCallback = { context, result, sender, device in
        
            
            let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()

        
        print("Disconnected: " + "\t\(device)")
    }
     
    static let Handle_IOHIDInputValueCallback: IOHIDValueCallback = { context, result, sender, device in
        
        let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()
        let elem: IOHIDElement = IOHIDValueGetElement(device );
        var test: Bool
        if (IOHIDElementGetUsagePage(elem) != 0x07)
        {
            return
        }
        let scancode = IOHIDElementGetUsage(elem);
        if (scancode < 4 || scancode > 231)
        {
            return
        }
//        print(scancode)
        let pressed = IOHIDValueGetIntegerValue(device );
        let isKeyDown = (pressed == 1)
//        print(pressed)
        

        
        if (scancode == 224) {
            KMCallBackFunctions.ctrl = isKeyDown
        } else if (scancode == 225) {
            KMCallBackFunctions.shift = isKeyDown
        } else if (scancode == 226) {
            KMCallBackFunctions.opt = isKeyDown
        } else if (scancode == 227) {
            KMCallBackFunctions.cmd = isKeyDown
        }
        // right
        else if (scancode == 229) {
            KMCallBackFunctions.shift = isKeyDown
        } else if (scancode == 230) {
            KMCallBackFunctions.opt = isKeyDown
        } else if (scancode == 231) {
            KMCallBackFunctions.cmd = isKeyDown
        }
        
        print("scancode:\t\(scancode)\t"
            + "pressed:\t\(pressed)\t"
            + "appName:\t\(mySelf.appName)\t")
        
Outside:if pressed == 1
        {

            if scancode == 57
            {
                KMCallBackFunctions.CAPSLOCK = !KMCallBackFunctions.CAPSLOCK
                break Outside
            }
            if scancode >= 224 && scancode <= 231
            {
//                fh?.write( (mySelf.keyMap[scancode]![0] + "(").data(using: .utf8)!)
                break Outside
            }
            if KMCallBackFunctions.CAPSLOCK
            {
//                fh?.write(mySelf.keyMap[scancode]![1].data(using: .utf8)!)
            }
//            else
//    {
//                print("scancode: " + "\t\(scancode)" + "\t"
//                      + "appName: " + "\t\(mySelf.appName)")
                
                if (mySelf.keyMap[scancode]![0] == "1"
                    && ctrl && cmd) {
                    DisplayPreferencesInvoke.res(1, andMode: 3)
//                    DisplayPreferencesExecutable.resMode3()
                } else if (mySelf.keyMap[scancode]![0] == "2"
                           && ctrl && cmd) {
                    DisplayPreferencesInvoke.res(1, andMode: 6)
//                    DisplayPreferencesExecutable.resMode6()
                } else if (mySelf.keyMap[scancode]![0] == "3"
                           && ctrl && cmd) {
                    DisplayPreferencesInvoke.res(1, andMode: 8)
//                    DisplayPreferencesExecutable.resMode8()
                } else if (mySelf.keyMap[scancode]![0] == "4"
                           && ctrl && cmd) {
//                    print("Control + Command + 4 被按下")
                    rotateCurrentDisplay(0)
//                    DisplayPreferencesInvoke.degree(1, andDegree: 0)
//                    DisplayPreferencesExecutable.rotationDegree0()
                } else if (mySelf.keyMap[scancode]![0] == "5"
                           && ctrl && cmd) {
                    rotateCurrentDisplay(270)
//                    DisplayPreferencesInvoke.degree(1, andDegree: 270)
//                    DisplayPreferencesExecutable.rotationDegree270()
                } else if (mySelf.keyMap[scancode]![0] == "6"
                           && ctrl && cmd) {
                    rotateCurrentDisplay(90)
//                    DisplayPreferencesInvoke.degree(1, andDegree: 90)
//                    DisplayPreferencesExecutable.rotationDegree90()
                } else if (mySelf.keyMap[scancode]![0] == "7"
                           && ctrl && cmd) {
                    rotateCurrentDisplay(180)
//                    DisplayPreferencesInvoke.degree(1, andDegree: 180)
                }
                
                // 都没啥用，不解决问题。
//                lock.lock()
                //!isRunning &&
//                print("appName" + mySelf.appName)
                if (mySelf.appName == "OpenEmu") {
//                    isRunning = true
                    
                    
                    
                    
//                    lock.unlock()
                    
//                    isRunning = false
                }
                
//                fh?.write(mySelf.keyMap[scancode]![0].data(using: .utf8)!)
//            }
        }
        else
        {
            if scancode >= 224 && scancode <= 231
            {
//                fh?.write(")".data(using: .utf8)!)
            }
        }
    }
    
    
    
    
//    static let Handle_IOHIDInputReportCallback: IOHIDReportCallback = { context, result, sender, type, reportID, report, reportLength in
//
//
//
//        let reportData = Data(bytes: report, count: reportLength)
//        let reportStringArray = reportData.map { String($0) }
//        let reportString = reportStringArray.joined(separator: ",")
////        if let reportString = String(data: reportData, encoding: .ascii) {
//            print("reportID: " +  "\t\(reportID)" + "\t"
//                  + "report: " + reportString + "\t"
//                  + "reportLength: " +  "\t\(reportLength)" + "\t"
//                  + "result: " + "\t\(result)" + "\t"
//                  + "pointer: " + "\t\(report)" + "\t"
//                  + "pointee: " + "\t\(report.pointee)" + "\t"
//                  + "sender: " + "\t\(String(describing: sender))" + "\t"
//            )
////        }
//
//
//    }
    

}
