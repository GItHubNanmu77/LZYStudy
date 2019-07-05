//
//  LLFaceCameraViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/7/3.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLFaceCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LZYSheetAlertManager.h"

@interface LLFaceCameraViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
//捕捉会话
@property(nonatomic,strong)AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//展示layer
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;
//保存屏幕中离开的人脸
@property(nonatomic,strong)NSMutableArray *leaveFaceArray;
//保存屏幕检测到脸对应的layer faceID 作为字典 key
@property(nonatomic,strong)NSMutableDictionary *faceLayerDic;

@property (nonatomic, strong) UIButton *changeButton;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIImageView *faceImageView;


@end

@implementation LLFaceCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        [[LZYSheetAlertManager sharedLZYSheetAlertManager] showAlert:self title:@"相机不支持模拟器" message:@"请切换到真机调试" handlerConfirmAction:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        //真机
        _isFirst = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startReading];
        });
        
    }

    [self.view addSubview:self.changeButton];
    [self.view addSubview:self.faceImageView];
    [self.view bringSubviewToFront:self.faceImageView];
    [self.view bringSubviewToFront:self.changeButton];
    
}


//摄像头数量
- (NSUInteger)cameraCounts {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}
//获取前置摄像头
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *deviceSelect = nil;
    if (self.cameraCounts > 1) {
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionFront) {
                
                deviceSelect = device;
            }
        }
    }
    
    return deviceSelect;
}
-(void)startReading{
    
    //读取摄像头授权状态
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        // 提示开启权限
        
        return;
    }
    
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [self inactiveCamera];
    
    
    //2.用captureDevice创建输入流,输入设备转换成AVCaptureDeviceInput对象
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!self.input) {
        NSLog(@"%@", [error localizedDescription]);
        
        return ;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //创建数据输出流
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    dataOutput.alwaysDiscardsLateVideoFrames = YES;
//     dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t sample = dispatch_queue_create("sample", NULL);
    [dataOutput setSampleBufferDelegate:self queue:sample];
    
    //4.实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //4.1.将输入设备添加到会话
    if ([self.captureSession canAddInput:self.input]) {
        
        [self.captureSession addInput:self.input];
    }
    //4.2.将媒体输出设备添加到会话
    if ([self.captureSession canAddOutput:captureMetadataOutput]) {
        
        [self.captureSession addOutput:captureMetadataOutput];
        
    }
    if ([self.captureSession canAddOutput:dataOutput]) {
        
        [self.captureSession addOutput:dataOutput];
        
    }
    
    NSArray *metaDataObjectTypes = @[AVMetadataObjectTypeFace];
    //4.3.摄像头在捕捉数据时,只会对人脸元数据感兴趣
    captureMetadataOutput.metadataObjectTypes = metaDataObjectTypes;
    
    //获得主队列,因为人脸检测用到硬件加速,而且很多任务都在主线程执行
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_queue_t meta = dispatch_queue_create("meta", NULL);
    //设置代理 主队列
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:mainQueue];
    
    NSString     *key           = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber     *value         =  @(kCVPixelFormatType_32BGRA);
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    
    [dataOutput setVideoSettings:videoSettings];
    
    //5.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    //6.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //7.设置图层的frame
    [_videoPreviewLayer setFrame:self.view.bounds];
    @LZY_weakify(self)
    [UIView animateWithDuration:2 animations:^{
        @LZY_strongify(self)
        [self.view.layer addSublayer:self.videoPreviewLayer];
    }];
    
    //开启会话
    [self.captureSession startRunning];
    
   
}

/**
 切换摄像头按钮的点击方法的实现（切换摄像头时可以添加转场动画）
 */
-(void)changeButtonAction{
    //获取摄像头的数量（该方法会返回当前能够输入视频的全部设备，包括前后摄像头和外接设备）
    NSInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头的数量小于等于1的时候直接返回
    if (cameraCount <= 1) {
        return;
    }
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向（前/后）
    AVCaptureDevicePosition position = [[self.input device] position];
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
        
    }else if (position == AVCaptureDevicePositionBack){
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    [self.videoPreviewLayer addAnimation:animation forKey:nil];
    
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newInput != nil) {
        [self.captureSession beginConfiguration];
        //先移除原来的input
        [self.captureSession removeInput:self.input];
        if ([self.captureSession canAddInput:newInput]) {
            [self.captureSession addInput:newInput];
            self.input = newInput;
        }else{
            //如果不能加现在的input，就加原来的input
            [self.captureSession addInput:self.input];
        }
        [self.captureSession commitConfiguration];
    }
    
}

