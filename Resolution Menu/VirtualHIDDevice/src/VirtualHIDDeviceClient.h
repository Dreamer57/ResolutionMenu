//
//  VirtualHIDDeviceClient.h
//  VirtualHIDDeviceClient
//
//  Created by 殷瑞 on 2023/10/18.
//

#ifndef VirtualHIDDeviceClient_h
#define VirtualHIDDeviceClient_h

class VirtualHIDDeviceClient {
    
//public:
//    std::atomic<bool> client_ready;
    
    
public:
    VirtualHIDDeviceClient(); // 构造函数声明
    ~VirtualHIDDeviceClient(); // 析构函数声明
    
    // 方法声明
    void pressKey(uint16_t key);
    void keyDown(uint16_t key);
    void keyUp();
    bool isReady();
    void start();
    void stop();
    
    void pressShiftAndKey(uint16_t key);
    
    void unlock();
    
    
private:
    
    void initClient();
    
    void keyDownShiftAndKey(uint16_t key);
    
    
    
    
};



#endif /* VirtualHIDDeviceClient_h */
