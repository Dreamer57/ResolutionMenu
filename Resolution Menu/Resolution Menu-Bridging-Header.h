//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "DisplayPreferencesInvoke.h"
#import "DisplayPreferences/Headers/Bridging-Header.h"
#import "Header.h"
//#import "DisplayPreferences/Header.h" // Header.h 不能放到第一个，我不知道为什么，但我调了两个半小时才发现这点。还有，为什么 Header.h 可以省略前面的文件夹能找到，而 Bridging-Header.h 必须要前面的文件夹。
// Header.h 没有 Include 和 Import 任何 header，但又用到了需要 Include 的类型，这可能是报错的原因。
// 之前可以，因为之前在 #import "DisplayPreferencesInvoke.h" 的后面。
// 可能，只需要在 Header.h 中加上 #import <Cocoa/Cocoa.h> 就行了。
// Cocoa 中包含：
// #import <Foundation/Foundation.h>
// #import <AppKit/AppKit.h>
// #import <CoreData/CoreData.h>
// 这些各自又 import 了很多，Header.h 用到的，可能全包含到了。
//ChatGPT:
//当你将 `Header.h` 的位置从一个位置移动到另一个位置时，可能会影响编译的行为。在 Xcode 项目中，头文件的包含路径是非常重要的。如果 `Header.h` 包含其他文件，或者其他文件包含了 `Header.h`，文件的相对位置可能会导致编译错误。
//
//通常，编译器在搜索头文件时会查找包含路径。如果你的 `Header.h` 文件中包含了标准库的头文件，比如 `#import <Foundation/Foundation.h>`，编译器会查找这些标准库的位置。
//
//当你将 `Header.h` 移动到新位置时，可能会导致包含路径发生变化。你可以通过在 Xcode 项目设置中查看 "Header Search Paths" 以确认头文件的搜索路径。如果你使用了相对路径，确保这些路径仍然有效。
//
//另外，还要确保 `Header.h` 中的包含语句使用正确的路径，特别是如果它包含其他头文件。相对路径的解释可能会因文件的位置而有所不同，这就是为什么在一个位置工作，但在另一个位置可能会出现问题的原因。
//
//总之，移动文件可能会改变文件的搜索路径，所以确保包含路径和文件相对路径都是正确的非常重要，这有助于避免编译错误。


#import "VirtualHIDDeviceClientWrapper.h"
