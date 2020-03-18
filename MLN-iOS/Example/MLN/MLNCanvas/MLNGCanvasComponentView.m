//
//  MLNGCanvasComponentView.m
//  LuaNative
//
//  Created by MOMO on 2020/3/17.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNGCanvasComponentView.h"
#import <GLKit/GLKit.h>
#import <GCanvas/GCVCommon.h>
#import <GCanvas/GCanvasModule.h>
#import "MLNViewExporterMacro.h"
#import "MLNKitHeader.h"
#import "UIView+MLNKit.h"
#import "UIView+MLNLayout.h"
#import "MLNLayoutContainerNode.h"
#import "MLNBeforeWaitingTask.h"
#import "MLNCanvasViewManager.h"

@interface MLNGCanvasComponentView()

@property (nonatomic, strong) GLKView   *glkview;
@property (nonatomic, assign) CGSize    viewSize;
@property (nonatomic, assign) CGRect    componetFrame;
@property (nonatomic, assign) BOOL      isOffscreen;
@property (nonatomic, copy) NSString *ref;

@property (nonatomic, strong) MLNBeforeWaitingTask *lazyTask;

@end

@implementation MLNGCanvasComponentView

- (instancetype)initWithLuaCore:(MLNLuaCore *)luaCore frame:(CGRect)frame
{
    if (self = [super initWithLuaCore:luaCore frame:frame]) {
        _ref = [NSString stringWithFormat:@"%p", self];
        _viewSize = frame.size;
        _componetFrame = frame;
        self.needChangeEAGLContenxt = YES;
        [[MLNCanvasViewManager sharedManager] registerCanvasView:self];
    }
    return self;
}

- (void)dealloc{
    [EAGLContext setCurrentContext:nil];
}

- (GLKView *)glkview
{
    if (!_glkview) {
        _glkview = [[GLKView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height)];
        _glkview.enableSetNeedsDisplay = YES;
        _glkview.userInteractionEnabled = YES;
        _glkview.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        _glkview.drawableStencilFormat = GLKViewDrawableStencilFormat8;
        _glkview.backgroundColor = [UIColor clearColor];
        [self addSubview:_glkview];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGCanvasCompLoadedNotification object:nil userInfo:@{@"componentId":self.ref}];
    }
    return _glkview;
}

- (NSString*)componentId{
    return self.ref;
}

- (CGFloat)devicePixelRatio{
   return self.viewSize.width * [UIScreen mainScreen].nativeScale / self.componetFrame.size.width ;
}

#pragma mark - Getter

#pragma mark - Overrid For Lua
- (UIView *)lua_contentView
{
    return self.glkview;
}

#pragma mark - Export For Lua


LUA_EXPORT_VIEW_BEGIN(MLNGCanvasComponentView)
LUA_EXPORT_VIEW_METHOD(componentId, "componentId", MLNCanvasView)
LUA_EXPORT_VIEW_END(MLNGCanvasComponentView, GCanvasView, YES, "MLNView", NULL)
@end
