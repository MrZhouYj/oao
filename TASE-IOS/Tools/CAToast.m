
//
//  CAShowMessage.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/13.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAToast.h"
#import <Toast.h>
#import "AppDelegate.h"

@interface CAToast()

@end

@implementation CAToast

+(instancetype)defaultToast{
    
    static CAToast *toast = nil;
    if (!toast) {
        toast = [[CAToast alloc] init];
        
        CSToastStyle * style = [CSToastManager sharedStyle];
        style.cornerRadius = 2;
        
        [CSToastManager setDefaultPosition:CSToastPositionCenter];
        [CSToastManager setDefaultDuration:3];
        [CSToastManager setSharedStyle:style];
    }
    
    return toast;
}

-(void)showMessage:(NSString *)msg{
    if (msg.length) {
        [[AppDelegate shareAppDelegate].window makeToast:msg];
    }
}

@end
