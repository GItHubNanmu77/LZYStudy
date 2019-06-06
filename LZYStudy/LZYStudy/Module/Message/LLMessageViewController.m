//
//  LLMessageViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMessageViewController.h"
#import "LZYAuthorizationUtils.h"
#import "LZYSheetAlertManager.h"
#import "LLMessagePhotoCollectionViewCell.h"
#import "LLPhotosWaterFlowLayout.h"

@interface LLMessageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate,  WaterFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, strong) UIImagePickerController *pickerController;
@end

@implementation LLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.collView];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"增加"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    rightButton.tintColor = RGB3(51);
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)rightBtnAction:(UIBarButtonItem*)sender{
    NSLog(@"右上角按钮点击");
    [self choosePhotos];
}

#pragma mark - Override Methods
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collView.frame = CGRectMake(0, 0, LZY_SCREEN_WIDTH, self.view.height);
}
#pragma mark - Delegate Methods
// 实现代理方法返回每一个item的高度
- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = self.dataArray[indexPath.row];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 40) / 3;
    // 计算item高度
    CGFloat height = image.size.height / image.size.width * width;
    return height;
}

#pragma mark - UICollectionViewDataSource + UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLMessagePhotoCollectionViewCell *cell = (LLMessagePhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LLMessagePhotoCollectionViewCell" forIndexPath:indexPath];
    
    [cell updateData:self.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
}

- (UICollectionView *)collView {
    if (!_collView) {
        _collView = ({
            LLPhotosWaterFlowLayout *layout = [[LLPhotosWaterFlowLayout alloc] init];
            layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            layout.numberOfColumn = 3;
            CGFloat w = (LZY_SCREEN_WIDTH - 40 )/ 3;
            layout.itemSize = CGSizeMake(w, w);
            layout.spacing = 10;
            layout.delegate = self;
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.backgroundColor = RGB3(255);
            //            collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerClass:[LLMessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"LLMessagePhotoCollectionViewCell"];
            collectionView.userInteractionEnabled = YES;
            
            collectionView;
        });
    }
    return _collView;
}

- (void)choosePhotos{
   
        @LZY_weakify(self)
        [[LZYSheetAlertManager sharedLZYSheetAlertManager] showSelectPicSourceActionSheet:self handlerCameraPicker:^{
            @LZY_strongify(self)
            [LZYAuthorizationUtils openCaptureDeviceServiceWithBlock:^(BOOL isOpen) {
                if (isOpen) {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:self.pickerController animated:YES completion:^{
                                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
                            }];
                        });
                    }
                } else {
                    [[LZYSheetAlertManager sharedLZYSheetAlertManager] showSettingAlert:self deviceName:@"相机"];
                }
            }];
        } handlerAlbumPicker:^{
            @LZY_strongify(self)
            [LZYAuthorizationUtils openAlbumServiceWithBlock:^(BOOL isOpen) {
                if (isOpen) {
                    TZImagePickerController *tzPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
                    tzPicker.delegate = self;
                    [self presentViewController:tzPicker animated:YES completion:nil];
                    
//                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//                        self.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self presentViewController:self.pickerController animated:YES completion:^{
//
//                            }];
//                        });
//                    }
                } else {
                    [[LZYSheetAlertManager sharedLZYSheetAlertManager] showSettingAlert:self deviceName:@"相册"];
                }
            }];
        } handlerCancel:^{
            
        }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self.dataArray addObjectsFromArray:photos];
    [self.collView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)pickerController{
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc]init];
        _pickerController.delegate = self;
        _pickerController.allowsEditing = YES;
    }
    return _pickerController;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
