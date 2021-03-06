//
//  AppDelegate.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/SUUpdater.h>
@class CoinBase;
@class StatusBarView;
@class CTLog;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet SUUpdater *sparkleUpdater;
@property (strong) CTLog *logger;

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (strong) CoinBase *coinBase;

@property (strong) IBOutlet NSMenu *statusMenu;
@property (strong) StatusBarView *statusBarView;

@property (strong) IBOutlet NSTextField *intervalTextField;
@property (strong) IBOutlet NSSlider *intervalSlider;

-(IBAction)changeUpdateInterval:(id)sender;
-(IBAction)goToCoinbase:(id)sender;
-(IBAction)updateStatusBarButton:(id)sender;

@end