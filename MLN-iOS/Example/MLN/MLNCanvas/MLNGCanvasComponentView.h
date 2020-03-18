//
//  MLNGCanvasComponentView.h
//  LuaNative
//
//  Created by MOMO on 2020/3/17.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNView.h"
#import <GLKit/GLKit.h>
#import <GCanvas/GCanvasViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNGCanvasComponentView : MLNView <GCanvasViewProtocol>

@property (nonatomic, strong, readonly) GLKView* glkview;
@property (nonatomic, assign, readonly) CGRect componetFrame;

/**
 * offscreen GCanvasComponent
 */
@property (nonatomic, assign, readonly) BOOL isOffscreen;

/**
 * GCnavas plugin initilaise or refresh
 */
@property (nonatomic, assign) BOOL needChangeEAGLContenxt;

- (CGFloat)devicePixelRatio;
- (NSString*)componentId;


@end

NS_ASSUME_NONNULL_END
