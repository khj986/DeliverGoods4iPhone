//
//  AppDelegate.m
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/11/6.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"

#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AMapLocationServices sharedServices].apiKey = @"aa256f1f233dc9f4a4dfb46673753182";
    
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];   //设置通用背景颜色
    
    LoginViewController * loginVC = [[LoginViewController alloc]init];
    //        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    //        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:loginVC];
    self.window.rootViewController = loginVC;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
