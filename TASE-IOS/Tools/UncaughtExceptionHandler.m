//
//  UncaughtExceptionHandler.m
//  TASE-IOS
//
//  Created by 周永建 on 2020/1/15.
//  Copyright © 2020 CA. All rights reserved.
//

#import "UncaughtExceptionHandler.h"

#define DocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@implementation UncaughtExceptionHandler

// 出现崩溃时的回调函数
void caughtExceptionHandler(NSException * exception)
{
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];  
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [DocumentDirectory stringByAppendingPathComponent:@"Exception.txt"];
// 将txt文件写入沙盒
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler(&caughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler
{
    return NSGetUncaughtExceptionHandler();
}


@end
