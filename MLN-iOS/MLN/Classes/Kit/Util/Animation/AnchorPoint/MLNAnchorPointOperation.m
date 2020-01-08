//
//  MLNAnchorPointOperation.m
//  MMLNua
//
//  Created by MOMO on 2020/1/8.
//

#import "MLNAnchorPointOperation.h"

@interface MLNAnchorPointOperation()
{
    CGSize _didSetSize;
    BOOL _didSetAnchorPoint;
}

@end

@implementation MLNAnchorPointOperation

- (instancetype)initWithTargetView:(UIView *)targetView
{
    if (self = [super init]) {
        _targetView = targetView;
        _anchorPoint = targetView.layer.anchorPoint;
    }
    return self;
}

- (void)remakeIfNeed
{
    //reset when size changed and did set anchorPoint
    if (_didSetAnchorPoint && !CGSizeEqualToSize(self.targetView.bounds.size, _didSetSize)) {
        _needRemake = YES;
    }
    if (!_needRemake) {
        return;
    }
    _didSetSize = self.targetView.bounds.size;
    [self setAnchorPoint:_anchorPoint targetView:_targetView];
}

- (void)updateAnchorPoint:(CGPoint)anchorPoint
{
    if (!CGPointEqualToPoint(anchorPoint, _anchorPoint)) {
        _needRemake = YES;
        _anchorPoint = anchorPoint;
        _didSetAnchorPoint = YES;
        if (!CGSizeEqualToSize(_targetView.bounds.size, CGSizeZero)) {
            [self setAnchorPoint:_anchorPoint targetView:_targetView];
            _didSetSize = _targetView.bounds.size;
        }
    }
}

- (void)setAnchorPoint:(CGPoint)point targetView:(UIView *)targetView
{
    CGPoint newPoint = CGPointMake(targetView.bounds.size.width * point.x, targetView.bounds.size.height * point.y);
    CGPoint oldPoint = CGPointMake(targetView.bounds.size.width * targetView.layer.anchorPoint.x, targetView.bounds.size.height * targetView.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, CGAffineTransformIdentity);
    oldPoint = CGPointApplyAffineTransform(oldPoint, CGAffineTransformIdentity);
    
    CGPoint position = targetView.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    targetView.layer.position = position;
    targetView.layer.anchorPoint = point;
}

@end
