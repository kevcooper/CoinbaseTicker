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
#import "CTLog.h"

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
        _logger = [[CTLog alloc]init];
        [CTLog notifyLogger:@"CointbaseTicker Started"];
    
    _coinBase = [[CoinBase alloc]init];
    _statusBarView = [[StatusBarView alloc]initWithMenu:_statusMenu model:_coinBase];
    
    [_intervalSlider setIntegerValue:[prefs integerForKey:@"updateInterval"]];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:([prefs integerForKey:@"updateInterval"] * 60)
                                                    target:self
                                                  selector:@selector(fireTimer)
                                                  userInfo:nil
                                                   repeats:YES];
    
    [_sparkleUpdater checkForUpdatesInBackground];
}

-(IBAction)changeUpdateInterval:(id)sender{
    [prefs setInteger:[sender integerValue] forKey:@"updateInterval"];
    
    [_updateTimer invalidate];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:([sender integerValue] * 60)
                                                    target:self
                                                  selector:@selector(fireTimer)
                                                  userInfo:nil
                                                   repeats:YES];
    
    [CTLog notifyLogger:[NSString stringWithFormat:@"Update Interval Changed: %ld", (long)[sender integerValue]]];
}

-(IBAction)updateStatusBarButton:(id)sender{
    [_coinBase performSelectorInBackground:@selector(reloadPrices) withObject:nil];
    [CTLog notifyLogger:@"Update menu option pressed"];
}

- (IBAction)goToCoinbase:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://coinbase.com"]];
    [CTLog notifyLogger:@"Opened https://coinbase.com in browser"];
}

-(void)fireTimer{
    [_coinBase performSelectorInBackground:@selector(reloadPrices) withObject:nil];
    [CTLog notifyLogger:@"CoinbaseTicker Timer Fired"];
}

-(void)applicationWillTerminate:(NSNotification *)notification{
    [CTLog notifyLogger:@"CoinbaseTicker Closing"];
    [_logger closeLog];
}

@end
