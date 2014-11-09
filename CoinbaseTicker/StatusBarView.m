//
//  StatusBarView.m
//  CoinbaseTicker
//
//  Created by Kevin Cooper on 11/5/14.
//  Copyright (c) 2014 Kevlarr. All rights reserved.
//

#import "StatusBarView.h"
#import "CoinBase.h"

@implementation StatusBarView
CoinBase *model;
NSUserDefaults *prefs;


-(id)init{
    prefs = [NSUserDefaults standardUserDefaults];
    _statusBarView = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusBarView setHighlightMode:YES];
    
    [self registerObservers];
    return self;
}

-(id)initWithMenu:(NSMenu *) menu model:(CoinBase *)coinBaseModel{
    prefs = [NSUserDefaults standardUserDefaults];
    _statusBarView = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusBarView setHighlightMode:YES];
    _statusBarView.menu = menu;
    
    model = coinBaseModel;
    [self redrawTitle];
    
    [self registerObservers];
    
    return self;
}

-(void)registerObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(redrawTitle)
                                                name:@"PriceChangedNotification"
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(prefsChanged:)
                                                name:NSUserDefaultsDidChangeNotification
                                              object:nil];
}

-(void)prefsChanged:(NSNotification *) aNotification{
    [self performSelectorInBackground:@selector(redrawTitle) withObject:nil];
}

-(void)redrawTitle{
    if([prefs boolForKey:@"showSellPrice"] == YES){
        _statusBarView.title =[NSString stringWithFormat:@"$%.2f/$%.2f",model.buyPrice,model.sellPrice];
    }else{
        _statusBarView.title =[NSString stringWithFormat:@"$%.2f",model.buyPrice];
    }
}

@end
