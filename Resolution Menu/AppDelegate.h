//
//  AppDelegate.h
//  Resolution Menu
//
//  Created by Robbert Klarenbeek on 23-12-13.
//  Copyright (c) 2013 Robbert Klarenbeek. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (assign) IBOutlet NSMenu *menu;
@property (nonatomic, strong) NSStatusItem *statusItem;

- (IBAction)rotationNormal:(id)sender;

- (IBAction)rotation270:(id)sender;

- (IBAction)rotation90:(id)sender;

- (IBAction)openDisplayPreferences:(id)sender;

@end

