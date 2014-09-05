//
//  AppDelegate.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "AppDelegate.h"
#import "CoinBase.h"

@implementation AppDelegate

- (void)awakeFromNib{
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"updateInterval"]){
        _updateInterval = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"updateInterval"];
    }else{
        _updateInterval = 5;
    }
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    self.statusBar.title = _statusTitle;

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [self reloadStatusBar];
    [_intervalTextField setIntValue:_updateInterval];
    [_intervalSlider setIntValue:_updateInterval];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:(_updateInterval * 60) target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
}

-(IBAction)changeUpdateInterval:(id)sender{
    _updateInterval = [sender intValue];
    [[NSUserDefaults standardUserDefaults]setInteger:_updateInterval forKey:@"updateInterval"];
    [_intervalTextField setIntValue:_updateInterval];
    
    [_updateTimer invalidate];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:(_updateInterval * 60) target:self selector:@selector(updateStatusBarButton:) userInfo:nil repeats:YES];
}

-(IBAction)updateStatusBarButton:(id)sender{
    [self reloadStatusBar];
    [self performSelectorInBackground:@selector(updateInfo) withObject:nil];
}

-(void)updateInfo{
    [_coinBase reloadPrices];
    [self reloadStatusBar];
}

-(void)reloadStatusBar{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"showSellPrice"] integerValue] == YES){
        _statusTitle = [NSString stringWithFormat:@"$%.2f/$%.2f",_coinBase.buyPrice,_coinBase.sellPrice];
    }else{
        _statusTitle = [NSString stringWithFormat:@"$%.2f",_coinBase.buyPrice];
    }
    self.statusBar.title = _statusTitle;
}

@end
