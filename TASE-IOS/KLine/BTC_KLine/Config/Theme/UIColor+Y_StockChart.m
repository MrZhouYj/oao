//
//  UIColor+Y_StockChart.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "UIColor+Y_StockChart.h"

@implementation UIColor (Y_StockChart)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark 所有图表的背景颜色
+(UIColor *)backgroundColor
{
    return [UIColor whiteColor];
}

#pragma mark 辅助背景色
+(UIColor *)assistBackgroundColor
{
    return [UIColor colorWithRGBHex:0x1d2227];
}

#pragma mark 涨的颜色
+(UIColor *)increaseColor
{
   return RGB(46, 193, 119);
}

#pragma mark 跌的颜色
+(UIColor *)decreaseColor
{
    return RGB(255,110,117);
}

#pragma mark 主文字颜色
+(UIColor *)mainTextColor
{
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark 辅助文字颜色
+(UIColor *)assistTextColor
{
    return [UIColor colorWithRGBHex:0x627C9E];
}

#pragma mark 分时线下面的成交量线的颜色
+(UIColor *)timeLineVolumeLineColor
{
    return [UIColor colorWithRGBHex:0x2d333a];
}

#pragma mark 分时线界面线的颜色
+(UIColor *)timeLineLineColor
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor
{
    return [UIColor colorWithRGBHex:0xe1e2e6];
}

#pragma mark ma5的颜色
+(UIColor *)ma7Color
{
    return [UIColor colorWithRGBHex:0xff783c];
}

#pragma mark ma30颜色
+(UIColor *)ma30Color
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark BOLL_MB的颜色
+(UIColor *)BOLL_MBColor
{
    return [UIColor colorWithRGBHex:0xf5a623];
}

#pragma mark BOLL_UP的颜色
+(UIColor *)BOLL_UPColor
{
    return [UIColor purpleColor];
}

#pragma mark BOLL_DN的颜色
+(UIColor *)BOLL_DNColor
{
    return [UIColor greenColor];
}

+(UIColor *)colorWithHexString:(NSString *)color{
  
        NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        
        if ([cString length] < 6)
        {
            return [UIColor clearColor];
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if ([cString hasPrefix:@"0X"])
        {
            cString = [cString substringFromIndex:2];
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if ([cString hasPrefix:@"#"])
        {
            cString = [cString substringFromIndex:1];
        }
        if ([cString length] != 6)
        {
            return [UIColor clearColor];
        }
        
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        //r
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1];
    
}

@end
