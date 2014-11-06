//
//  AppDelegate.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "AppDelegate.h"
#import "CoinBase.h"
#import "StatusBarView.h"

@implementation AppDelegate

NSUserDefaults *prefs;

- (void)awakeFromNib{
    prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInt:5], @"updateInterval",
                                                             [NSNumber numberWithBool:NO],@"showSellPrice", nil]];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    _statusBarView = [[StatusBarView alloc]initWithMenu: self.statusMenu];
    [_intervalSlider setIntegerValue:[prefs integerForKey:@"updateInterval"]];
    [_coinBase reloadPrices];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:([prefs integerForKey:@"updateInterval"] * 60) target:_coinBase selector:@selector(reloadPrices) userInfo:nil repeats:YES];
}

-(IBAction)changeUpdateInterval:(id)sender{
    [prefs setInteger:[sender integerValue] forKey:@"updateInterval"];
    
    [_updateTimer invalidate];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:([sender integerValue] * 60) target:_coinBase selector:@selector(reloadPrices) userInfo:nil repeats:YES];
    
}

@end
