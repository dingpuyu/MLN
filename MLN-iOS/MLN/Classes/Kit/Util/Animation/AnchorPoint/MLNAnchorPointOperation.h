//
//  MLNAnchorPointOperation.h
//  MMLNua
//
//  Created by MOMO on 2020/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLNAnchorPointOperation : NSObject

@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, weak, readonly) UIView *targetView;
@property (nonatomic, assign) BOOL needRemake;

- (instancetype)initWithTargetView:(UIView *)targetView;
- (void)remakeIfNeed;
- (void)updateAnchorPoint:(CGPoint)anchorPoint;

@end

NS_ASSUME_NONNULL_END
