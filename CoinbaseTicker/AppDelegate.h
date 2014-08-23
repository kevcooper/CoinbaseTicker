//
//  AppDelegate.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong, nonatomic) NSString *price;
-(IBAction)updateStatusBar:(id)sender;
- (NSString *)getPercent;
@end
