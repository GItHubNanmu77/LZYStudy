//
//  LLGravityViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/9/26.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLGravityViewController.h"

@interface LLGravityViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *ballView;
@end

@implementation LLGravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ballView];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    [self testGravity];
}

- (void)testGravity{
    // 1 重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.ballView]];
    gravity.action = ^{
        NSLog(@"%f",self.ballView.y);
    };
    [self.animator addBehavior:gravity];
    
    //2 碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.ballView]];
    [collision addBoundaryWithIdentifier:@"ball" fromPoint:CGPointMake(0, LZY_SCREEN_HEIGHT-120) toPoint:CGPointMake(LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT-100)];
    [self.animator addBehavior:collision];
}

- (UIView *)ballView {
    if (!_ballView) {
        _ballView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - 60)/2, 80, 60, 60)];
            view.backgroundColor = [UIColor redColor];
            view.layer.cornerRadius = 30;
            view.layer.masksToBounds = YES;
            view;
        });
    }
    return _ballView;
}
@end
