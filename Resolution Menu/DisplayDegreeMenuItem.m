//
//  DisplayDegreeMenuItem.m
//  Resolution Menu
//
//  Created by 殷瑞 on 2023/10/14.
//  Copyright © 2023 Robbert Klarenbeek. All rights reserved.
//

#import "DisplayDegreeMenuItem.h"
#import "DisplayPreferencesInvoke.h"
#import "ResolutionMenu-Swift.h"


@interface DisplayDegreeMenuItem ()

// Private properties
@property CGDirectDisplayID display;
@property int degree;

@end


@implementation DisplayDegreeMenuItem

- (id)initWithDisplay:(CGDirectDisplayID)display andDegree:(int)degree
{
    self = [super init];
    if (self) {
        self.display = display;
        self.degree = degree;
        
        
        if (self.degree == 0) {
            self.title = @"Rotation Normal";
        } else {
            self.title = [NSString stringWithFormat: @"Rotation %d°", self.degree];
            
        }
        
        self.target = self;
        self.action = @selector(changeDisplayMode);
    }
    return self;
}

- (void)changeDisplayMode
{
    //    char* screenUUID = "37D8832A-2D66-02CA-B9F7-8F30A301B230";
    
    //    setRotation(self.display, screenUUID, 270);
    
//    [DisplayPreferencesInvoke degree:self.display andDegree:self.degree];
    
    [DisplayPreferencesWrapper rotationDegree:self.display :self.degree];
    
}

- (NSComparisonResult)compare:(DisplayDegreeMenuItem *)other
{
    // Compare using width, then height, then density (HiDPI)
    
    if (self.degree == 0 && other.degree == 270) {
        return NSOrderedDescending;
    } else if (self.degree == 0 && other.degree == 90) {
        return NSOrderedDescending;
    } else if (self.degree == 0 && other.degree == 180)  {
        return NSOrderedDescending;
    } else if (self.degree == 270 && other.degree == 0)  {
        return NSOrderedAscending;
    } else if (self.degree == 270 && other.degree == 90)  {
        return NSOrderedDescending;
    } else if (self.degree == 270 && other.degree == 180)  {
        return NSOrderedDescending;
    }  else if (self.degree == 90 && other.degree == 0)  {
        return NSOrderedAscending;
    } else if (self.degree == 90 && other.degree == 270)  {
        return NSOrderedAscending;
    } else if (self.degree == 90 && other.degree == 180)  {
        return NSOrderedDescending;
    }  else if (self.degree == 180 && other.degree == 0)  {
        return NSOrderedAscending;
    } else if (self.degree == 180 && other.degree == 90)  {
        return NSOrderedAscending;
    } else if (self.degree == 180 && other.degree == 270)  {
        return NSOrderedAscending;
    } else if (self.degree == other.degree)  {
        return NSOrderedSame;
    } else {
        return NSOrderedAscending;
    }
}

+ (NSArray *)getMenuItemsForDisplay:(CGDirectDisplayID)display
{
    // Get the current display mode, so we can put a checkmark (NSOnState) next to it
    //    int currentDisplayModeNumber;
    //    CGSGetCurrentDisplayMode(display, &currentDisplayModeNumber);
    
    // Use a dictionary with title keys to avoid 'duplicates'
    NSMutableDictionary *menuItemsByTitle = [NSMutableDictionary new];
    
    NSArray *degreeArray = @[@0, @270, @90, @180];
    
    for (NSNumber *degree in degreeArray) {
        int intValue = [degree intValue];
        
        DisplayDegreeMenuItem *menuItem = [[DisplayDegreeMenuItem alloc] initWithDisplay:display andDegree:intValue];
        //        DisplayDegreeMenuItem *previousMenuItem = menuItemsByTitle[menuItem.title];
        
        if (CGDisplayRotation(display) == intValue) {
            
            menuItem.state = NSControlStateValueOn;
        }
        menuItemsByTitle[menuItem.title] = menuItem;
    }
    
    
    // Return a sorted list, from low to high resolution
    return [[menuItemsByTitle allValues]sortedArrayUsingSelector:@selector(compare:)];
}

@end
