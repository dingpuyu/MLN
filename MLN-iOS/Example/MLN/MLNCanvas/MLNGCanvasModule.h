//
//  MLNGCanvasModule.h
//  LuaNative
//
//  Created by MOMO on 2020/3/17.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLNGCanvasComponentView.h"
#import <MLNCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNGCanvasModule : NSObject <MLNEntityExportProtocol>

@property (nonatomic, weak) MLNGCanvasComponentView *testView;

- (void)testDraw;

@end

NS_ASSUME_NONNULL_END
