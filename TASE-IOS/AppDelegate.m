//
//  AppDelegate.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "AppDelegate.h"
#import "CATabbarController.h"
#import "CAFiringViewController.h"
#import "CAWelcomeViewController.h"
#import "CAAlertView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"App启动时间--%f",(CFAbsoluteTimeGetCurrent()-AppStartLaunchTime));
    });
    
    BOOL hasShowWelcome = [[CommonMethod readFromUserDefaults:@"hasShowWelcome"] boolValue];

    if (hasShowWelcome) {
        self.window.rootViewController = [CAFiringViewController new];
    }else{
        self.window.rootViewController = [CAWelcomeViewController new];
    }
    return YES;
}


-(void)applicationDidEnterBackground:(UIApplication *)application{
    [[CASocket shareSocket] closeConnect];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    
    [self checkUpdata];
}

#pragma mark 检查app版本

-(void)checkUpdata{
    
     [CANetworkHelper GET:CAAPI_CHECK_FOR_UPDATES parameters:nil success:^(id responseObject) {

         NSLog(@"%@",responseObject);
         
         //版本提示
         NSDictionary * latest_version = responseObject[@"latest_version"];
         if (latest_version) {
             NSString * localVersion = [CommonMethod readFromUserDefaults:@"versionLocal"];
             if (!localVersion||!localVersion.length) {
                 localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
             }
             NSString * version = latest_version[@"version"];
             NSComparisonResult result = [localVersion compare:version];
             if (result == NSOrderedAscending) {
                 //需要更新
                 BOOL is_forced_upgrade = [latest_version[@"is_forced_upgrade"] boolValue];
                 if (is_forced_upgrade) {
                     [CAAlertView showAlertWithTitle:@"" message:NSStringFormat(@"%@",latest_version[@"changelog"]) completionBlock:^(NSUInteger buttonIndex, CAAlertView * _Nonnull alertView) {
                         
                         if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:latest_version[@"url"]]]) {
                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:latest_version[@"url"]]];
                         }
                     } cancelButtonTitle:nil otherButtonTitles:CALanguages(@"更新"),nil];
                 }else{
                     [CAAlertView showAlertWithTitle:@"" message:NSStringFormat(@"%@",latest_version[@"changelog"]) completionBlock:^(NSUInteger buttonIndex, CAAlertView * _Nonnull alertView) {
                         
                         if (buttonIndex == 1) {

                             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:latest_version[@"url"]]]) {
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:latest_version[@"url"]]];
                             }

                         } else if (buttonIndex == 0) {

                             [CommonMethod writeToUserDefaults:version withKey:@"versionLocal"];
                         }
                         
                     } cancelButtonTitle:CALanguages(@"忽略") otherButtonTitles:CALanguages(@"更新"),nil];
                 }
             }
         }
         
     } failure:^(NSError *error) {
    
     }];
    
}



//禁止使用第三方键盘
-(BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier{

    return NO;
}

@end

