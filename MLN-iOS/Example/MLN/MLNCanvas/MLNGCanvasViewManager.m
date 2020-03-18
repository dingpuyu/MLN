//
//  MLNGCanvasViewManager.m
//  LuaNative
//
//  Created by xiaotei's MacBookPro on 2020/3/18.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNGCanvasViewManager.h"

@implementation MLNGCanvasViewManager

+ (instancetype)sharedManager {
    static MLNGCanvasViewManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}


@end
