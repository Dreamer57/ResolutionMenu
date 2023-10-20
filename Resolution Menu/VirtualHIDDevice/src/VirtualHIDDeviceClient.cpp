//
//  VirtualHIDDeviceClient.cpp
//  VirtualHIDDeviceClient
//
//  Created by 殷瑞 on 2023/10/18.
//

#include <atomic>
#include <filesystem>
#include <iostream>
#include <pqrs/karabiner/driverkit/virtual_hid_device_driver.hpp>
#include <pqrs/karabiner/driverkit/virtual_hid_device_service.hpp>
#include <pqrs/local_datagram.hpp>
#include <thread>
#include "VirtualHIDDeviceClient.h"


//std::mutex client_mutex;
std::unique_ptr<pqrs::karabiner::driverkit::virtual_hid_device_service::client> client;

//std::mutex keyboard_thread_mutex;
//std::unique_ptr<std::thread> keyboard_thread1;
//std::atomic<bool> client_ready(false);
bool client_ready = false;

VirtualHIDDeviceClient* self;

VirtualHIDDeviceClient::VirtualHIDDeviceClient() {
    
    // Needed before using `pqrs::karabiner::driverkit::virtual_hid_device_service::client`.
    pqrs::dispatcher::extra::initialize_shared_dispatcher();
    
    self = this;
    
    initClient();
    
}

VirtualHIDDeviceClient::~VirtualHIDDeviceClient() {
    
    {
//      std::lock_guard<std::mutex> lock(client_mutex);
      client = nullptr;
    }

    {
//      std::lock_guard<std::mutex> lock(keyboard_thread_mutex);
//      if (keyboard_thread1) {
//        keyboard_thread1->join();
//      }
    }

    // Needed after using `pqrs::karabiner::driverkit::virtual_hid_device_service::client`.
    pqrs::dispatcher::extra::terminate_shared_dispatcher();
}

void VirtualHIDDeviceClient::start() {
    client_ready = true;
    client->async_start();
    unlock();
}

void VirtualHIDDeviceClient::stop() {
    client_ready = false; // 不要也行，下面有了。
    client->async_stop();
}

void VirtualHIDDeviceClient::pressKey(uint16_t key) {
    if (!isReady()) return;
    
    keyDown(key);
    keyUp();
}

void VirtualHIDDeviceClient::pressShiftAndKey(uint16_t key) {
    if (!isReady()) return;
    
    keyDownShiftAndKey(key);
    keyUp();
}

void VirtualHIDDeviceClient::keyDown(uint16_t key) {
    if (!isReady()) return;
    
    // key down
    pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::keyboard_input report;
    report.keys.insert(key);
    
    client->async_post_report(report);
    
}

void VirtualHIDDeviceClient::keyDownShiftAndKey(uint16_t key) {
    if (!isReady()) return;
    
    // key down
    pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::keyboard_input report;
    
    report.modifiers.insert(pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::modifier::left_shift);
    
    report.keys.insert(key);
    
    client->async_post_report(report);
    
}

void VirtualHIDDeviceClient::keyUp() {
    if (!client_ready) return;
    
    // key up
    pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::keyboard_input report;
    client->async_post_report(report);
    
}

bool VirtualHIDDeviceClient::isReady() {
    return client_ready;
}

void VirtualHIDDeviceClient::initClient() {
    
    client = std::make_unique<pqrs::karabiner::driverkit::virtual_hid_device_service::client>();
    
    client->warning_reported.connect([](auto&& message) {
      std::cout << "warning: " << message << std::endl;
    });

    client->connected.connect([] {
      std::cout << "connected" << std::endl;

      client->async_virtual_hid_keyboard_initialize(pqrs::hid::country_code::us);
      client->async_virtual_hid_pointing_initialize();
    });
    client->connect_failed.connect([](auto&& error_code) {
      std::cout << "connect_failed " << error_code << std::endl;
    });
    client->closed.connect([] {
      std::cout << "closed" << std::endl;
    });
    client->error_occurred.connect([](auto&& error_code) {
      std::cout << "error_occurred " << error_code << std::endl;
    });
//    client->driver_activated.connect([](auto&& driver_activated) {
//      static std::optional<bool> previous_value;
//
//        std::cout << "driver_activated " << driver_activated << std::endl;
//      if (previous_value != driver_activated) {
//        std::cout << "driver_activated " << driver_activated << std::endl;
//        previous_value = driver_activated;
//      }
//    });
//    client->driver_connected.connect([](auto&& driver_connected) {
//      static std::optional<bool> previous_value;
//
//        std::cout << "driver_connected " << driver_connected << std::endl;
//      if (previous_value != driver_connected) {
//        std::cout << "driver_connected " << driver_connected << std::endl;
//        previous_value = driver_connected;
//      }
//    });
//    client->driver_version_mismatched.connect([](auto&& driver_version_mismatched) {
//      static std::optional<bool> previous_value;
//
//      if (previous_value != driver_version_mismatched) {
//        std::cout << "driver_version_mismatched " << driver_version_mismatched << std::endl;
//        previous_value = driver_version_mismatched;
//      }
//    });
//    // 不用这个了，这个一秒要触发好几次。就用connected，md都一样。全不要了。启动就好了，这些只是通知而已。
//    client->virtual_hid_keyboard_ready.connect([this](auto&& ready) {
////      if (!keyboard_thread1) {
//        std::cout << "virtual_hid_keyboard_ready " << ready << std::endl;
////      }
//
//        client_ready = ready;
//        
////      if (ready) {
//////        std::lock_guard<std::mutex> lock(keyboard_thread_mutex);
////
////
////
//////        if (!keyboard_thread1) {
//////            keyboard_thread1 = std::make_unique<std::thread>([this] {
//////            std::this_thread::sleep_for(std::chrono::milliseconds(500));
////
////            {
//////              std::lock_guard<std::mutex> lock(client_mutex);
////
//////              if (client) {
//////                // key down (shift+e)
//////                {
//////                  pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::keyboard_input report;
//////                  report.modifiers.insert(pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::modifier::left_shift);
//////                  report.keys.insert(type_safe::get(pqrs::hid::usage::keyboard_or_keypad::keyboard_e));
//////                  client->async_post_report(report);
//////                }
//////
//////
//////                // key up
//////                {
//////                  pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::keyboard_input report;
//////                  client->async_post_report(report);
//////                }
//////
//////
//////                // key down (dpad down)
//////                {
//////                  pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::generic_desktop_input report;
//////                  report.keys.insert(type_safe::get(pqrs::hid::usage::generic_desktop::dpad_down));
//////                  client->async_post_report(report);
//////                }
//////
//////
//////                // key up
//////                {
//////                  pqrs::karabiner::driverkit::virtual_hid_device_driver::hid_report::generic_desktop_input report;
//////                  client->async_post_report(report);
//////                }
////
//////                  std::this_thread::sleep_for(std::chrono::milliseconds(60000));
////
//////                this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_d));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_r));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_e));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_a));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_m));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_e));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_r));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_2));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_0));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_2));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_3));
//////                  this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_return_or_enter));
//////              } // if (client) {
////            } // {
//////          }); // std::make_unique<std::thread>([this] {
//////        } // if (!keyboard_thread1) {
////      } //if (ready) {
//    });

//    client->async_start();
//    client->async_start();
}

void VirtualHIDDeviceClient::unlock() {
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_d));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_r));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_e));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_a));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_m));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_e));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_r));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_2));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_0));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_2));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_3));
    this->pressKey(get(pqrs::hid::usage::keyboard_or_keypad::keyboard_return_or_enter));
}
