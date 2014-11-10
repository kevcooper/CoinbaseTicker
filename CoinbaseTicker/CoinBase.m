//
//  CoinBase.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 9/4/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "CoinBase.h"
#import "CTLog.h"

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
    
    [CTLog notifyLogger:[NSString stringWithFormat:@"Coinbase Price Updated - Buy:$%.2f Sell:$%.2f",_buyPrice,_sellPrice]];
}

-(double)getPriceFromAPI:(NSString *)URL{
    NSURL *downloadURL = [NSURL URLWithString:URL];
    NSData *data = [NSData dataWithContentsOfURL:downloadURL];
    
    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
    
    NSString *price = [[JSON valueForKey:@"subtotal"]valueForKey:@"amount"];
    return [price doubleValue];
}

-(void)copyPrice:(double)price{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteboard setString:[NSString stringWithFormat:@"%.2f",price] forType:NSStringPboardType];
}

@end
