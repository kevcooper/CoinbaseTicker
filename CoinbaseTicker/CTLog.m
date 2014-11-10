//
//  CTLog.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 11/10/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "CTLog.h"

@implementation CTLog

NSString *path;
NSFileHandle *handle;

+(void)notifyLogger:(NSString *) text{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"logEntry", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CTLog" object:self userInfo:dict];
}

-(id)init{
    path = [@"~/Library/Logs/CoinbaseTicker.log" stringByExpandingTildeInPath];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:path]){
        [[NSFileManager defaultManager]createFileAtPath:path
                                               contents:nil
                                             attributes:nil];
    }
    
    handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle seekToEndOfFile];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logEntry:) name:@"CTLog" object:nil];
    
    return self;
}

-(void)logEntry:(NSNotification *)aNotification{
    NSString *text = [[aNotification userInfo]valueForKey:@"logEntry"];
    NSString *logEntry = [NSString stringWithFormat:@"%@: %@",[[NSDate date] dateWithCalendarFormat:@"%Y-%m-%d %H:%M:%S" timeZone:nil],text];
    
    [handle seekToEndOfFile];
    [handle writeData:[logEntry dataUsingEncoding:NSUTF8StringEncoding]];
    [handle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",text);
}

-(void)closeLog{
    [handle closeFile];
}

@end
