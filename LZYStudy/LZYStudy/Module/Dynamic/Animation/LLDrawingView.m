//
//  LLDrawingView.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/20.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLDrawingView.h"

@interface LLDrawingView ()
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation LLDrawingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(10 , 10, 40, 30)];
        [self.clearButton setTitle:@"清屏" forState:UIControlStateNormal];
        self.clearButton.backgroundColor = [UIColor redColor];
        [self.clearButton bk_addEventHandler:^(id sender) {
            [self.path removeAllPoints];
            ((CAShapeLayer *)self.layer).path = self.path.CGPath;
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clearButton];
        
        self.path = [UIBezierPath bezierPath];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
        
        //configure the layer
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }
    return self;
}

+ (Class)layerClass
{
    //this makes our view create a CAShapeLayer
    //instead of a CALayer for its backing layer
    return [CAShapeLayer class];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the starting point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //move the path drawing cursor to the starting point
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the current point
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //add a new line segment to our path
    [self.path addLineToPoint:point];
    
    //redraw the view
//    [self setNeedsDisplay];
    
    //update the layer with a copy of the path
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
    
}

//- (void)drawRect:(CGRect)rect
//{
//    //draw path
//    [[UIColor clearColor] setFill];
//    [[UIColor redColor] setStroke];
//    [self.path stroke];
//}


@end
