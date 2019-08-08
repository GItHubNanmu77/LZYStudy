//
//  AppDelegate.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/19.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "AppDelegate.h"
#import "LLCustomTabBarController.h"
#import "LLLoginViewController.h"
#import "LZYCustomBaseNavigationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "LZYSheetAlertManager.h"

@interface AppDelegate ()<UITabBarControllerDelegate, UIDocumentInteractionControllerDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) LLCustomTabBarController *tabVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerAPN];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin){
        LLCustomTabBarController *tabVC = [[LLCustomTabBarController alloc] init];
        self.tabVC = tabVC;
        self.tabVC.selectedIndex = 1;
        self.tabVC.delegate = self;
        self.window.rootViewController = self.tabVC;
//        self.tabVC.selectedIndex = 0;
        [self performSelector:@selector(selectFirstIndex) withObject:nil afterDelay:0];
    } else {
        LLLoginViewController *loginVC = [[LLLoginViewController alloc] init];
        LZYCustomBaseNavigationViewController *loginNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNav;
    }
   
    [self.window makeKeyAndVisible];
    
    if (@available(iOS 10.0, *)) {
        [self receiveNotificationWithOptions:launchOptions];
    } else {
        // Fallback on earlier versions
    }
    return YES;
}
//过渡动画
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    //apply transition to tab bar controller's view
    [self.tabVC.view.layer addAnimation:transition forKey:nil];
}

- (void)selectFirstIndex {
    self.tabVC.selectedIndex = 0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self checkPasteboard];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)checkPasteboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSArray *stringArr = pasteboard.strings;
    NSLog(@"--%@",stringArr);
    NSString *sharedString = pasteboard.string;
    
    if ([sharedString containsString:@"123123"]) {
        NSLog(@"==%@",sharedString);
        [[LZYSheetAlertManager sharedLZYSheetAlertManager] showAlert:[self mostTopViewController] title:@"口令" message:sharedString handlerConfirmAction:^{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        }];
        pasteboard.string = @"";
    }
}
/** 文档导入 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (self.window) {
        if (url) {
//            _docUrl = url;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir_Str = [paths objectAtIndex:0];
            NSString *pathStr = [docDir_Str stringByAppendingString:@"/localFile"];
            NSFileManager * fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:pathStr]){
                //如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
                NSString *directryPath = [docDir_Str stringByAppendingPathComponent:@"localFile"];
                [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            
            //提醒视图: UIActionSheet
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否需要保存文档？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil];
            [actionSheet showInView:self.window.rootViewController.view];
            
            
            //在NSUserDefaults里：保存“从文档进入App”为YES
//            [User_Def setBool:YES forKey:JoinAPPFromDocumVC];
//            [User_Def synchronize];
            
            //跳转，查看文档
            UIDocumentInteractionController *documentController =  [UIDocumentInteractionController interactionControllerWithURL:url];
            documentController.delegate = self;
            [documentController presentPreviewAnimated:YES];//跳转到查看页面
        }
    }
    return YES;
}
#pragma mark - UIDocumentInteractionControllerDelegate
-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self.window.rootViewController;
}
-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.window.rootViewController.view;
}
-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return self.window.rootViewController.view.bounds;
}

// 注册通知
- (void)registerAPN {
    
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    NSLog(@"点击本地%@",dic);
    NSLog(@"本地通知 %ld",(long)application.applicationState );
    // 用户在前台
    if (application.applicationState == UIApplicationStateInactive ) {
        NSDictionary *dic = notification.userInfo;
//        [self remoteNotificationWith:[dic objectForKey:@"payload"] ];
        NSLog(@"在前台");
        self.tabVC.selectedIndex = 2;
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            //后台状态下，直接跳转到跳转页面。
            NSLog(@"在后台");
        self.tabVC.selectedIndex = 1;
    }
    
}


//点击本地推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response   withCompletionHandler:(void(^)())completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"********** iOS10.0之后  **********");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [GeTuiSdk resetBadge];
    NSDictionary * userInfo =    response.notification.request.content.userInfo;
    
    NSLog(@"userInfo=%@ %@",userInfo , [userInfo[@"payload"] class]);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
    }
    //后台状态下，直接跳转到跳转页面。
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        
    }
    if (@available(iOS 10.0, *)) {
        // 系统要求执行这个 方法
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

// APP被杀死在didfinishLaunch里面处理
- (void)receiveNotificationWithOptions:(NSDictionary *)launchOptions API_AVAILABLE(ios(10.0)){
    if (launchOptions) {
        if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {// 远程
            NSLog(@"点击推送。从、啊app后台进去");
        } else if (launchOptions [UIApplicationLaunchOptionsLocalNotificationKey]) { //本地
            UILocalNotification *noti = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
            NSDictionary *dic =  noti.userInfo;
            self.tabVC.selectedIndex = 1;
        }
    }
}

// 移除某一个指定的通知
- (void)removeOneNotificationWithID:(NSString *)noticeId {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *req in requests){
                NSLog(@"存在的ID:%@\n",req.identifier);
            }
            NSLog(@"移除currentID:%@",noticeId);
        }];
        
        [center removePendingNotificationRequestsWithIdentifiers:@[noticeId]];
    }else {
        NSArray *array=[[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *localNotification in array){
            NSDictionary *userInfo = localNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"noticeId"];
            if ([obj isEqualToString:noticeId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}

// 移除所有通知
- (void)removeAllNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

/**
 *  获取最上层的控制器
 *
 *  @return <#return value description#>
 */
- (UIViewController *)mostTopViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
