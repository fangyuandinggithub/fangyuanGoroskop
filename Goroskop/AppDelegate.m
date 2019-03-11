//
//  AppDelegate.m
//  Goroskop
//
//  Created by NGE on 2018/12/13.
//  Copyright © 2018年 NGE. All rights reserved.
//

#import "AppDelegate.h"
#import "HoroscopesArtistHomeViewController.h"
#import "ConstellationDetailViewController.h"
#import "FortuneViewController.h"
#import "HoroscopesArtistPalmScanResultViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Firebase.h>
#import "PairViewController.h"
#import "ConstellationViewController.h"
//网络检测发送通知
#define DIDRECEIVENETIINFO [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNetInfo" object:nil userInfo:@{@"notiNetInfo":self.netWorkStateStr}];
@interface AppDelegate ()

@property (nonatomic, strong)NSString *netWorkStateStr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self saveImageData];
    });
    
    [self isConnectionAvailable];// 检测网络状况
    [self updateAnalyticsApp:application optional:launchOptions];
    HoroscopesArtistHomeViewController *home = [[HoroscopesArtistHomeViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = navi;

    
// self.window.rootViewController = [ConstellationViewController new];

    [self.window makeKeyAndVisible];
    return YES;
}


- (void)saveImageData{
    NSString *urlString = @"http://www.kiyjeoub.top/images/20181218/HoroscopesArtist/main.png";

    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"imageData"];

    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
    if (success){
        NSLog(@"写入本地成功");
    }

}
// 检测网络状况
-(void) isConnectionAvailable{
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status ==AFNetworkReachabilityStatusNotReachable) {
            weakSelf.netWorkStateStr = @"NO";
            DIDRECEIVENETIINFO
            
            
        } else {
            weakSelf.netWorkStateStr = @"YES";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self saveImageData];
            });
            DIDRECEIVENETIINFO
            
        }
    }];
    
}
- (void)updateAnalyticsApp:(UIApplication *)app optional:(NSDictionary *)optional{
    [FIRApp configure];
    [[FBSDKApplicationDelegate sharedInstance] application:app
                             didFinishLaunchingWithOptions:optional];
    
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
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


@end
