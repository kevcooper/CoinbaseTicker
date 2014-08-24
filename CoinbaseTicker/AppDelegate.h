//
//  AppDelegate.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSPanel *prefs;

@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (strong, nonatomic) NSString *price;

@property (weak) IBOutlet NSButton *highAlert;
@property (weak) IBOutlet NSButton *lowAlert;
@property (weak) IBOutlet NSTextField *highValue;
@property (weak) IBOutlet NSTextField *lowValue;

-(IBAction)updateStatusBar:(id)sender;
- (IBAction)setAlertValues:(id)sender;
- (IBAction)openPrefs:(id)sender;


- (NSString *)getPercent;
@end
