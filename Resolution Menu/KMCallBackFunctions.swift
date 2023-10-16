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
//    static var CAPSLOCK = false
//    static var calander = Calendar.current
//    static var prev = ""
    
    
    static var keyRecorder = KeyRecorder()
    
    static var ctrl = false
    static var cmd = false
    static var opt = false
    static var shift = false
    
//    static let lock = NSLock()
//    static var isRunning = false
    
    static let Handle_DeviceMatchingCallback: IOHIDDeviceCallback = { context, result, sender, device in
        
//        let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()

        
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
        
            
//            let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()

        
        print("Disconnected: " + "\t\(device)")
    }
     
    static let Handle_IOHIDInputValueCallback: IOHIDValueCallback = { context, result, sender, device in
        
//        let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()
        let elem: IOHIDElement = IOHIDValueGetElement(device );
        
        if (IOHIDElementGetUsagePage(elem) != 0x07)
        {
            return
        }
        let scancode = IOHIDElementGetUsage(elem);
        if (scancode < 4 || scancode > 231)
        {
            return
        }
        
        let pressed = IOHIDValueGetIntegerValue(device );
        let isKeyDown = (pressed == 1)
        
        
        let key = KeyboardMonitor.keyMap[UInt8(scancode)]![0]
        
        if (isKeyDown) {
            keyRecorder.pressKey(key)
        } else {
            keyRecorder.releaseKey(key)
        }
        
        if (scancode == 224) {
            ctrl = isKeyDown
        } else if (scancode == 225) {
            shift = isKeyDown
        } else if (scancode == 226) {
            opt = isKeyDown
        } else if (scancode == 227) {
            cmd = isKeyDown
        }
        // right
        else if (scancode == 229) {
            KMCallBackFunctions.shift = isKeyDown
        } else if (scancode == 230) {
            KMCallBackFunctions.opt = isKeyDown
        } else if (scancode == 231) {
            KMCallBackFunctions.cmd = isKeyDown
        }
        
        let noFlags = !ctrl && !shift && !opt && !cmd
        
        // dr57 debug print
        //        print("scancode:\t\(scancode)\t"
        //            + "pressed:\t\(pressed)\t"
        //            + "appName:\t\(mySelf.appName)\t")
        //        // printPressedKeys
//                keyRecorder.printPressedKeys()
        
        // keyDown 事件
        if isKeyDown
        {
            // -----***** hot key area  begin *****-----
            
            if (ctrl && cmd && keyRecorder.totalPressedKeys() == 3
                && !opt && !shift) { // ctrl + cmd   begin
                if (key == "1") {
                    DisplayPreferencesInvoke.res1()
                    //                    DisplayPreferencesExecutable.resMode3()
                } else if (key == "2") {
                    DisplayPreferencesInvoke.res2()
                    //                    DisplayPreferencesExecutable.resMode6()
                } else if (key == "3") {
                    DisplayPreferencesInvoke.res3()
                    //                    DisplayPreferencesExecutable.resMode8()
                } else if (key == "4") {
                    //                    print("Control + Command + 4 被按下")
                    //            rotateCurrentDisplay(0)
                    DisplayPreferencesInvoke.degree0()
                    //                    DisplayPreferencesExecutable.rotationDegree0()
                } else if (key == "5") {
                    //            rotateCurrentDisplay(270)
                    DisplayPreferencesInvoke.degree270()
                    //                    DisplayPreferencesExecutable.rotationDegree270()
                } else if (key == "6") {
                    //            rotateCurrentDisplay(90)
                    DisplayPreferencesInvoke.degree90()
                    //                    DisplayPreferencesExecutable.rotationDegree90()
                } else if (key == "7") {
                    //            rotateCurrentDisplay(180)
                    DisplayPreferencesInvoke.degree180()
                }
            } // ctrl + cmd   end
            else if (ctrl && cmd && opt && keyRecorder.totalPressedKeys() == 4
                     && !shift) { // ctrl + cmd + opt     begin
                if (key == "4") {
                    //                    print("Control + Command + 4 被按下")
                    rotateCurrentDisplay(0)
                    //                    DisplayPreferencesInvoke.degree(1, andDegree: 0)
                    //                    DisplayPreferencesExecutable.rotationDegree0()
                } else if (key == "5") {
                    rotateCurrentDisplay(270)
                    //                    DisplayPreferencesInvoke.degree(1, andDegree: 270)
                    //                    DisplayPreferencesExecutable.rotationDegree270()
                } else if (key == "6") {
                    rotateCurrentDisplay(90)
                    //                    DisplayPreferencesInvoke.degree(1, andDegree: 90)
                    //                    DisplayPreferencesExecutable.rotationDegree90()
                } else if (key == "7") {
                    rotateCurrentDisplay(180)
                    //                    DisplayPreferencesInvoke.degree(1, andDegree: 180)
                }
                
            } // ctrl + cmd + opt     end
            else if (ctrl && cmd && keyRecorder.totalPressedKeys() == 4) {
                if (keyRecorder.isKeyPressed("LEFTARROW")
                    && keyRecorder.isKeyPressed("RIGHTARROW")) {
                    //            print("左右摇摆……")
//                    NotificationWrap.sendMax()
                    WindowManagerSwift.setFrontmostWindowToMaximized()
//                    MainThreadWrap.setFrontmostWindowToMaximized()
                }
            }
            else if (ctrl && cmd && keyRecorder.totalPressedKeys() == 6) {
                if (keyRecorder.isKeyPressed("LEFTARROW")
                    && keyRecorder.isKeyPressed("RIGHTARROW")
                    && keyRecorder.isKeyPressed("UPARROW")
                    && keyRecorder.isKeyPressed("DOWNARROW")
                ) {
                    NotificationWrap.sendAlert("神魂颠倒")
                }
            }
            else if (noFlags && keyRecorder.totalPressedKeys() == 2) {
                if (keyRecorder.isKeyPressed("`")
                    && keyRecorder.isKeyPressed("1")) {
                    DisplayPreferencesInvoke.res1()
                } else if (keyRecorder.isKeyPressed("1")
                           && keyRecorder.isKeyPressed("2")) {
                    DisplayPreferencesInvoke.res2()
                }
                else if (keyRecorder.isKeyPressed("2")
                         && keyRecorder.isKeyPressed("3")) {
                    DisplayPreferencesInvoke.res3()
                }
                else if (keyRecorder.isKeyPressed("3")
                         && keyRecorder.isKeyPressed("4")) {
                    DisplayPreferencesInvoke.degree0()
                }
                else if (keyRecorder.isKeyPressed("4")
                         && keyRecorder.isKeyPressed("5")) {
                    DisplayPreferencesInvoke.degree270()
                }
                else if (keyRecorder.isKeyPressed("5")
                         && keyRecorder.isKeyPressed("6")) {
                    DisplayPreferencesInvoke.degree90()
                }
                else if (keyRecorder.isKeyPressed("6")
                         && keyRecorder.isKeyPressed("7")) {
                    DisplayPreferencesInvoke.degree180()
                }
            }
            else if (noFlags && keyRecorder.totalPressedKeys() == 3) {
                if (keyRecorder.isKeyPressed("p")
                    && keyRecorder.isKeyPressed("[")
                    && keyRecorder.isKeyPressed("]")) {
//                    NotificationWrap.sendAlert("三指齐发")
                    MainThreadWrap.showAlert("三指齐发")
                }
            }
            
            //        print("appName" + mySelf.appName)
            //    if (mySelf.appName == "OpenEmu") {
            //
            //    }
            // -----***** hot key area  end *****-----
            
            
        }
        // keyUp
        // 不做 keyUp 事件，因为有个问题，如果触发条件是 1 2 3 三个键一起松开才触发，这样比较难搞。
        // 如果不是为了难搞，那用 keyDown 就够了。
        // else {}
        
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
