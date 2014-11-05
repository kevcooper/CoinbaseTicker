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
int updateInterval;

- (void)awakeFromNib{
    prefs = [NSUserDefaults standardUserDefaults];
    
    if([prefs valueForKey:@"updateInterval"]){
        updateInterval = (int)[prefs integerForKey:@"updateInterval"];
    }else{
        updateInterval = 5;
    }
    
    _statusBarView = [[StatusBarView alloc]initWithMenu: self.statusMenu];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [self updateInfo];
    [_intervalTextField setIntValue:updateInterval];
    [_intervalSlider setIntValue:updateInterval];
    
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:(updateInterval * 60) target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
}

-(IBAction)changeUpdateInterval:(id)sender{
    updateInterval = [sender intValue];
    [[NSUserDefaults standardUserDefaults]setInteger:updateInterval forKey:@"updateInterval"];
    [_intervalTextField setIntValue:updateInterval];
    
    [_updateTimer invalidate];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:(updateInterval * 60) target:self selector:@selector(updateStatusBarButton:) userInfo:nil repeats:YES];
}

-(IBAction)updateStatusBarButton:(id)sender{
    [self performSelectorInBackground:@selector(updateInfo) withObject:nil];
}

//timer fired
-(void)updateInfo{
    [_coinBase reloadPrices];
}

@end
