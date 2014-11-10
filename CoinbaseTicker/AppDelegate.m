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
                                                             [NSNumber numberWithInteger:5], @"updateInterval",
                                                             [NSNumber numberWithBool:NO],@"showSellPrice", nil]];
    
    //error check the update interval (prevents people from putting a bad value directly in the plist)
    if([prefs integerForKey:@"updateInterval"] > 60 || [prefs integerForKey:@"updateInterval"] < 1){
        [prefs setInteger:5 forKey:@"updateInterval"];
    }
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    _statusBarView = [[StatusBarView alloc]initWithMenu: self.statusMenu model:_coinBase];
    
    [_intervalSlider setIntegerValue:[prefs integerForKey:@"updateInterval"]];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:([prefs integerForKey:@"updateInterval"] * 60) target:_coinBase selector:@selector(reloadPrices) userInfo:nil repeats:YES];
}

-(IBAction)changeUpdateInterval:(id)sender{
    [prefs setInteger:[sender integerValue] forKey:@"updateInterval"];
    
    [_updateTimer invalidate];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:([sender integerValue] * 60) target:_coinBase selector:@selector(reloadPrices) userInfo:nil repeats:YES];
    
}

@end
