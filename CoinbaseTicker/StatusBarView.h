//
//  StatusBarView.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 11/5/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoinBase;
@interface StatusBarView : NSObject

@property (strong) NSStatusItem *statusBarView;

-(id)initWithMenu:(NSMenu *)menu model:(CoinBase *)coinBaseModel;

@end
