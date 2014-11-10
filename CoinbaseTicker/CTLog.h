//
//  CTLog.h
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 11/10/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTLog : NSObject

+(void)notifyLogger:(NSString *) text;
-(void)logEntry:(NSNotification *)aNotification;
-(void)closeLog;

@end
