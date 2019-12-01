//
//  LLDrawingViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/20.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLDrawingViewController.h"

#import "LLDrawingView.h"

@interface LLDrawingViewController ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIView *paintingView;

@property (nonatomic, strong) LLDrawingView *drawingView;
@end

@implementation LLDrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.drawingView = [[LLDrawingView alloc] initWithFrame:CGRectMake(0, LZY_IPHONE_NAV_STATUS_HEIGHT, LZY_SCREEN_WIDTH, 400)];
    self.drawingView.backgroundColor = RGB3(240);
    [self.view addSubview:self.drawingView];
    
//    [self.view addSubview:self.paintingView];
    
    self.path = [UIBezierPath bezierPath];
    self.path.lineJoinStyle = kCGLineJoinRound;
    self.path.lineCapStyle = kCGLineCapRound;
    self.path.lineWidth = 5;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self.paintingView];
    
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self.paintingView];
    
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    
    //redraw the view
    [self.paintingView setNeedsDisplay];
    [[UIColor clearColor] setFill];
    [[UIColor redColor] setStroke];
    [self.path stroke];
}

- (void)drawRect:(CGRect)rect
{
    //draw path
    [[UIColor clearColor] setFill];
    [[UIColor redColor] setStroke];
    [self.path stroke];
}


- (UIView*)paintingView{
    if(!_paintingView){
        _paintingView = [[UIView alloc] initWithFrame:CGRectMake(0, LZY_IPHONE_NAV_STATUS_HEIGHT, LZY_SCREEN_WIDTH, 400)];
        _paintingView.backgroundColor = RGB3(240);
    }
    return _paintingView;
}

@end
