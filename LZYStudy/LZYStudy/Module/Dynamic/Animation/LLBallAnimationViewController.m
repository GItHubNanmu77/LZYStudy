//
//  LLBallAnimationViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/20.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLBallAnimationViewController.h"

@interface LLBallAnimationViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIImageView *ballView1;
@property (nonatomic, strong) UIImageView *ballView2;
@property (nonatomic, strong) UIImageView *ballView3;
//@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, assign) NSTimeInterval duration;
//@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval timeOffset;
@property (nonatomic, assign) CFTimeInterval lastStep;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LLBallAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT * 2);
    [self.view addSubview:self.scrollView];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 450, 60, 40)];
    self.startButton.backgroundColor = [UIColor redColor];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.startButton];
    
  
    
    [self createBallView];
}



- (void)createBallView {
    UIImage *ballImage = [UIImage imageNamed:@"ball.png"];
    self.ballView1 = [[UIImageView alloc] initWithImage:ballImage];
    self.ballView1.frame = CGRectMake(100, 64, 100, 100);
    [self.scrollView addSubview:self.ballView1];
    //animate
    [self animate];
    
    UIImage *ballImage2 = [UIImage imageNamed:@"ball2.png"];
    self.ballView2 = [[UIImageView alloc] initWithImage:ballImage2];
    self.ballView2.frame = CGRectMake(200, 64, 100, 100);
    [self.scrollView addSubview:self.ballView2];
    //animate
    [self animate2];
    
    UIImage *ballImage3 = [UIImage imageNamed:@"ball3.png"];
    self.ballView3 = [[UIImageView alloc] initWithImage:ballImage3];
    self.ballView3.frame = CGRectMake(300, 64, 100, 100);
    [self.scrollView addSubview:self.ballView3];
    //animate
    [self animate3];
}

- (void)startAnimation {
    [self animate];
    [self animate2];
    [self animate3];
}

#pragma mark - 第一种
float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

- (void)animate
{
    //reset ball to top of screen
    self.ballView1.center = CGPointMake(100, 64);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 64)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(100, 300)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = frames;
    //apply animation
    [self.ballView1.layer addAnimation:animation forKey:nil];
}

#pragma mark - 第二种

float quadraticEaseInOut(float t)
{
    return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
}
float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

- (void)animate2
{
    //reset ball to top of screen
    self.ballView2.center = CGPointMake(200, 64);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(200, 64)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(200, 300)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1/(float)numFrames * i;
        //apply easing
        time = bounceEaseOut(time);
        //add keyframe
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = frames;
    //apply animation
    [self.ballView2.layer addAnimation:animation forKey:nil];
}

#pragma mark - 第三种

//- (void)animate3
//{
//    //reset ball to top of screen
//    self.ballView3.center = CGPointMake(320, 64);
//    //configure the animation
//    self.duration = 1.0;
//    self.timeOffset = 0.0;
//    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(320, 64)];
//    self.toValue = [NSValue valueWithCGPoint:CGPointMake(320, 300)];
//    //stop the timer if it's already running
//    [self.timer invalidate];
//    //start the timer
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0
//                                                  target:self
//                                                selector:@selector(step:)
//                                                userInfo:nil
//                                                 repeats:YES];
//}
//
//- (void)step:(NSTimer *)step
//{
//    //update time offset
//    self.timeOffset = MIN(self.timeOffset + 1/60.0, self.duration);
//    //get normalized time offset (in range 0 - 1)
//    float time = self.timeOffset / self.duration;
//    //apply easing
//    time = bounceEaseOut(time);
//    //interpolate position
//    id position = [self interpolateFromValue:self.fromValue
//                                     toValue:self.toValue
//                                        time:time];
//    //move ball view to new position
//    self.ballView3.center = [position CGPointValue];
//    //stop the timer if we've reached the end of the animation
//    if (self.timeOffset >= self.duration) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}

#pragma mark - 第四种

- (void)animate3
{
    //reset ball to top of screen
    self.ballView3.center = CGPointMake(300, 64);
    //configure the animation
    self.duration = 1.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(300, 64)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    //stop the timer if it's already running
    [self.timer invalidate];
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
    
//     NSDefaultRunLoopMode - 标准优先级
//    NSRunLoopCommonModes - 高优先级
//    UITrackingRunLoopMode - 用于UIScrollView和别的控件的动画
//    同样可以同时对CADisplayLink指定多个runloop模式，
//    于是我们可以同时加入NSDefaultRunLoopMode和UITrackingRunLoopMode来保证它不会被滑动打断，也不会被其他UIKit控件动画影响性能，
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void)step:(CADisplayLink *)timer
{
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    //update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView3.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