-(AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSMutableArray *faceArray = [NSMutableArray arrayWithCapacity:10];
    
    //获取的人脸放到数组中
    
    for (AVMetadataFaceObject *face in metadataObjects) {
        
        //NSLog(@"faceID:%li",(long)face.faceID);
        // NSLog(@"face.bounds:%@",NSStringFromCGRect(face.bounds));
        
        //将摄像头捕捉的人脸位置转换到屏幕位置
        AVMetadataObject *tranformFace = [_videoPreviewLayer  transformedMetadataObjectForMetadataObject:face];
        
        [faceArray addObject:tranformFace];
    }
    
    //将获取的人脸数据进行处理
    [self faceOperation:faceArray];
    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
- (void)captureOutput:(AVCaptureOutput*)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection{
    [self imageFromSampleBuffer:sampleBuffer];
}


-(void)faceOperation:(NSArray *)faceArray{
    
    NSMutableArray *leaveFaceArray = [self.faceLayerDic.allKeys mutableCopy];
    
    for (AVMetadataFaceObject *face in faceArray) {
        
        NSNumber *faceID = @(face.faceID);
        [leaveFaceArray removeObject:faceID];
        
        @LZY_weakify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            @LZY_strongify(self)
            CALayer *layer = self.faceLayerDic[faceID];
            if(!layer){
                
                //makeFacelayer :新建一个人脸图层
                layer = [self makeFaceLayer];
                
                //将人脸图层添加到videoPreviewLayer
                
                [self.videoPreviewLayer addSublayer:layer];
                
                //将 layer加入字典中
                self.faceLayerDic[faceID] = layer;
            }
            //指定图层的位置
            layer.frame = face.bounds;
        });
       
        
    }
    
    for (NSNumber *faceID in leaveFaceArray) {
        CALayer *layer = self.faceLayerDic[faceID];
        [layer removeFromSuperlayer];
        [self.faceLayerDic removeObjectForKey:faceID];
        
    }
}

//显示图片，这里可以请求后台接口
-(void)uploadFaceImg:(UIImage *)image{
    self.faceImageView.image = image;
    
  @LZY_weakify(self)
    //这里设置为2秒后可以进行继续检测
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @LZY_strongify(self)
        self.isFirst = YES;
    });
}


//imageFromSampleBuffer:方法，将CMSampleBufferRef转为NSImage
- (void )imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    //CIImage -> CGImageRef -> UIImage
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);  //拿到缓冲区帧数据
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];            //创建CIImage对象
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];           //创建上下文
    
    //识别脸部
    CIDetector *detector=[CIDetector detectorOfType:CIDetectorTypeFace context:temporaryContext options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}]; //CIDetectorAccuracyLow：识别精度低，但识别速度快、性能高
    //CIDetectorAccuracyHigh：识别精度高、但识别速度比较慢
    NSArray *faceArray = [detector featuresInImage:ciImage
                                           options:nil];
    
    //得到人脸图片的尺寸
    if (faceArray.count) {
        NSLog(@"faceArray == %@",faceArray);
        @LZY_weakify(self)
        for (CIFaceFeature * faceFeature in faceArray) {
            if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition  && faceFeature.hasMouthPosition) {
                NSLog(@"_isFirst == %d",_isFirst);
                //这个布尔值用于判断检测到人脸后，获取到人脸照片，不用再进行持续检测
                if (_isFirst) {
                    //因为刚开始扫描到的人脸是模糊照片，所以延迟几秒获取
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @LZY_strongify(self)
                        CGImageRef cgImageRef = [temporaryContext createCGImage:ciImage fromRect:faceFeature.bounds];
                        
                        //resultImg即为获得的人脸图片
                        UIImage   *resultImg = [[UIImage alloc] initWithCGImage:cgImageRef scale:0.1 orientation:UIImageOrientationLeftMirrored];
                        
                        //显示人脸图片，这里可以将图片转为NSdata类型后，请求后台接口
                        [self uploadFaceImg:resultImg];
                        //置为NO
                        self.isFirst = NO;
                    });
                    
                }
            }
        }
    }
    
}

- (CALayer *)makeFaceLayer {
    CALayer *layer = [CALayer layer];
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor redColor].CGColor;
    return layer;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 500, 80, 50)];
        [_changeButton setTitle:@"切换" forState:UIControlStateNormal];
        [_changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeButton.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(18);
        _changeButton.backgroundColor =[UIColor blueColor];
        [_changeButton addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}

- (NSMutableDictionary *)faceLayerDic {
    if (!_faceLayerDic) {
        _faceLayerDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _faceLayerDic;
}

- (UIImageView*)faceImageView{
    if(!_faceImageView){
        _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width - 150, 0, 150, 150)];
        _faceImageView.backgroundColor = [UIColor orangeColor];
    }
    return _faceImageView;
}
@end
