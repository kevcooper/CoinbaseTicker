//
//  CoinBase.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 9/4/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinBase : NSObject

@property double buyPrice;
@property double sellPrice;

-(IBAction)goToCoinbase:(id)sender;
-(IBAction)updateStatusBarButton:(id)sender;

-(void)reloadPrices;

@end
