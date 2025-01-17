//
//  Keylogger.swift
//  Keylogger
//
//  Created by Skrew Everything on 14/01/17.
//  Copyright © 2017 Skrew Everything. All rights reserved.
//

import Foundation
import IOKit.hid
import Cocoa

class KeyboardMonitor: NSObject
{
    var manager: IOHIDManager
    var deviceList = NSArray()                  // Used in multiple matching dictionary
    var bundlePathURL = Bundle.main.bundleURL   // Path to where the executable is present - Change this to use custom path
    var appName = ""                            // Active App name

    let keyboard: VirtualHIDDeviceClientWrapper = VirtualHIDDeviceClientWrapper()
    
    var mainThread: Thread?
    
    
    override init()
    {
        if AccessibilityChecker.checkAccessibilityPermission() {
            print("「辅助功能」权限已启用。")
        } else {
            print("「辅助功能」权限未启用。")
            MainThreadWrap.showAlert("「辅助功能」权限未启用，请开启权限后重启软件。")
        }
        
        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        
        // 调用父类的构造函数
        super.init()

        
        if (CFGetTypeID(manager) != IOHIDManagerGetTypeID())
        {
            print("Can't create manager")
            exit(1);
        }
        deviceList = deviceList.adding(CreateDeviceMatchingDictionary(inUsagePage: kHIDPage_GenericDesktop, inUsage: kHIDUsage_GD_Keyboard)) as NSArray
        deviceList = deviceList.adding(CreateDeviceMatchingDictionary(inUsagePage: kHIDPage_GenericDesktop, inUsage: kHIDUsage_GD_Keypad)) as NSArray

        IOHIDManagerSetDeviceMatchingMultiple(manager, deviceList as CFArray)
        
        
       
        let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        /* App switching notification*/
        NSWorkspace.shared.notificationCenter.addObserver(self,
            selector: #selector(activatedApp),
                name: NSWorkspace.didActivateApplicationNotification,
              object: nil)
        
         /* Connected and Disconnected Call Backs */
        IOHIDManagerRegisterDeviceMatchingCallback(manager, KMCallBackFunctions.Handle_DeviceMatchingCallback, observer)
        
        IOHIDManagerRegisterDeviceRemovalCallback(manager, KMCallBackFunctions.Handle_DeviceRemovalCallback, observer)
        
        /* Input value Call Backs */
        IOHIDManagerRegisterInputValueCallback(manager, KMCallBackFunctions.Handle_IOHIDInputValueCallback, observer);
        
        /* Input report Call Backs */
//        IOHIDManagerRegisterInputReportCallback(manager, KMCallBackFunctions.Handle_IOHIDInputReportCallback, observer)
        
        /* Open HID Manager */
        let ioreturn: IOReturn = openHIDManager()
        if ioreturn != kIOReturnSuccess
        {
            print("Can't open HID!")
        }

    }
    
    @objc dynamic func activatedApp(notification: NSNotification)
    {
        if  let info = notification.userInfo,
            let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let name = app.localizedName
        {
            self.appName = name
            // todo: 可以用一个数组，记录3到5个。提供灵活的判断。
            
        }
    }

    /* For Keyboard */
    func CreateDeviceMatchingDictionary(inUsagePage: Int ,inUsage: Int ) -> CFMutableDictionary
    {
        /* // note: the usage is only valid if the usage page is also defined */
        
        let resultAsSwiftDic = [kIOHIDDeviceUsagePageKey: inUsagePage, kIOHIDDeviceUsageKey : inUsage]
        let resultAsCFDic: CFMutableDictionary = resultAsSwiftDic as! CFMutableDictionary
        return resultAsCFDic
    }
    
