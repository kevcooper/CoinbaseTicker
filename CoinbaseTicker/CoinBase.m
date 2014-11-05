//
//  CoinBase.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 9/4/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "CoinBase.h"

@implementation CoinBase

-(id)init{
    [self reloadPrices];
    return self;
}

-(void)reloadPrices{
    _buyPrice = [self getPriceFromAPI:@"https://coinbase.com/api/v1/prices/buy"];
    _sellPrice = [self getPriceFromAPI:@"https://coinbase.com/api/v1/prices/sell"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PriceChangedNotification"
                                                       object:self];
}

-(double)getPriceFromAPI:(NSString *)URL{
    NSURL *downloadURL = [NSURL URLWithString:URL];
    NSData *data = [NSData dataWithContentsOfURL:downloadURL];
    
    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
    
    NSString *price = [[JSON valueForKey:@"subtotal"]valueForKey:@"amount"];
    return [price doubleValue];
}

- (void)copyPrice:(double)price{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteboard setString:[NSString stringWithFormat:@"%.2f",price] forType:NSStringPboardType];
}

- (IBAction)goToCoinbase:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://coinbase.com"]];
}

-(IBAction)copyBuyPrice:(id)sender{
    [self copyPrice:_buyPrice];
}

-(IBAction)copySellPrice:(id)sender{
    [self copyPrice:_sellPrice];
}

@end
