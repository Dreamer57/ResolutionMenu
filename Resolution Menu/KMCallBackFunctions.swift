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
        
        let mySelf = Unmanaged<KeyboardMonitor>.fromOpaque(context!).takeUnretainedValue()
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
            // opt
            else if (opt && !ctrl && !shift && !cmd
                     && keyRecorder.totalPressedKeys() == 2) {
                if (keyRecorder.isKeyPressed("OPT_R")
                    && keyRecorder.isKeyPressed("LEFTARROW")) {
                    unlock(mySelf.keyboard)
                    // mySelf.keyboard.unlock()
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
         else {
//             if (key == "p") {
//                 print("key release p")
//                 mySelf.keyboard.pressKey(4)
//                 mySelf.keyboard.pressKey(5)
//                 mySelf.keyboard.pressKey(6)
////                 let device = IOHIDElementGetDevice(elem)
////                 keyPress(device: device, keyCode: 4)
////                 keyPress(device: device, keyCode: 5)
////                 keyPress(device: device, keyCode: 6)
//             }
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
    

    

    
//    // keyborad
//    static func keyDown(device: IOHIDDevice, keyCode: UInt8) {
//        deviceSetReport(device: device, keyCode: keyCode, keyCode2: 0, keyCode3: 0)
//    }
//
//    static func keyUp(device: IOHIDDevice) {
//        deviceSetReport(device: device, keyCode: 0, keyCode2: 0, keyCode3: 3)
//    }
//
//    static func keyPress(device: IOHIDDevice, keyCode: UInt8) {
//        keyDown(device: device, keyCode: keyCode)
//        keyUp(device: device)
//    }
//
//    static func deviceSetReport(device: IOHIDDevice, keyCode: UInt8,
//                                keyCode2: UInt8, keyCode3: uint8) {
//        let reportID = 1 // 报告 ID
//        var reportData: [UInt8] = [1,0,0,0,0,0,0,0,0]
//        let reportLength = reportData.count
//        reportData[3] = keyCode;
//        reportData[4] = keyCode2;
//        reportData[5] = keyCode3;
//        var ret = IOHIDDeviceSetReport(device, kIOHIDReportTypeInput, reportID, reportData, reportLength);
//            if (ret != kIOReturnSuccess) {
//                print("指令发送失败");
//            }
//    }
    
    static func unlock(_ keyboard: VirtualHIDDeviceClientWrapper) {
        keyboard.pressKey(key_d)
        usleep(50 * 1000) // chrome 浏览器反应要慢一点。
        keyboard.pressKey(key_r)
        keyboard.pressKey(key_e)
        keyboard.pressKey(key_a)
        keyboard.pressKey(key_m)
        keyboard.pressKey(key_e)
        keyboard.pressKey(key_r)
        keyboard.pressKey(key_2)
        keyboard.pressKey(key_0)
        keyboard.pressKey(key_2)
        keyboard.pressKey(key_3)
        keyboard.pressKey(key_enter)
    }
 
    
    
    // key scancode
    static let key_a       :UInt8    = 4
    static let key_b       :UInt8    = 5
    static let key_c       :UInt8    = 6
    static let key_d       :UInt8    = 7
    static let key_e       :UInt8    = 8
    static let key_f       :UInt8    = 9
    static let key_g       :UInt8   = 10
    static let key_h       :UInt8   = 11
    static let key_i       :UInt8   = 12
    static let key_j       :UInt8   = 13
    static let key_k       :UInt8   = 14
    static let key_l       :UInt8   = 15
    static let key_m       :UInt8   = 16
    static let key_n       :UInt8   = 17
    static let key_o       :UInt8   = 18
    static let key_p       :UInt8   = 19
    static let key_q       :UInt8   = 20
    static let key_r       :UInt8   = 21
    static let key_s       :UInt8   = 22
    static let key_t       :UInt8   = 23
    static let key_u       :UInt8   = 24
    static let key_v       :UInt8   = 25
    static let key_w       :UInt8   = 26
    static let key_x       :UInt8   = 27
    static let key_y       :UInt8   = 28
    static let key_z       :UInt8   = 29
    static let key_1       :UInt8   = 30
    static let key_2       :UInt8   = 31
    static let key_3       :UInt8   = 32
    static let key_4       :UInt8   = 33
    static let key_5       :UInt8   = 34
    static let key_6       :UInt8   = 35
    static let key_7       :UInt8   = 36
    static let key_8       :UInt8   = 37
    static let key_9       :UInt8   = 38
    static let key_0       :UInt8   = 39
    static let key_enter   :UInt8   = 40
    static let key_shift_r :UInt8   = 22
}
