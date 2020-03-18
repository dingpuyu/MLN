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


@interface MLNGCanvasComponentView()

@property (nonatomic, strong) GLKView   *glkview;
@property (nonatomic, assign) CGSize    viewSize;
@property (nonatomic, assign) CGRect    componetFrame;
@property (nonatomic, assign) BOOL      isOffscreen;
@property (nonatomic, copy) NSString *ref;

@end

@implementation MLNGCanvasComponentView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _ref = [NSString stringWithFormat:@"%p", self];
        _viewSize = frame.size;
        _componetFrame = frame;
        self.needChangeEAGLContenxt = YES;
        [self loadView];
    }
    return self;
}


- (void)dealloc{
    [EAGLContext setCurrentContext:nil];
}

- (UIView *)loadView{
    if( !self.glkview ){
        GLKView *glkview = [[GLKView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height)];
        glkview.enableSetNeedsDisplay = YES;
        glkview.userInteractionEnabled = YES;
        glkview.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        glkview.drawableStencilFormat = GLKViewDrawableStencilFormat8;
        glkview.backgroundColor = [UIColor clearColor];
        
        self.glkview = glkview;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGCanvasCompLoadedNotification object:nil userInfo:@{@"componentId":self.ref}];
    }
    return self.glkview;
}

- (NSString*)componentId{
    return self.ref;
}

- (CGFloat)devicePixelRatio{
   return self.viewSize.width * [UIScreen mainScreen].nativeScale / self.componetFrame.size.width ;
}

@end