    func openHIDManager() -> IOReturn
    {
        return IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone));
    }
    
    @objc
    func threadStart() {
        
        if ((mainThread == nil)) {
            
            mainThread = Thread(target: self, selector: #selector(start), object: nil)
        }
        
        if (mainThread?.isExecuting == false){
            // 启动线程
            mainThread?.start()
        }
        
        keyboard.start();
    }
    
    /* Scheduling the HID Loop */
    @objc
    func start()
    {
//        print("KeyMonitor.start")
//        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        // 最后，在后台线程中，确保运行 run loop，以便监听 HID 事件
        CFRunLoopRun()
        
//        DispatchQueue.global(qos: .default).async {
//            if let runLoop = CFRunLoopGetCurrent() {
//                let mode = CFRunLoopMode.defaultMode.rawValue
//
//                IOHIDManagerScheduleWithRunLoop(self.manager, runLoop, mode)
//
//                // 在这里执行其他后台任务
//
//                // 最后，在后台线程中，确保运行 run loop，以便监听 HID 事件
//                CFRunLoopRun()
//            } else {
//                // 处理获取 run loop 失败的情况
//                print("无法获取有效的 run loop")
//            }
//        }

    }
    
    /* Un-scheduling the HID Loop */
    @objc
    func stop()
    {
//        IOHIDManagerUnscheduleFromRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue);
        IOHIDManagerUnscheduleFromRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue);
        
        mainThread?.cancel();
        mainThread = nil;
        
        keyboard.stop();
        keyboard.dealloc()
    }
    
    
    static let keyMap: [UInt8:[String]] =
    {
        var map = [UInt8:[String]]()
        map[4] = ["a","A"]
        map[5] = ["b","B"]
        map[6] = ["c","C"]
        map[7] = ["d","D"]
        map[8] = ["e","E"]
        map[9] = ["f","F"]
        map[10] = ["g","G"]
        map[11] = ["h","H"]
        map[12] = ["i","I"]
        map[13] = ["j","J"]
        map[14] = ["k","K"]
        map[15] = ["l","L"]
        map[16] = ["m","M"]
        map[17] = ["n","N"]
        map[18] = ["o","O"]
        map[19] = ["p","P"]
        map[20] = ["q","Q"]
        map[21] = ["r","R"]
        map[22] = ["s","S"]
        map[23] = ["t","T"]
        map[24] = ["u","U"]
        map[25] = ["v","V"]
        map[26] = ["w","W"]
        map[27] = ["x","X"]
        map[28] = ["y","Y"]
        map[29] = ["z","Z"]
        map[30] = ["1","!"]
        map[31] = ["2","@"]
        map[32] = ["3","#"]
        map[33] = ["4","$"]
        map[34] = ["5","%"]
        map[35] = ["6","^"]
        map[36] = ["7","&"]
        map[37] = ["8","*"]
        map[38] = ["9","("]
        map[39] = ["0",")"]
        map[40] = ["ENTER","\n"]
        map[41] = ["ESCAPE","\\ESCAPE"]
        map[42] = ["DELETE|BACKSPACE","\\DELETE|BACKSPACE"] //
        map[43] = ["TAB","\\TAB"]
        map[44] = ["SPACE"," "]
        map[45] = ["-","_"]
        map[46] = ["=","+"]
        map[47] = ["[","{"]
        map[48] = ["]","}"]
        map[49] = ["\\","|"]
        map[50] = ["unknown_50",""] // Keyboard Non-US# and ~2
        map[51] = [";",":"]
        map[52] = ["'","\""]
        map[53] = ["`","~"]
        map[54] = [",","<"]
        map[55] = [".",">"]
        map[56] = ["/","?"]
        map[57] = ["CAPSLOCK","\\CAPSLOCK"]
        map[58] = ["F1","\\F1"]
        map[59] = ["F2","\\F2"]
        map[60] = ["F3","\\F3"]
        map[61] = ["F4","\\F4"]
        map[62] = ["F5","\\F5"]
        map[63] = ["F6","\\F6"]
        map[64] = ["F7","\\F7"]
        map[65] = ["F8","\\F8"]
        map[66] = ["F9","\\F9"]
        map[67] = ["F10","\\F10"]
        map[68] = ["F11","\\F11"]
        map[69] = ["F12","\\F12"]
        map[70] = ["PRINTSCREEN","\\PRINTSCREEN"]
        map[71] = ["SCROLL-LOCK","\\SCROLL-LOCK"]
        map[72] = ["PAUSE","\\PAUSE"]
        map[73] = ["INSERT","\\INSERT"]
        map[74] = ["HOME","\\HOME"]
        map[75] = ["PAGEUP","\\PAGEUP"]
        map[76] = ["DELETE-FORWARD","\\DELETE-FORWARD"] //
        map[77] = ["END","\\END"]
        map[78] = ["PAGEDOWN","\\PAGEDOWN"]
        map[79] = ["RIGHTARROW","\\RIGHTARROW"]
        map[80] = ["LEFTARROW","\\LEFTARROW"]
        map[81] = ["DOWNARROW","\\DOWNARROW"]
        map[82] = ["UPARROW","\\UPARROW"]
        map[83] = ["NUMLOCK","\\CLEAR"]
        // Keypads
        map[84] = ["/","/"]
        map[85] = ["*","*"]
        map[86] = ["-","-"]
        map[87] = ["+","+"]
        map[88] = ["ENTER","\\ENTER"]
        map[89] = ["1","\\END"]
        map[90] = ["2","\\DOWNARROW"]
        map[91] = ["3","\\PAGEDOWN"]
        map[92] = ["4","\\LEFTARROW"]
        map[93] = ["5","5"]
        map[94] = ["6","\\RIGHTARROW"]
        map[95] = ["7","\\HOME"]
        map[96] = ["8","\\UPARROW"]
        map[97] = ["9","\\PAGEUP"]
        map[98] = ["0","\\INSERT"]
        map[99] = [".","\\DELETE"]
        map[100] = ["unknown_100",""] //
        /////
        map[224] = ["CTRL_L","\\CTRL_L"] // left control
        map[225] = ["SHIFT_L","\\SHIFT_L"] // left shift
        map[226] = ["OPT_L","\\OPT_L"] // left alt
        map[227] = ["CMD_L","\\CMD_L"] // left cmd
        map[228] = ["CTRL_R","\\CTRL_R"] // right control
        map[229] = ["SHIFT_R","\\SHIFT_R"] // right shift
        map[230] = ["OPT_R","\\OPT_R"] // right alt
        map[231] = ["CMD_R","\\CMD_R"] // right cmd
        return map
    }()
    
    static let scancodeMap: [String: UInt8] = {
        var reversed = [String: UInt8]()
        
        for (key, values) in keyMap {
            reversed[values[0]] = key
//            for value in values {
//                reversed[value] = key
//            }
        }
//        print("\(reversed)\n")
        return reversed
    }()
    
    static let scancodeShiftMap: [String: UInt8] = {
        var reversed = [String: UInt8]()
        
        for (key, values) in keyMap {
            reversed[values[1]] = key
//            for value in values {
//                reversed[value] = key
//            }
        }
//        print("\(reversed)\n")
        return reversed
    }()

}
//
//public enum Scancode : UInt8, @unchecked Sendable {
//
//    case sc_A = 4
//    case scB = 5
//    case sc_1 = 1
//    case sc2 = 2
//    case sc3 = 3
//
//}
