//
//  MLNGCanvasModule.m
//  LuaNative
//
//  Created by MOMO on 2020/3/17.
//  Copyright © 2020 liu.xu_1586. All rights reserved.
//

#import "MLNGCanvasModule.h"
#import <GCanvas/GCanvasModule.h>
#import "MLNGCanvasComponentView.h"
#import "MLNCanvasViewManager.h"
#import "MLNImageLoaderProtocol.h"
#import "MLNKitInstanceHandlersManager.h"
#import "MLNKitHeader.h"
#import "MLNBlock.h"

@interface MLNGCanvasModule() <GCanvasModuleProtocol, GCVImageLoaderProtocol>
{
    BOOL _didEnableNeedRelease;
}
@property (nonatomic, strong) GCanvasModule  *gcanvasModule;


@end

@implementation MLNGCanvasModule

- (instancetype)init{
    if( self = [super init] ){
        self.gcanvasModule = [[GCanvasModule alloc] initWithDelegate:self];
        self.gcanvasModule.imageLoader = self;
    }
    return self;
}

#pragma mark - Weex Export Method
- (NSString*)lua_enable:(NSDictionary *)args{
    _didEnableNeedRelease = YES;
    return [self.gcanvasModule enable:args];
}

/**
 * Export Lua method for context 2D render
 *
 * @param   commands    render commands from Lua
 * @param   componentId GCanvas component identifier
 */
- (void)lua_render:(NSString *)commands componentId:(NSString*)componentId{
    [self.gcanvasModule render:commands componentId:componentId];
}

/**
 * Export Lua method for reset GCanvas component while disappear
 *
 * @param   componentId GCanvas component identifier
 */
- (void)lua_resetComponent:(NSString*)componentId{
    [self.gcanvasModule resetComponent:componentId];
}

/**
 * Export Lua method for preloading image
 *
 * @param   data        NSArray, contain 2 item
                        data[0] - image source,
                        data[1] - fake texture id(auto-increment id)of GCanvasImage in Lua
 * @param   componentId GCanvas component identifier
 * @param   callback
 */
- (void)lua_preLoadImage:(NSArray *)data callback:(MLNBlock *)callback{
    [self.gcanvasModule preLoadImage:data callback:^(id  _Nonnull result) {
        if (callback) {
            [callback addObjArgument:result];
            [callback callIfCan];
        }
    }];
}

/**
 * Export Lua method for binding image to real native texture
 *
 * @param   data        same as preLoadImage:callback:
 * @param   componentId GCanvas component identifier
 * @param   callback
 */
- (void)lua_bindImageTexture:(NSArray *)data componentId:(NSString*)componentId callback:(GCanvasModuleCallback)callback{
    [self.gcanvasModule bindImageTexture:data componentId:componentId callback:callback];
}

/**
 * Export Lua method  set GCanvas plugin contextType
 * @param   type    see GCVContextType
 */
- (void)lua_setContextType:(NSUInteger)type componentId:(NSString*)componentId{
    [self.gcanvasModule setContextType:type componentId:componentId];
}

/**
 * Export Lua method  set log level
 * @param   level
 */
- (void)lua_setLogLevel:(NSUInteger)level{
    [self.gcanvasModule setLogLevel:level];
}


#pragma mark - WebGL
/**
 * Lua call native directly just for WebGL
 *
 * @param   dict    input WebGL command
                    dict[@"contextId"] - GCanvas component identifier
                    dict[@"type"] - type
                    dict[@"args"] - WebGL command
 
 * @return          return execute result
 */
- (NSDictionary*)lua_extendCallNative:(NSDictionary*)dict{
    return [self.gcanvasModule extendCallNative:dict];
}

#pragma mark - GCanvasModuleProtocol
- (id<GCanvasViewProtocol>)gcanvasComponentById:(NSString*)componentId{
    MLNCanvasViewManager *uiManager = [MLNCanvasViewManager sharedManager];
    
    __block NSObject<GCanvasViewProtocol> *view = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        view = [uiManager canvasViewWithComponentId:componentId];
    });
    if ( [view isKindOfClass: [MLNGCanvasComponentView class]] ){
        return (MLNGCanvasComponentView*)view;
    }
    return nil;
    
}

- (NSString*)gcanvasModuleInstanceId
{
    return [NSString stringWithFormat:@"%p", self];
}

- (void)dispatchGlobalEvent:(NSString*)event params:(NSDictionary*)params
{
//    [self sendEventWithName:event body:params];
}

#pragma mark - GCVImageLoaderProtocol
- (void)loadImage:(NSURL*)url completed:(GCVLoadImageCompletion)completion{
    UIView<MLNEntityExportProtocol> *fakeView = nil;
    [[self imageLoader] view:fakeView loadImageWithPath:url.absoluteString completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable imagePath) {
        if (completion) {
            completion(image, error,error==nil,url);
        }
    }];
    
}

- (id<MLNImageLoaderProtocol>)imageLoader
{
    return  MLN_KIT_INSTANCE(self.mln_luaCore).instanceHandlersManager.imageLoader;
}

- (void)testDraw
{
    NSString *componentId = [_testView componentId];
    [self lua_enable:@{@"componentId":componentId, @"config":@[@(0), // renderMode: 0--RENDERMODE_WHEN_DIRTY, 1--RENDERMODE_CONTINUOUSLY
       @(-1), // hybridLayerType:  0--LAYER_TYPE_NONE 1--LAYER_TYPE_SOFTWARE 2--LAYER_TYPE_HARDWARE
       @(false), // supportScroll
       @(false), // newCanvasMode
       @(1), // compatible
       @"white", // clearColor
       @(false)]}];
    
    [self lua_setContextType:0 componentId:componentId];
    [self lua_render:@"Fgreen;T哈哈哈,50,50,0.0;Fblue;n0,100,200,200;" componentId:componentId];
//    [self render:@"" componentId:componentId];
//    [self render:@"" componentId:componentId];
//    [self render:@"" componentId:componentId];
//    [self render:@"" componentId:componentId];
    
}

#pragma mark - Override
- (void)mln_user_data_dealloc
{
    [super mln_user_data_dealloc];
    if (_didEnableNeedRelease) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGCanvasDestroyNotification object:self userInfo:@{@"instanceId":[self gcanvasModuleInstanceId]}];
    }
}

LUA_EXPORT_BEGIN(MLNGCanvasModule)
LUA_EXPORT_METHOD(enable, "lua_enable:", MLNGCanvasModule)
LUA_EXPORT_METHOD(render, "lua_render:componentId:", MLNGCanvasModule)
LUA_EXPORT_METHOD(resetComponent, "lua_resetComponent:", MLNGCanvasModule)
LUA_EXPORT_METHOD(preLoadImage, "lua_preLoadImage:callback:", MLNGCanvasModule)
LUA_EXPORT_METHOD(bindImageTexture, "lua_bindImageTexture:componentId:", MLNGCanvasModule)
LUA_EXPORT_METHOD(setContextType, "lua_setContextType:componentId:", MLNGCanvasModule)
LUA_EXPORT_METHOD(setLogLevel, "lua_setLogLevel:", MLNGCanvasModule)
LUA_EXPORT_METHOD(extendCallNative, "lua_extendCallNative:", MLNGCanvasModule)

LUA_EXPORT_END(MLNGCanvasModule, GCanvasModule, NO, NULL, NULL)

@end
