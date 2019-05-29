//
//  LLPublishViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLPublishViewController.h"
#import "LLPublishDetailViewController.h"
#import "LLDynamicModel.h"

@interface LLPublishViewController ()
@property (nonatomic, strong) CAShapeLayer *shape;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) LLDynamicModel *model;
@end

@implementation LLPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"发布";
    self.name = @"123";
    
//    [self drawRainbow];
//    [self showcolorLayer];
    [self keyFrameAnimation];
}
- (void)showcolorLayer{
    //create a red layer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)drawRainbow {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(200, 100)];
    [path addLineToPoint:CGPointMake(100, 200)];
//    [path stroke];
    self.path = path;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineWidth = 5;
    shape.lineJoin = kCALineJoinRound;
    shape.lineCap = kCALineCapRound;
    shape.path = self.path.CGPath;
    self.shape = shape;
    [self.view.layer addSublayer:self.shape];
    
}
- (void)moveLine{
//    [UIView animateWithDuration:1.5 animations:^{
        [self.path addLineToPoint:CGPointMake(300, 300)];
        self.shape.path = self.path.CGPath;
//    }];
    // 为曲线添加轨迹动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.duration = 4;
    [self.shape addAnimation:animation forKey:nil];
    
    
    
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LLPublishDetailViewController *vc = [[LLPublishDetailViewController alloc] init];
    vc.name = self.name;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    
//    [self moveLine];
//    [self hitView:touches];
}

- (void)hitView:(NSSet<UITouch *> *)touches {
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //check if we've tapped the moving layer
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        //randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        //otherwise (slowly) move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

- (void)keyFrameAnimation {
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed:@"Dynamic_Highlighted"].CGImage;
    shipLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shipLayer];
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.path = bezierPath.CGPath;
    [shipLayer addAnimation:animation forKey:nil];
}

@end
