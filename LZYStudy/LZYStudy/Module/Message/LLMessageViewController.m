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
#import "LLMessageTableViewCell.h"

@interface LLMessageViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *dataTableView;

@property (nonatomic, strong) UIImagePickerController *pickerController;
@end

@implementation LLMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [self setupTheTableView];
}

#pragma mark - UITableViewDataSource
- (void)setupTheTableView {
    self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, LZY_SCREEN_WIDTH, self.view.height - LZY_IPHONE_NAV_HEIGHT - 42.0)];
    self.dataTableView.backgroundColor = RGB3(255);
    self.dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    self.dataTableView.contentInset = LZY_VIEW_CONTENT_INSETS_MAKE;
    self.dataTableView.scrollIndicatorInsets = LZY_VIEW_CONTENT_INSETS_MAKE;
    self.dataTableView.rowHeight = 50;
    [self.view addSubview:self.dataTableView];
    
    [self.dataTableView registerClass:[LLMessageTableViewCell class] forCellReuseIdentifier:[LLMessageTableViewCell cellIdentifier]];
    
    if (@available(iOS 11.0, *)) {
        self.dataTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



#pragma mark - Override Methods

#pragma mark - Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLMessageTableViewCell *cell = (LLMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[LLMessageTableViewCell cellIdentifier]];
    
    
    if (indexPath.row == 2) {
        [cell setCustomLeftSeparator:20];
    }
    if(indexPath.row == 3) {
        [cell setCustomSeparator];
        [cell setCustomLeftSeparator:40];
    }
    if (indexPath.row == 4) {
        cell.showBottomSeparator = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0) {
        [[LZYSheetAlertManager sharedLZYSheetAlertManager]  showActionSheet:self message:nil sheets:@[@"相机",@"相册"] handlerConfirmAction:^(NSInteger sheetTag) {
            if(sheetTag == 0) {
                [MBProgressHUD showWarnMessage:@"相机"];
            } else {
                [MBProgressHUD showWarnMessage:@"相册"];
            }
        }];
    } else if (indexPath.row == 1){
        [[LZYSheetAlertManager sharedLZYSheetAlertManager] showAlert:self title:@"警告" message:@"确定删除吗？" handlerConfirmAction:^{
            [MBProgressHUD showWarnMessage:@"警告"];
        }];
    } else if (indexPath.row == 2) {
        [MBProgressHUD showWarnMessage:@"警告"];
    } else if(indexPath.row == 3) {
        [MBProgressHUD showErrorMessage:@"错误"];
    } else {
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
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


@end
