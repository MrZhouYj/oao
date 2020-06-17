//
//  CATabbarController.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAHomeViewController.h"
#import "CABBViewController.h"
#import "CAMarketViewController.h"
#import "CALegalViewController.h"
#import "CABaseNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CATabbarController : UITabBarController

+ (instancetype)shareTabbar;

@end

NS_ASSUME_NONNULL_END
