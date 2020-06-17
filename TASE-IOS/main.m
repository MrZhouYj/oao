//
//  main.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime AppStartLaunchTime;

int main(int argc, char * argv[]) {
    
    AppStartLaunchTime = CFAbsoluteTimeGetCurrent();
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
