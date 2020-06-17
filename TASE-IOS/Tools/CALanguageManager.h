//
//  CALanguageManager.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull const ENGLISH_english;
extern NSString * _Nonnull const CHINESE_Chinese;
extern NSString * _Nonnull const JAPANESE_Japanese;
extern NSString * _Nonnull const RUSSIAN_Russian;
extern NSString * _Nonnull const KOREAN_Korean;

extern NSString * _Nonnull const CALanguageDidChangeNotifacation;


NS_ASSUME_NONNULL_BEGIN
//en 英语 zh-Hans 简体中文 ko 韩语 ru-RU 俄语 ja-JP 日语
@interface CALanguageManager : NSObject

+ (NSBundle *)bundle;//获取当前资源文件

+ (void)initUserLanguage;//初始化语言文件

+ (NSString *)userLanguage;//获取应用当前语言

+ (NSString *)language;//获取应用当前语言 用于参数传递到服务器

+ (void)setUserLanguage:(NSString *)language;//设置当前语言

@end

NS_ASSUME_NONNULL_END
