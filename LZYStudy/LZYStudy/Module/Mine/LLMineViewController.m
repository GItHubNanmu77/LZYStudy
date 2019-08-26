//
//  LLMineViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLMineViewController.h"

#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"

#import "LZYCustomBaseNavigationViewController.h"
#import "LLLoginViewController.h"
#import "LLPdfReaderViewController.h"
#import "LLFaceCameraViewController.h"
#import "LLFaceImageViewController.h"
#import "LLFolderViewController.h"
#import "LLTipView.h"
#import "LLWebTableViewController.h"

#import "LZYDeviceUtils.h"

@interface LLMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UIButton *loginButton;


@end

@implementation LLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    
    NSString *deviceName = [LZYDeviceUtils name];
    NSString *sysName = [LZYDeviceUtils systemName];
    NSString *sysVer = [LZYDeviceUtils systemVersion];
    NSLog(@"deviceName:%@ -- systemName:%@ - systemVersion:%@",deviceName, sysName, sysVer);
   
    [self.view addSubview:self.table];
    [self.view addSubview:self.loginButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkUserNotificationEnable];
        });
    } else if (indexPath.row == 1) {
        LLPdfReaderViewController *vc = [[LLPdfReaderViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        LLFaceCameraViewController *vc = [[LLFaceCameraViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        LLFaceImageViewController *vc = [[LLFaceImageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4){
        LLTipView *tipView = [[LLTipView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        [tipView show];
    } else if (indexPath.row == 5){
        LLFolderViewController *vc = [[LLFolderViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LLWebTableViewController *vc = [[LLWebTableViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Getter & Setter
- (UITableView *)table {
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = self.loginButton;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _table;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"添加本地通知"];
        [_dataArray addObject:@"PDF阅读器"];
        [_dataArray addObject:@"人脸识别AVFoundation"];
        [_dataArray addObject:@"人脸识别CoreImage"];
        [_dataArray addObject:@"弹出view"];
        [_dataArray addObject:@"展开折叠label"];
        [_dataArray addObject:@"webTable"];
    }
    return _dataArray;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = ({
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 58)];
            button.showsTouchWhenHighlighted = YES;
            button.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(17.0);
            [button setTitleColor:RGB3(51) forState:UIControlStateNormal];
            [button setTitle:@"退出" forState:UIControlStateNormal];
            [button setBackgroundColor:RGB(100,181,245)];
            button.layer.cornerRadius = 4;
            [button bk_addEventHandler:^(id sender) {
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LLLoginViewController *loginVC = [[LLLoginViewController alloc]init];
                LZYCustomBaseNavigationViewController *loginNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:loginVC];
                [appDelegate.window setRootViewController:loginNav];
            } forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _loginButton;
}



//检查授权
- (void)checkUserNotificationEnable { // 判断用户是否允许接收通知
    if (@available(iOS 10.0, *)) {
        __block BOOL isOn = NO;
        @LZY_weakify(self)
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            @LZY_strongify(self)
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                NSLog(@"打开了通知");
                [self addLocalNotice];
            }else {
                isOn = NO;
                NSLog(@"关闭了通知");
                [self showAlertView];
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone){
            NSLog(@"关闭了通知");
            [self showAlertView];
        }else {
            NSLog(@"打开了通知");
        }
    }
}

- (void)addLocalNotice {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"测试标题";
        content.subtitle = @"测试通知副标题";
        // 内容
        content.body = @"测试通知的具体内容";
        // 声音
        // 默认声音
        //    content.sound = [UNNotificationSound defaultSound];
        // 添加自定义声音
        content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
        // 角标 （我这里测试的角标无效，暂时没找到原因）
        content.badge = @1;
        // 多少秒后发送,可以将固定的日期转化为时间
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:10] timeIntervalSinceNow];
        //        NSTimeInterval time = 10;
        // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
        
        /*
         //如果想重复可以使用这个,按日期
         // 周一早上 8：00 上班
         NSDateComponents *components = [[NSDateComponents alloc] init];
         // 注意，weekday默认是从周日开始
         components.weekday = 2;
         components.hour = 8;
         UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
         */
        // 添加通知的标识符，可以用于移除，更新等操作
        NSString *identifier = @"noticeId";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        // 发出推送的日期
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        // 推送的内容
        notif.alertBody = @"你已经10秒没出现了";
        // 可以添加特定信息
        notif.userInfo = @{@"noticeId":@"00001"};
        // 角标
        notif.applicationIconBadgeNumber = 1;
        // 提示音
        notif.soundName = UILocalNotificationDefaultSoundName;
        // 每周循环提醒
        notif.repeatInterval = NSCalendarUnitWeekOfYear;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

- (void)showAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"未获得通知权限，请前去设置" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goToAppSystemSetting];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
- (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}
@end
