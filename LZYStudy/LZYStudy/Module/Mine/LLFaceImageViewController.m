//
//  LLFaceImageViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/7/4.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLFaceImageViewController.h"

@interface LLFaceImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation LLFaceImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.startButton];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_WIDTH);
    self.startButton.frame = CGRectMake((LZY_SCREEN_WIDTH - 80)/2, self.imageView.bottom + 50, 80, 44);
}

#pragma mark - 识别人脸
- (void)faceDetectWithImage {
    
    for (UIView *view in _imageView.subviews) {
        [view removeFromSuperview];
    }
    [SVProgressHUD show];
    // 图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择，因为想让准确度高一些在这里选择CIDetectorAccuracyHigh
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 将图像转换为CIImage
    CIImage *faceImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    // 得到图片的尺寸
    CGSize inputImageSize = [faceImage extent].size;
    //将image沿y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    // 取出所有人脸
    for (CIFaceFeature *faceFeature in features){
        //获取人脸的frame
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        CGSize viewSize = _imageView.bounds.size;
        CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                            viewSize.height / inputImageSize.height);
        CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
        CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
        // 缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        // 修正
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        
        //描绘人脸区域
        UIView* faceView = [[UIView alloc] initWithFrame:faceViewBounds];
        faceView.layer.borderWidth = 2;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        [_imageView addSubview:faceView];
        
        // 判断是否有左眼位置
        if(faceFeature.hasLeftEyePosition){
            NSLog(@"%f--%f",faceFeature.leftEyePosition.x,faceFeature.leftEyePosition.y);
        }
        // 判断是否有右眼位置
        if(faceFeature.hasRightEyePosition){
             NSLog(@"%f--%f",faceFeature.rightEyePosition.x,faceFeature.rightEyePosition.y);
        }
        // 判断是否有嘴位置
        if(faceFeature.hasMouthPosition){
             NSLog(@"%f--%f",faceFeature.mouthPosition.x,faceFeature.mouthPosition.y);
        }
    }
    NSString *result = [NSString stringWithFormat:@"识别出了%ld张脸", features.count];
    NSLog(@"%@",result);
    [SVProgressHUD showSuccessWithStatus:result];
}

- (UIImageView*)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"我用苍老疼爱你.jpg" ofType:nil];
        _imageView.image = [UIImage imageWithContentsOfFile:filePath];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)startButton {
    if (!_startButton) {
        @LZY_weakify(self)
        _startButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_startButton setTitle:@"开始识别" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startButton.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(18);
        _startButton.backgroundColor = [UIColor redColor];
        [_startButton bk_addEventHandler:^(id sender) {
            @LZY_strongify(self)
            [self faceDetectWithImage];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}
@end
