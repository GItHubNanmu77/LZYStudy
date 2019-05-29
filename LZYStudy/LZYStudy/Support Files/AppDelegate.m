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

@interface AppDelegate ()<UITabBarControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) LLCustomTabBarController *tabVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin){
        LLCustomTabBarController *tabVC = [[LLCustomTabBarController alloc] init];
        self.tabVC = tabVC;
        self.tabVC.delegate = self;
        self.window.rootViewController = self.tabVC;
    } else {
        LLLoginViewController *loginVC = [[LLLoginViewController alloc] init];
        LZYCustomBaseNavigationViewController *loginNav = [[LZYCustomBaseNavigationViewController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNav;
    }
   
    [self.window makeKeyAndVisible];
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
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
@end
