//
//  ShareAPI.m
//  APmenu
//
//  Created by Alfredo E. Pérez L. on 3/7/15.
//  Copyright (c) 2015 Alfredo E. Pérez L. All rights reserved.
//

#import "ShareAPI.h"

@implementation ShareAPI

+(ShareAPI*)sharedInstance
{
    static ShareAPI  *_sharedInstance =nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance =[[ShareAPI alloc] init];
    });
    
    return _sharedInstance;
    
}

- (id)init {
    self=[super init];
    if (self) {
        self.Category = [[NSArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
