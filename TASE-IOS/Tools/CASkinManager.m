//
//  CASkinManager.m
//  TASE-IOS
//
//   9/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASkinManager.h"

@implementation CASkinManager

+(void)initSkin{
    
    [DKColorTable sharedColorTable].file = @"AppTheme.txt";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DKThemeVersion * skinVersion = [userDefaults valueForKey:@"skinVersion"];
    
    if (skinVersion) {
        [DKNightVersionManager sharedManager].themeVersion = skinVersion;
    }
    
}

+(DKThemeVersion*)getCurrentSkinType{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DKThemeVersion * skinVersion = [userDefaults valueForKey:@"skinVersion"];
    if (skinVersion) {
        return skinVersion;
    }
    return DKThemeVersionNormal;
}

+(void)setSkin:(DKThemeVersion*)version{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DKThemeVersion * currentVersion = [userDefaults valueForKey:@"skinVersion"];
    
    if ([currentVersion isEqualToString:version]) {
        return;
    }
    [DKNightVersionManager sharedManager].themeVersion = version;
    [userDefaults setValue:version forKey:@"skinVersion"];
    [userDefaults synchronize];
    
}

@end
