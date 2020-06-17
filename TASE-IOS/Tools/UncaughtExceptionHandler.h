//
//  UncaughtExceptionHandler.h
//  TASE-IOS
//
//  Created by 周永建 on 2020/1/15.
//  Copyright © 2020 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;

+ (NSUncaughtExceptionHandler *)getHandler;

@end

NS_ASSUME_NONNULL_END
