//
//  PurchaseCarAnimationTool.m
//  PruchaseCarAnimation
//
//  Created by zhenyong on 16/8/17.
//  Copyright © 2016年 com.demo. All rights reserved.
//
#import "AppDelegate.h"
#import "PurchaseCarAnimationTool.h"
@interface PurchaseCarAnimationTool()<CAAnimationDelegate>

@end

@implementation PurchaseCarAnimationTool
#pragma mark - instancetype
- (void)dealloc {
    NSLog(@"%@ -- dealloc",NSStringFromClass([self class]));
}
+ (instancetype)shareTool
{
    return [[PurchaseCarAnimationTool alloc]init];
}
#pragma public function
- (void)startAnimationFrom:(CGPoint)startPoint to:(CGPoint)finishPoint completion:(animationFinisnBlock)completion{
    _layer = [CALayer layer];
    _layer.backgroundColor = [UIColor redColor].CGColor;
    _layer.position = startPoint;
    _layer.frame = CGRectMake(startPoint.x, startPoint.y, 20, 20);
    _layer.cornerRadius = 10;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.layer addSublayer:_layer];
    /// 路径
    [self createPathFrom:startPoint to:finishPoint];
    /// 回调
    if (completion) {
        _animationFinisnBlock = completion;
    }
}
- (void)startAnimationandView:(UIView *)view
                         rect:(CGRect)rect
                  finisnPoint:(CGPoint)finishPoint
                  finishBlock:(animationFinisnBlock)completion
{
    //图层
    _layer = [CALayer layer];
    _layer.contents = view.layer.contents;
    _layer.contentsGravity = kCAGravityResizeAspectFill;
    rect.size.width  = rect.size.width;
    rect.size.height = rect.size.height;   //重置图层尺寸
    _layer.bounds = rect;
    
//    _layer = [CALayer layer];
//    _layer.backgroundColor = [UIColor redColor].CGColor;
//    rect.size.width = 20;
//    rect.size.height = 20;
//    _layer.cornerRadius = 10;
//    _layer.bounds = rect;
 
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.layer addSublayer:_layer];
    _layer.position = CGPointMake(rect.origin.x+view.frame.size.width/2, CGRectGetMidY(rect)); //a 点
    /// 路径
    [self createAnimationwithRect:rect finishPoint:finishPoint];
    /// 回调
    if (completion) {
        _animationFinisnBlock = completion;
    }
}
+ (void)shakeAnimation:(UIView *)shakeView
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
    shakeAnimation.autoreverses = YES;
    [shakeView.layer addAnimation:shakeAnimation forKey:nil];
    
}
#pragma mark - private function
- (void)createPathFrom:(CGPoint)startPoint to:(CGPoint)finishPoint {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:finishPoint controlPoint:CGPointMake(startPoint.x - 100, startPoint.y - 40)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    pathAnimation.duration = 0.5;
    pathAnimation.delegate = self;
    [pathAnimation setValue:_layer forKey:@"pathAnimation"];
    [_layer addAnimation:pathAnimation forKey:nil];
}
/// 创建动画
- (void)createAnimationwithRect:(CGRect)rect
                    finishPoint:(CGPoint)finishPoint {
    /// 路径动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_layer.position];
    [path addQuadCurveToPoint:finishPoint controlPoint:CGPointMake(ScreenWidth/2, rect.origin.y-80)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    /// 旋转动画
    CABasicAnimation *rotateAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue   = [NSNumber numberWithFloat:12];
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    /// 缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.25]; // 结束时的倍率
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    /// 添加动画动画组合
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,rotateAnimation,scaleAnimation];
    groups.duration = 1.0f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_layer == [anim valueForKey:@"pathAnimation"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
        if (_animationFinisnBlock) {
            _animationFinisnBlock(YES);
        }
    }
    if (anim == [_layer animationForKey:@"group"] || anim == [_layer animationForKey:@"pathAnimation"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
        if (_animationFinisnBlock) {
            _animationFinisnBlock(YES);
        }
    }
}
@end
