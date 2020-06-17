//
//  CALanguageManager.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CALanguageManager.h"


 NSString * const ENGLISH_english = @"en";
 NSString * const CHINESE_Chinese = @"zh-Hans";
 NSString * const JAPANESE_Japanese = @"ja-JP";
 NSString * const RUSSIAN_Russian = @"ru-RU";
 NSString * const KOREAN_Korean = @"ko";
 NSString * const CALanguageDidChangeNotifacation = @"CALanguageDidChangeNotifacation";


@implementation CALanguageManager
static NSBundle *bundle = nil;
static NSString * userLanguageString = nil;

+ (NSBundle *)bundle {
    return bundle;
}

//首次加载时检测语言是否存在
+ (void)initUserLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    userLanguageString = [def valueForKey:@"LocalLanguageKey"];
    if (!userLanguageString) {
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        
        userLanguageString = preferredLanguages.firstObject;
        if ([userLanguageString hasPrefix:@"en"]) {
            userLanguageString = ENGLISH_english;
        }else if ([userLanguageString hasPrefix:@"zh"]) {
            userLanguageString = CHINESE_Chinese;
        }else if ([userLanguageString hasPrefix:@"ja"]) {
            userLanguageString = JAPANESE_Japanese;
        }else if ([userLanguageString hasPrefix:@"ru"]) {
            userLanguageString = RUSSIAN_Russian;
        }else if ([userLanguageString hasPrefix:@"ko"]) {
            userLanguageString = KOREAN_Korean;
        }else{
            userLanguageString = RUSSIAN_Russian;//设置默认语言
        }
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:userLanguageString ofType:@"lproj"];
    NSLog(@"%@",path);
    bundle = [NSBundle bundleWithPath:path];//生成bundle
    
}

//获取当前语言
+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"LocalLanguageKey"];
    if (language) {
        return language;
    }
    return userLanguageString;
}

+ (NSString *)language{
    
    NSString *lanuge = [self userLanguage];
    if ([lanuge isEqualToString:ENGLISH_english]) {
        return @"en";
    }else if ([lanuge isEqualToString:CHINESE_Chinese]){
        return @"zh";
    }else if ([lanuge isEqualToString:JAPANESE_Japanese]){
        return @"jp";
    }else if ([lanuge isEqualToString:RUSSIAN_Russian]){
        return @"ru";
    }else if ([lanuge isEqualToString:KOREAN_Korean]){
        return @"kr";
    }
    return @"ru";
}

//设置语言
+ (void)setUserLanguage:(NSString *)language {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:@"LocalLanguageKey"];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:@"LocalLanguageKey"];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];

    [[NSNotificationCenter defaultCenter] postNotificationName:CALanguageDidChangeNotifacation object:nil];
}
@end
