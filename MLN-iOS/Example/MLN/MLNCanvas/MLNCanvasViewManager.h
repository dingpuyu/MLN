//
//  MLNGCanvasViewManager.h
//  LuaNative
//
//  Created by xiaotei's MacBookPro on 2020/3/18.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GCanvasViewProtocol;

@interface MLNCanvasViewManager : NSObject

+ (instancetype)sharedManager;

- (void)registerCanvasView:(NSObject<GCanvasViewProtocol> *)canvasView;

- (NSObject<GCanvasViewProtocol> *)canvasViewWithComponentId:(NSString *)componentId;

@end

NS_ASSUME_NONNULL_END
