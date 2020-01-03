//
//  MLNAnimationSet.m
//  MLN
//
//  Created by MoMo on 2019/5/16.
//

#import "MLNAnimationSet.h"
#import "MLNKitHeader.h"
#import "MLNEntityExporterMacro.h"
#import "MLNBlock.h"
#import "NSDictionary+MLNSafety.h"
#import "MLNAlphaAnimation.h"

#define kCanvasCapcity 2

@interface MLNAnimationSet()

@property (nonatomic, assign) BOOL shareInterpolator;

@property (nonatomic, strong) NSMutableArray<MLNCanvasAnimation*> *animationsArray;
@property (nonatomic, strong) NSMutableArray<CAAnimation *> *animationsGroupArray;

@end

@implementation MLNAnimationSet

- (instancetype)initWithLuaCore:(MLNLuaCore *)luaCore shareInterpolator:(NSNumber *)shareInterpolator
{
    if (self = [super init]) {
        if (shareInterpolator) {
            _shareInterpolator = [shareInterpolator boolValue];
        }
    }
    return self;
}

- (NSArray<CAAnimation *> *)animationValues
{
    return _animationsGroupArray;
}

#pragma mark - copy
- (id)copyWithZone:(NSZone *)zone
{
    MLNAnimationSet *copy = [super copyWithZone:zone];
    copy.shareInterpolator = _shareInterpolator;
    copy.animationsArray = [_animationsArray mutableCopy];
    copy.animationsGroupArray = [_animationsGroupArray mutableCopy];
    return copy;
}


#pragma mark - getter & setter
- (NSMutableArray *)animationsArray
{
    if (!_animationsArray) {
        _animationsArray = [NSMutableArray arrayWithCapacity:kCanvasCapcity];
    }
    return _animationsArray;
}

- (NSMutableArray *)animationsGroupArray
{
    if (!_animationsGroupArray) {
        _animationsGroupArray = [NSMutableArray arrayWithCapacity:kCanvasCapcity];
    }
    return _animationsGroupArray;
}

#pragma mark - override

- (void)animationRealStart
{
    [super animationRealStart];
    for (MLNCanvasAnimation *canvasAnim in self.animationsArray) {
        [canvasAnim animationRealStart];
    }
}

- (CATransform3D)concatTransform3DWith:(CATransform3D)transform
{
    CATransform3D trans = transform;
    for (MLNCanvasAnimation *canvasAnim in self.animationsArray) {
        if ([canvasAnim isKindOfClass:[MLNAlphaAnimation class]]) {
            CABasicAnimation *baseAnimation = [canvasAnim animationForKey:kOpacity];
            if (baseAnimation) {
                self.targetView.alpha = [baseAnimation.fromValue floatValue];
            }
        }
        trans = [canvasAnim concatTransform3DWith:trans];
    }
    
    return trans;
}

- (void)animationRepeatCallback:(NSUInteger)repeatCount
{
    [super animationRepeatCallback:repeatCount];
    for (MLNCanvasAnimation *canvasAnim in self.animationsArray) {
        [canvasAnim animationStopCallbackFinished:YES];
        [canvasAnim animationRealStart];
    }
}


- (void)cancel
{
    [super cancel];
    for (MLNCanvasAnimation *canvasAnim in self.animationsArray) {
        [canvasAnim cancel];
    }
}

#pragma mark - Export Method
- (void)lua_addAnimation:(MLNCanvasAnimation *)animation
{
    if (!animation || ![animation isKindOfClass:[MLNCanvasAnimation class]]) {
        MLNKitLuaAssert(NO, @"animation type must be canvas animation!");
        return;
    }
    //Android端会按索引来，到了就执行，故做一次copy操作，不影响多次使用
//    animation = [animation copy];
    [self.animationsArray addObject:animation];
    animation.animationGroup.animations = [animation animationValues];
    self.duration = MAX(self.duration, [animation calculateTotalDuration]);
    self.animationGroup.duration = self.duration;
    self.pivotX = animation.pivotX;
    self.pivotXType = animation.pivotXType;
    self.pivotY = animation.pivotY;
    self.pivotYType = animation.pivotYType;
    [self.animationsGroupArray addObject:animation.animationGroup];
}

#pragma mark - Export To Lua
LUA_EXPORT_BEGIN(MLNAnimationSet)
LUA_EXPORT_METHOD(addAnimation, "lua_addAnimation:", MLNAnimationSet)
LUA_EXPORT_END(MLNAnimationSet, AnimationSet, YES, "MLNCanvasAnimation", "initWithLuaCore:shareInterpolator:")
@end
