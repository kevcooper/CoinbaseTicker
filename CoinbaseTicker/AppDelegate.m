//
//  AppDelegate.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "AppDelegate.h"
#include <math.h>

@implementation AppDelegate
- (void)awakeFromNib{
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    _price = [NSString stringWithFormat:@"$%@ ",[self getCurrentBuyPrice]];
    self.statusBar.title = _price;
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(updateStatusBar:) userInfo:nil repeats:YES];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

double oldPrice = 0.0;
double *doublePrice;
-(NSString *)getCurrentBuyPrice{
    NSURL *downloadURL = [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/buy"];
    NSData *data = [NSData dataWithContentsOfURL:downloadURL];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];
    
    NSString *price = [[JSON valueForKey:@"subtotal"]valueForKey:@"amount"];
    return price;
}

-(NSString *)getCurrentSellPrice{
    NSURL *downloadURL = [NSURL URLWithString:@"https://coinbase.com/api/v1/prices/sell"];
    NSData *data = [NSData dataWithContentsOfURL:downloadURL];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &e];
    
    NSString *price = [[JSON valueForKey:@"subtotal"]valueForKey:@"amount"];
    return price;
}

-(IBAction)updateStatusBar:(id)sender{
    _price = [NSString stringWithFormat:@"$%@ %@",[self getCurrentBuyPrice], [self getPercent]];
    self.statusBar.title = _price;
    [self Alerts];
    //NSLog(price);
}

- (IBAction)setAlertValues:(id)sender {
    if ([_highAlert state] == NSOnState) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"highAlertBool"];
        [[NSUserDefaults standardUserDefaults] setDouble:[_highValue doubleValue] forKey:@"highAlert"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"highAlertBool"];
    }
    if ([_lowAlert state] == NSOnState) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lowAlertBool"];
        [[NSUserDefaults standardUserDefaults] setDouble:[_lowValue doubleValue] forKey:@"lowAlert"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"lowAlertBool"];
    }
    [_prefs close];
}

- (IBAction)openPrefs:(id)sender {
    [_prefs orderFront:self];
    if ([[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"highAlertBool"] boolValue]) {
        [_highAlert setState:NSOnState];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"lowAlertBool"] boolValue]) {
        [_lowAlert setState:NSOnState];
    }
    [_lowValue setStringValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"lowAlert"]];
    [_highValue setStringValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"highAlert"]];
}

- (IBAction)copyBuyPrice:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    NSArray *splitPrices = [_price componentsSeparatedByString:@"/"];
    [pasteboard setString:splitPrices[0] forType:NSStringPboardType];
}

- (IBAction)copySellPrice:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    NSArray *splitPrices = [_price componentsSeparatedByString:@"/"];
    [pasteboard setString:splitPrices[1] forType:NSStringPboardType];
}

- (IBAction)goToCoinbase:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://coinbase.com/buys"]];
}


- (NSString *)getPercent {
    
    if ( oldPrice == 0.0) {
        oldPrice = [[self getCurrentBuyPrice] doubleValue];
        return @"no change";
    }
   
    double percentage = [self.getCurrentBuyPrice doubleValue] - oldPrice;
    percentage = percentage / oldPrice;
    percentage = percentage * 100;
  
    //NSLog(@"%f", percentage);
    if (percentage > 0) {
        oldPrice = [[self getCurrentBuyPrice] doubleValue];
        return [NSString stringWithFormat:@"⬆︎ %.03f%%", percentage];
    }
    else if (percentage < 0){
        oldPrice = [[self getCurrentBuyPrice] doubleValue];
        return [NSString stringWithFormat:@"⬇︎ %.03f%%", percentage];
    }
        oldPrice = [_price floatValue];
return @"no change";
}

- (void)Alerts {
    if ([[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"highAlertBool"] boolValue] && [self.getCurrentBuyPrice doubleValue] >= [[[NSUserDefaults standardUserDefaults] valueForKey:@"highAlert"] doubleValue]) {
        
        [_highAlert setState:NSOffState];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"highAlertBool"];
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"High BTC Price";
        notification.informativeText = [NSString stringWithFormat:@"the current BTC price on coinbase has exceeded $%.02f", [[[NSUserDefaults standardUserDefaults] valueForKey:@"highAlert"] doubleValue]];
        notification.soundName = NSUserNotificationDefaultSoundName;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"lowAlertBool"] boolValue] && [self.getCurrentBuyPrice doubleValue] <= [[[NSUserDefaults standardUserDefaults] valueForKey:@"lowAlert"] doubleValue]) {
        
        [_lowAlert setState:NSOffState];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"lowAlertBool"];
        NSUserNotification *lowNotification = [[NSUserNotification alloc] init];
        lowNotification.title = @"Low BTC Price";
        lowNotification.informativeText = [NSString stringWithFormat:@"the current BTC price on coinbase has dropped below $%.02f", [[[NSUserDefaults standardUserDefaults] valueForKey:@"lowAlert"] doubleValue]];
        lowNotification.soundName = NSUserNotificationDefaultSoundName;
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:lowNotification];
    }
}


@end
