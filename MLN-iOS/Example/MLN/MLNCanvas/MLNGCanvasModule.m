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
#import "MLNBlock.h"

@interface MLNGCanvasModule() <GCanvasModuleProtocol, GCVImageLoaderProtocol>

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
- (NSString*)enable:(NSDictionary *)args{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onWeexInstanceWillDestroy:)
//                                                 name:WX_INSTANCE_WILL_DESTROY_NOTIFICATION
//                                               object:nil];
    return [self.gcanvasModule enable:args];
}



/**
 * Export Lua method for context 2D render
 *
 * @param   commands    render commands from Lua
 * @param   componentId GCanvas component identifier
 */
- (void)render:(NSString *)commands componentId:(NSString*)componentId{
    [self.gcanvasModule render:commands componentId:componentId];
}

/**
 * Export Lua method for reset GCanvas component while disappear
 *
 * @param   componentId GCanvas component identifier
 */
- (void)resetComponent:(NSString*)componentId{
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
- (void)preLoadImage:(NSArray *)data callback:(GCanvasModuleCallback)callback{
    [self.gcanvasModule preLoadImage:data callback:callback];
}

/**
 * Export Lua method for binding image to real native texture
 *
 * @param   data        same as preLoadImage:callback:
 * @param   componentId GCanvas component identifier
 * @param   callback
 */
- (void)bindImageTexture:(NSArray *)data componentId:(NSString*)componentId callback:(GCanvasModuleCallback)callback{
    [self.gcanvasModule bindImageTexture:data componentId:componentId callback:callback];
}

/**
 * Export Lua method  set GCanvas plugin contextType
 * @param   type    see GCVContextType
 */
- (void)setContextType:(NSUInteger)type componentId:(NSString*)componentId{
    [self.gcanvasModule setContextType:type componentId:componentId];
}

/**
 * Export Lua method  set log level
 * @param   level
 */
- (void)setLogLevel:(NSUInteger)level{
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
- (NSDictionary*)extendCallNative:(NSDictionary*)dict{
    return [self.gcanvasModule extendCallNative:dict];
}

#pragma mark - GCanvasModuleProtocol
- (id<GCanvasViewProtocol>)gcanvasComponentById:(NSString*)componentId{
    __block id<GCanvasViewProtocol> component = nil;
    __weak typeof(self) weakSelf = self;

//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    while ( !component || !component.glkview ) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), [self targetExecuteQueue], ^{
//            WXPerformBlockSyncOnComponentThread(^{
//                component = (WXGCanvasComponent *)[weakSelf.weexInstance componentForRef:componentId];
//            });
//            dispatch_semaphore_signal(semaphore);
//        });
//        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)));
//    }
    
    return _testView;
//    return component;
}

- (NSString*)gcanvasModuleInstanceId{
    return @"testtest";
}

- (void)dispatchGlobalEvent:(NSString*)event params:(NSDictionary*)params{
//    [weexInstance fireGlobalEvent:event params:params];
}

#pragma mark - GCVImageLoaderProtocol
- (void)loadImage:(NSURL*)url completed:(GCVLoadImageCompletion)completion{
//    [[SDWebImageManager sharedManager].imageLoader requestImageWithURL:url options:0 context:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        completion(image, error, finished, url);
//    }];
}

#pragma mark - Event Notificaiton
- (void)onWeexInstanceWillDestroy:(NSNotification*)notification{
    NSString *instanceId = notification.userInfo[@"instanceId"];
    if (![instanceId isEqualToString:@"test"]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGCanvasDestroyNotification
                                                        object:notification.object
                                                      userInfo:notification.userInfo];
}

- (void)testDraw
{
    NSString *componentId = [_testView componentId];
    [self enable:@{@"componentId":componentId, @"config":@[@(0), // renderMode: 0--RENDERMODE_WHEN_DIRTY, 1--RENDERMODE_CONTINUOUSLY
       @(-1), // hybridLayerType:  0--LAYER_TYPE_NONE 1--LAYER_TYPE_SOFTWARE 2--LAYER_TYPE_HARDWARE
       @(false), // supportScroll
       @(false), // newCanvasMode
       @(1), // compatible
       @"white", // clearColor
       @(false)]}];
    [self render:@"" componentId:componentId];
    [self render:@"" componentId:componentId];
    [self render:@"" componentId:componentId];
    [self render:@"" componentId:componentId];
    [self render:@"" componentId:componentId];
}

@end
