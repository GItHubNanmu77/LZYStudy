//
//  LLAnimationSpeedViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/20.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLAnimationSpeedViewController.h"

@interface LLAnimationSpeedViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *bigImage;




@end

@implementation LLAnimationSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createLayer];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:pan];
    
    [self.view addSubview:self.backView];
    
}

- (void)createLayer {
    //create a red layer
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    [self createAnimationGroup];
}


- (void)panView:(UIPanGestureRecognizer *)pan
{
    //        NSLog(@">>>>>  pan 导航栏--%f",self.navigationController.navigationBar.y);
    //        NSLog(@">>>>>  table--%f",self.table.y);
    
    
    //点相对于上一个点的位置可以用来判断滑动方向,往下是大于0
    CGPoint moviePoint = [pan translationInView:pan.view];
    //    NSLog(@" x=%f ,y=%f",moviePoint.x, moviePoint.y);
    //每次都需要复位
    [pan setTranslation:CGPointZero inView:pan.view];
    
    CGFloat h = 100;
    h = h + moviePoint.y;
    
    CGFloat value = (h - 100 )/100;
    NSLog(@"--%f",value);
//    self.backView.alpha = value;
    CGSize size = CGSizeMake(LZY_SCREEN_WIDTH * value, 200*value);
    CGRect frame = CGRectMake(0, h, size.width, size.height);
    self.backView.frame = frame;
    
}

- (void)createPositionAnimation:(NSSet *)touches {
    //configure the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    //set the position
    self.colorLayer.position = [[touches anyObject] locationInView:self.view];
    //commit transaction
    [CATransaction commit];
}
- (void)createAnimationGroup {
    // 2. 向组动画中添加各种子动画
    // 2.1 旋转
//    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    // anim1.toValue = @(M_PI * 2 * 500);
//    anim1.byValue = @(M_PI * 2 * 1000);
    
    // 2.2 缩放
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim2.fromValue = @(0.5);
    anim2.toValue = @(1.0);
    
    // 2.3 改变位置, 修改position
//    CAKeyframeAnimation *anim3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    anim3.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 100, 250, 100)].CGPath;
    
    CABasicAnimation *anim4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim4.fromValue = @(0.5);
    anim4.toValue = @(1.0);
    
    
    // 把子动画添加到组动画中
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    
    groupAnima.animations = @[anim2, anim4];
    
    groupAnima.duration = 2.0;
    [self.colorLayer addAnimation:groupAnima forKey:@"animationGroup"];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, LZY_IPHONE_NAV_STATUS_HEIGHT, LZY_SCREEN_WIDTH, 200)];
            view.backgroundColor = [UIColor greenColor];
            [view addSubview:self.bigImage];
            view;
        });
    }
    return _backView;
}

- (UIImageView *)bigImage {
    if (!_bigImage) {
        _bigImage = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 50, 50)];
            imageView.image = [UIImage imageNamed:@"Publish_Normal"];
            imageView;
        });
    }
    return _bigImage;
}


@end
