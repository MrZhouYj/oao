//
//  CADefined.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#ifndef CADefined_h
#define CADefined_h

// 屏幕宽度
#define MainWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define MainHeight [UIScreen mainScreen].bounds.size.height

//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//
//#define SCREEN_MAX_LENGTH MAX(MainWidth,MainHeight)
//
//#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

//#define CALanguages(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LocalLanguageKey"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]
#define CALanguages(key) [[CALanguageManager bundle] localizedStringForKey:(key) value:nil table:@"Localizable"]

//[CALanguageManager bundle]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) RGBA(r, g, b, 1)

//字体设置 start

//PingFangSC-Semibold
//PingFangSC-Medium
//PingFangSC-Light
//PingFangSC-Ultralight
//PingFangSC-Thin
//PingFangSC-Regular
//Roboto-Regular
//Roboto-Medium
#define AutoNumber(number)  MainWidth/414.f*number

#define ROBOTO_FONT_REGULAR_SIZE(fontSize) [UIFont fontWithName:@"Roboto-Regular" size:fontSize]
#define ROBOTO_FONT_MEDIUM_SIZE(fontSize) [UIFont fontWithName:@"Roboto-Medium" size:fontSize]

#define FONT_REGULAR_SIZE(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]

#define FONT_MEDIUM_SIZE(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]

#define FONT_SEMOBOLD_SIZE(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize]

//字体设置  end

#define IMAGE_NAMED(name) [UIImage imageNamed:name]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define SafeAreaTopHeight ((MainHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 24 : 0)
#define SafeAreaBottomHeight ((MainHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 34 : 0)
#define SafeKLineBottomHeight ((MainHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 15 : 0)
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define KTopRevise kTopHeight-64

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;

#define kApplication        [UIApplication sharedApplication]
//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define HexRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HexRGBA(rgbValue,alp) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]

#define   PATH_DOCUMENT                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//全局提示信息
#define Toast(msg)  [[CAToast defaultToast] showMessage:msg]

// 防止多次调用
#define CAPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \

//cg/usdt ask/bid
typedef enum {
    TradingBuy=1,//买盘
    TradingSell//卖盘
}TradingType;

typedef enum {
    KLineTypeTimeMore = 1,//更多
    KLineTypeTimeIndex,//指标
    KLineTypeTimeLine,//分时
    KLineType1Min,
    KLineType5Min,
    KLineType15Min,
    KLineType30Min,
    KLineType1Hour,
    KLineType1Day,
    KLineType1Week,
    KLineType1Month,
}Y_KLineType;


//#ifdef DEBUG
//#define NSLog(...) printf("➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\n %s [第%d行]: %s\n", __PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
//#else
//#define NSLog(...)
//#endif

#define LocalLanguage [CALanguageManager language]

#define ABOUT_US_URL  @"aboutus"
#define CONTACT_US_URL  @"contactus"

#define kApiKey @"FapKF0hrk84iFr_EwAlYvFD_Cyf5sv6v"
#define kApiSecret @"5mkpAqAhFB2SS3jiw9-0GGmX-bjFB7ze"


#endif /* CADefined_h */

