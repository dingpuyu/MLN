//
//  MLNCanvasViewManager.m
//  LuaNative
//
//  Created by xiaotei's MacBookPro on 2020/3/18.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNCanvasViewManager.h"
#import "GCanvasViewProtocol.h"

@interface MLNCanvasViewManager()

@property (nonatomic, strong) NSMapTable *contentTable;

@end

@implementation MLNCanvasViewManager

+ (instancetype)sharedManager {
    static MLNCanvasViewManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)registerCanvasView:(NSObject<GCanvasViewProtocol> *)canvasView
{
    if ([canvasView respondsToSelector:@selector(componentId)]) {
        [self.contentTable setObject:canvasView forKey:[canvasView componentId]];
    }
}

- (NSObject<GCanvasViewProtocol> *)canvasViewWithComponentId:(NSString *)componentId
{
    if ([componentId isKindOfClass:[NSString class]]) {
        return [self.contentTable objectForKey:componentId];
    }
    return nil;
}

- (NSMapTable *)contentTable
{
    if (!_contentTable) {
        _contentTable = [NSMapTable weakToWeakObjectsMapTable];
    }
    return _contentTable;
}

@end
