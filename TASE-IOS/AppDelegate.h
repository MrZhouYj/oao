//
//  AppDelegate.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CFAbsoluteTime AppStartLaunchTime;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate* )shareAppDelegate;

@end

