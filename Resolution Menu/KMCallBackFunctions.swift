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
    static var keyboardMonitor: KeyboardMonitor?;
    
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
        keyboardMonitor = mySelf;
        
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
        let allFlags = ctrl && shift && opt && cmd
        
        // dr57 debug print
        //                print("scancode:\t\(scancode)\t"
        //                    + "pressed:\t\(pressed)\t"
        //                    + "appName:\t\(mySelf.appName)\t")
        // printPressedKeys
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
                // unlock
                if (keyRecorder.isKeyPressed("OPT_R")
                    && keyRecorder.isKeyPressed("LEFTARROW")) {
                    //                    print("trigger appName: \(mySelf.appName)")
                    // print("password:\(mySelf.password)")
                    // print("password:\(PasswordManager.getPassword())")
                    if (mySelf.appName == "loginwindow") {
                        // 登录，锁屏界面
                        unlock_soft_loginWindowOnly()
                        //                        unlock(mySelf.keyboard)
                    }
                    else if (mySelf.appName == "系统设置"
                             || mySelf.appName == "SecurityAgent"
                             || mySelf.appName == "Safari浏览器") {
                        // Safari浏览器 的输入密码进程用得自己写的同一个进程。
                        unlock(mySelf.keyboard)
                    }
                    else if (mySelf.appName == "coreautha") {
                        // coreautha
                        // 系统验证进程，反应慢一点
                        // Google Chrome 调的这个
                        // App Store 也调的这个
                        unlock(mySelf.keyboard, slow: true)
                    }
                    else {
                        // 其它情况就不触发了。
                        // unlock(mySelf.keyboard)
                        // mySelf.keyboard.unlock()
                    }
                }
                // lock, to sleep
                else if (keyRecorder.isKeyPressed(DOWN_ARROW)) {
                    SystemUtility.enterSleep()
                }
                //
                else if (keyRecorder.isKeyPressed(UP_ARROW)) {
                    unlock_soft_loginWindowOnly()
                }
            }
            // 关机！慎按！
            else if (allFlags && keyRecorder.totalPressedKeys() == 8) {
                if (keyRecorder.isKeyPressed(UP_ARROW)
                    && keyRecorder.isKeyPressed(DOWN_ARROW)
                    && keyRecorder.isKeyPressed(LEFT_ARROW)
                    && keyRecorder.isKeyPressed(RIGHT_ARROW)) {
                    MainThreadWrap.showAlert("shutdown...")
                    // 关机！！！
                    SystemUtility.shutdown()
                }
                // 重启！慎按！
            } else if (allFlags && keyRecorder.totalPressedKeys() == 9) {
                if (keyRecorder.isKeyPressed("z")
                    && keyRecorder.isKeyPressed(UP_ARROW)
                    && keyRecorder.isKeyPressed(DOWN_ARROW)
                    && keyRecorder.isKeyPressed(LEFT_ARROW)
                    && keyRecorder.isKeyPressed(RIGHT_ARROW)) {
                    MainThreadWrap.showAlert("reboot...")
                    // 重启！！！
                    SystemUtility.reboot()
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
    
    
    static func unlock(_ keyboard: VirtualHIDDeviceClientWrapper, slow: Bool = false) {
        // print("password:\(PasswordManager.getPassword())")
        typingString(keyboard, PasswordManager.getPassword(), slow: true)
        keyboard.pressKey(key_enter)
    }
    
    static func unlock_old(_ keyboard: VirtualHIDDeviceClientWrapper, slow: Bool = false) {
        keyboard.pressKey(key_d)
        if (slow) {
            usleep(100 * 1000) // chrome 浏览器反应要慢一点。
        }
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
//        typingString(keyboard, "Dreamer2023.. +_***.&()|}{/?><@#åßåß123endENDsd")
    }
    
    static func typingString(_ keyboard: VirtualHIDDeviceClientWrapper, _ string: String, slow: Bool = false) {
        let charArray = string.map { String($0) }
        var i = 0
        for char in charArray {
            let scancode = KeyboardMonitor.scancodeMap[char]
            let scancodeShift = KeyboardMonitor.scancodeShiftMap[char]
            if (scancode != nil) {
                keyboard.pressKey(scancode!)
            } else if (scancodeShift != nil) {
                keyboard.pressShiftAndKey(scancodeShift!)
            }
            
            if (slow) {
                if (i == 0) {
                    usleep(100 * 1000) // chrome 浏览器反应要慢一点。
                }
            }
            i += 1
//            print("char:\t{\(char)}")
        }
    }
    
    static func unlock_soft_loginWindowOnly() {
        // print("password:\(PasswordManager.getPassword())")
        fakeKeyStrokes(PasswordManager.getPassword())
    }
    
    static func fakeKeyStrokes(_ string: String) {
        let src = CGEventSource(stateID: .hidSystemState)
        // Send 20 characters per keyboard event. That seems to be the limit.
        let PER = 20
        let uniCharCount = string.utf16.count
        var strIndex = string.utf16.startIndex
        for offset in stride(from: 0, to: uniCharCount, by: PER) {
            let pressEvent = CGEvent(keyboardEventSource: src, virtualKey: 49, keyDown: true)
            let len = offset + PER < uniCharCount ? PER : uniCharCount - offset
            let buffer = UnsafeMutablePointer<UniChar>.allocate(capacity: len)
            for i in 0..<len {
                buffer[i] = string.utf16[strIndex]
                strIndex = string.utf16.index(after: strIndex)
            }
            pressEvent?.keyboardSetUnicodeString(stringLength: len, unicodeString: buffer)
            pressEvent?.post(tap: .cghidEventTap)
            CGEvent(keyboardEventSource: src, virtualKey: 49, keyDown: false)?.post(tap: .cghidEventTap)
        }
        
        // Return key
        CGEvent(keyboardEventSource: src, virtualKey: 52, keyDown: true)?.post(tap: .cghidEventTap)
        CGEvent(keyboardEventSource: src, virtualKey: 52, keyDown: false)?.post(tap: .cghidEventTap)
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
    
    
    static let UP_ARROW    :String  = "UPARROW"
    static let DOWN_ARROW    :String  = "DOWNARROW"
    static let LEFT_ARROW    :String  = "LEFTARROW"
    static let RIGHT_ARROW    :String  = "RIGHTARROW"
    
    
    
    
    
    
    
    
    
    
    
    

    
    
        
}












// 不能说完全没用，至少是没用。
// 不行，不能搭快捷键，比如：opt，再按d，输出∂，换成其它flags键，都不行。
// 可以尝试每个键改一次字符，但我不想试了，又没我的方法好。
//static func unlock_soft() {
//    let src = CGEventSource(stateID: .hidSystemState)!
//
//    keyPress_soft(src, cgKeyCode("d"))
//    keyPress_soft(src, cgKeyCode("r"))
//    keyPress_soft(src, cgKeyCode("e"))
//    keyPress_soft(src, cgKeyCode("a"))
//    keyPress_soft(src, cgKeyCode("m"))
//    keyPress_soft(src, cgKeyCode("r"))
//    keyPress_soft(src, cgKeyCode("2"))
//    keyPress_soft(src, cgKeyCode("0"))
//    keyPress_soft(src, cgKeyCode("2"))
//    keyPress_soft(src, cgKeyCode("3"))
//
//    keyPress_soft(src, cgKeyCode("ENTER"))
//}
//
//
//static func cgKeyCode(_ keyString: String) -> CGKeyCode
//{
//
//
//    if (keyString == "a") { return CGKeyCode( 0)
//    }
//    if (keyString == "s") { return CGKeyCode( 1)
//    }
//    if (keyString == "d") { return CGKeyCode( 2)
//    }
//    if (keyString == "f") { return CGKeyCode( 3)
//    }
//    if (keyString == "h") { return CGKeyCode( 4)
//    }
//    if (keyString == "g") { return CGKeyCode( 5)
//    }
//    if (keyString == "z") { return CGKeyCode( 6)
//    }
//    if (keyString == "x") { return CGKeyCode( 7)
//    }
//    if (keyString == "c") { return CGKeyCode( 8)
//    }
//    if (keyString == "v") { return CGKeyCode( 9)
//        // what is CGKeyCode( 10)?
//    }
//    if (keyString == "b") { return CGKeyCode( 11)
//    }
//    if (keyString == "q") { return CGKeyCode( 12)
//    }
//    if (keyString == "w") { return CGKeyCode( 13)
//    }
//    if (keyString == "e") { return CGKeyCode( 14)
//    }
//    if (keyString == "r") { return CGKeyCode( 15)
//    }
//    if (keyString == "y") { return CGKeyCode( 16)
//    }
//    if (keyString == "t") { return CGKeyCode( 17)
//    }
//    if (keyString == "1") { return CGKeyCode( 18)
//    }
//    if (keyString == "2") { return CGKeyCode( 19)
//    }
//    if (keyString == "3") { return CGKeyCode( 20)
//    }
//    if (keyString == "4") { return CGKeyCode( 21)
//    }
//    if (keyString == "6") { return CGKeyCode( 22)
//    }
//    if (keyString == "5") { return CGKeyCode( 23)
//    }
//    if (keyString == "=") { return CGKeyCode( 24)
//    }
//    if (keyString == "9") { return CGKeyCode( 25)
//    }
//    if (keyString == "7") { return CGKeyCode( 26)
//    }
//    if (keyString == "-") { return CGKeyCode( 27)
//    }
//    if (keyString == "8") { return CGKeyCode( 28)
//    }
//    if (keyString == "0") { return CGKeyCode( 29)
//    }
//    if (keyString == "") { return CGKeyCode( 30)
//    }
//    if (keyString == "o") { return CGKeyCode( 31)
//    }
//    if (keyString == "u") { return CGKeyCode( 32)
//    }
//    if (keyString == "") { return CGKeyCode( 33)
//    }
//    if (keyString == "i") { return CGKeyCode( 34)
//    }
//    if (keyString == "p") { return CGKeyCode( 35)
//    }
//    if (keyString == "RETURN") { return CGKeyCode( 36)
//    }
//    if (keyString == "l") { return CGKeyCode( 37)
//    }
//    if (keyString == "j") { return CGKeyCode( 38)
//    }
//    if (keyString == "'") { return CGKeyCode( 39)
//    }
//    if (keyString == "k") { return CGKeyCode( 40)
//    }
//    if (keyString == "") { return CGKeyCode( 41)
//    }
//    if (keyString == "\\") { return CGKeyCode( 42)
//    }
//    if (keyString == ",") { return CGKeyCode( 43)
//    }
//    if (keyString == "/") { return CGKeyCode( 44)
//    }
//    if (keyString == "n") { return CGKeyCode( 45)
//    }
//    if (keyString == "m") { return CGKeyCode( 46)
//    }
//    if (keyString == ".") { return CGKeyCode( 47)
//    }
//    if (keyString == "TAB") { return CGKeyCode( 48)
//    }
//    if (keyString == "SPACE") { return CGKeyCode( 49)
//    }
//    if (keyString == "`") { return CGKeyCode( 50)
//    }
//    if (keyString == "DELETE") { return CGKeyCode( 51)
//    }
//    if (keyString == "ENTER") { return CGKeyCode( 52)
//    }
//    if (keyString == "ESCAPE") { return CGKeyCode( 53)
//
//        // some more missing codes abound, reserved I presume, but it would
//        // have been helpful for Apple to have a document with them all listed
//
//    }
//    if (keyString == ".") { return CGKeyCode( 65)
//
//    }
//    if (keyString == "*") { return CGKeyCode( 67)
//
//    }
//    if (keyString == "+") { return CGKeyCode( 69)
//
//    }
//    if (keyString == "CLEAR") { return CGKeyCode( 71)
//
//    }
//    if (keyString == "/") { return CGKeyCode( 75)
//    }
//    if (keyString == "ENTER") { return CGKeyCode( 76)  // numberpad on full kbd
//
//    }
//    if (keyString == "=") { return CGKeyCode( 78)
//
//    }
//    if (keyString == "=") { return CGKeyCode( 81)
//    }
//    if (keyString == "0") { return CGKeyCode( 82)
//    }
//    if (keyString == "1") { return CGKeyCode( 83)
//    }
//    if (keyString == "2") { return CGKeyCode( 84)
//    }
//    if (keyString == "3") { return CGKeyCode( 85)
//    }
//    if (keyString == "4") { return CGKeyCode( 86)
//    }
//    if (keyString == "5") { return CGKeyCode( 87)
//    }
//    if (keyString == "6") { return CGKeyCode( 88)
//    }
//    if (keyString == "7") { return CGKeyCode( 89)
//
//    }
//    if (keyString == "8") { return CGKeyCode( 91)
//    }
//    if (keyString == "9") { return CGKeyCode( 92)
//
//    }
//    if (keyString == "F5") { return CGKeyCode( 96)
//    }
//    if (keyString == "F6") { return CGKeyCode( 97)
//    }
//    if (keyString == "F7") { return CGKeyCode( 98)
//    }
//    if (keyString == "F3") { return CGKeyCode( 99)
//    }
//    if (keyString == "F8") { return CGKeyCode( 100)
//    }
//    if (keyString == "F9") { return CGKeyCode( 101)
//
//    }
//    if (keyString == "F11") { return CGKeyCode( 103)
//
//    }
//    if (keyString == "F13") { return CGKeyCode( 105)
//
//    }
//    if (keyString == "F14") { return CGKeyCode( 107)
//
//    }
//    if (keyString == "F10") { return CGKeyCode( 109)
//
//    }
//    if (keyString == "F12") { return CGKeyCode( 111)
//
//    }
//    if (keyString == "F15") { return CGKeyCode( 113)
//    }
//    if (keyString == "HELP") { return CGKeyCode( 114)
//    }
//    if (keyString == "HOME") { return CGKeyCode( 115)
//    }
//    if (keyString == "PGUP") { return CGKeyCode( 116)
//    }
//    if (keyString == "DELETE") { return CGKeyCode( 117)
//    }
//    if (keyString == "F4") { return CGKeyCode( 118)
//    }
//    if (keyString == "END") { return CGKeyCode( 119)
//    }
//    if (keyString == "F2") { return CGKeyCode( 120)
//    }
//    if (keyString == "PGDN") { return CGKeyCode( 121)
//    }
//    if (keyString == "F1") { return CGKeyCode( 122)
//    }
//    if (keyString == "LEFT") { return CGKeyCode( 123)
//    }
//    if (keyString == "RIGHT") { return CGKeyCode( 124)
//    }
//    if (keyString == "DOWN") { return CGKeyCode( 125)
//    }
//    if (keyString == "UP") { return CGKeyCode( 126)
//    }
//    return CGKeyCode( 0)
//    //fprintf(stderr, "keyString %s Not Found. Aborting...\n", keyString)
//    //exit(EXIT_FAILURE)
//}
//
//static func keyStringFormKeyCode(_ keyCode: CGKeyCode) -> String
//    {
//        // Proper key detection seems to want a switch statement, unfortunately
//        switch (keyCode)
//        {
//            case 0: return "a"
//            case 1: return "s"
//            case 2: return "d"
//            case 3: return "f"
//            case 4: return "h"
//            case 5: return "g"
//            case 6: return "z"
//            case 7: return "x"
//            case 8: return "c"
//            case 9: return "v"
//                // what is 10?
//            case 11: return "b"
//            case 12: return "q"
//            case 13: return "w"
//            case 14: return "e"
//            case 15: return "r"
//            case 16: return "y"
//            case 17: return "t"
//            case 18: return "1"
//            case 19: return "2"
//            case 20: return "3"
//            case 21: return "4"
//            case 22: return "6"
//            case 23: return "5"
//            case 24: return "="
//            case 25: return "9"
//            case 26: return "7"
//            case 27: return "-"
//            case 28: return "8"
//            case 29: return "0"
//            case 30: return "]"
//            case 31: return "o"
//            case 32: return "u"
//            case 33: return "["
//            case 34: return "i"
//            case 35: return "p"
//            case 36: return "RETURN"
//            case 37: return "l"
//            case 38: return "j"
//            case 39: return "'"
//            case 40: return "k"
//            case 41: return ""
//            case 42: return "\\"
//            case 43: return ","
//            case 44: return "/"
//            case 45: return "n"
//            case 46: return "m"
//            case 47: return "."
//            case 48: return "TAB"
//            case 49: return "SPACE"
//            case 50: return "`"
//            case 51: return "DELETE"
//            case 52: return "ENTER"
//            case 53: return "ESCAPE"
//
//                // some more missing codes abound, reserved I presume, but it would
//                // have been helpful for Apple to have a document with them all listed
//
//            case 65: return "."
//
//            case 67: return "*"
//
//            case 69: return "+"
//
//            case 71: return "CLEAR"
//
//            case 75: return "/"
//            case 76: return "ENTER"   // numberpad on full kbd
//
//            case 78: return "-"
//
//            case 81: return "="
//            case 82: return "0"
//            case 83: return "1"
//            case 84: return "2"
//            case 85: return "3"
//            case 86: return "4"
//            case 87: return "5"
//            case 88: return "6"
//            case 89: return "7"
//
//            case 91: return "8"
//            case 92: return "9"
//
//            case 96: return "F5"
//            case 97: return "F6"
//            case 98: return "F7"
//            case 99: return "F3"
//            case 100: return "F8"
//            case 101: return "F9"
//
//            case 103: return "F11"
//
//            case 105: return "F13"
//
//            case 107: return "F14"
//
//            case 109: return "F10"
//
//            case 111: return "F12"
//
//            case 113: return "F15"
//            case 114: return "HELP"
//            case 115: return "HOME"
//            case 116: return "PGUP"
//            case 117: return "DELETE"  // full keyboard right side numberpad
//            case 118: return "F4"
//            case 119: return "END"
//            case 120: return "F2"
//            case 121: return "PGDN"
//            case 122: return "F1"
//            case 123: return "LEFT"
//            case 124: return "RIGHT"
//            case 125: return "DOWN"
//            case 126: return "UP"
//
//            default:
//
//                return "Unknown key"
//                // Unknown key, bail and note that RUI needs improvement
//                //fprintf(stderr, "%ld\tKey\t%c (DEBUG: %d)\n", currenttime, keyCode
//                //exit(EXIT_FAILURE
//        }
//    }
//
//static func keyPress_soft(_ src: CGEventSource, _ virtualKey: CGKeyCode) {
//    CGEvent(keyboardEventSource: src, virtualKey: virtualKey, keyDown: true)?.post(tap: .cghidEventTap)
//    CGEvent(keyboardEventSource: src, virtualKey: virtualKey, keyDown: false)?.post(tap: .cghidEventTap)
//}
//
//static func fakeKeyStrokesUpgrade(_ string: String) {
//    let src = CGEventSource(stateID: .hidSystemState)
//    // Send 20 characters per keyboard event. That seems to be the limit.
//    let PER = 20
//    let uniCharCount = string.utf16.count
//    var strIndex = string.utf16.startIndex
//    let strArr = string.map{ String($0) }
//    // 使用 for 循环和下标访问数组元素并打印
//    for (index, character) in strArr.enumerated() {
//        print("Character at index \(index): \(character)")
//    }
//    var i = 0;
//    for offset in stride(from: 0, to: uniCharCount, by: PER) {
//        print(i) // 一键发送20个字符……我终于知道开头为什么会多出一个空格，也终于知道为什么空格在第一个……
//        i = i + 1
//        let pressEvent = CGEvent(keyboardEventSource: src, virtualKey: 49, keyDown: true)
//        let len = offset + PER < uniCharCount ? PER : uniCharCount - offset
//        let buffer = UnsafeMutablePointer<UniChar>.allocate(capacity: len)
//        for i in 0..<len {
//            buffer[i] = string.utf16[strIndex]
//            strIndex = string.utf16.index(after: strIndex)
//        }
//        pressEvent?.keyboardSetUnicodeString(stringLength: len, unicodeString: buffer)
//        pressEvent?.post(tap: .cghidEventTap)
//        CGEvent(keyboardEventSource: src, virtualKey: 49, keyDown: false)?.post(tap: .cghidEventTap)
//    }
//
//    // Return key
//    CGEvent(keyboardEventSource: src, virtualKey: 52, keyDown: true)?.post(tap: .cghidEventTap)
//    CGEvent(keyboardEventSource: src, virtualKey: 52, keyDown: false)?.post(tap: .cghidEventTap)
//}
