//
//  SystemUtility.swift
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/19.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

//import IOKit
import IOKit.pwr_mgt

class SystemUtility {
    static func enterSleep() {
        let port = IOPMFindPowerManagement(mach_port_t(MACH_PORT_NULL))
        IOPMSleepSystem(port)
        IOServiceClose(port)
    }
    
    // 慎用...
    static func shutdown() {
        let _ = cliTask("/sbin/shutdown -h now")
    }
    
    static func reboot() {
        let _ = cliTask("/sbin/shutdown -r now")
    }
}
