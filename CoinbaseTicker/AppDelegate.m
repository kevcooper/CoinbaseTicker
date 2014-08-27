//
//  AppDelegate.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 8/20/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)awakeFromNib{
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    _price = [NSString stringWithFormat:@"%@/%@",[self getCurrentBuyPrice],[self getCurrentSellPrice]];
    self.statusBar.title = _price;
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
}

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

-(IBAction)updateStatusBarButton:(id)sender{
    [self performSelectorInBackground:@selector(updateInfo) withObject:nil];
}

-(void)updateInfo{
    _price = [NSString stringWithFormat:@"%@/%@",[self getCurrentBuyPrice],[self getCurrentSellPrice]];
    self.statusBar.title = _price;
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
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://coinbase.com"]];
}

@end
