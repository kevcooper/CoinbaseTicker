//
//  AppDelegate.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CoinBase;
@class StatusBarView;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (strong) StatusBarView *statusBarView;

@property (strong) IBOutlet NSTextField *intervalTextField;
@property (strong) IBOutlet NSSlider *intervalSlider;
@property (strong) IBOutlet CoinBase *coinBase;

-(IBAction)updateStatusBarButton:(id)sender;

@end