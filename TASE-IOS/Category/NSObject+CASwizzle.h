//
//  NSObject+CASwizzle.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/17.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CASwizzle)

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;


@end

NS_ASSUME_NONNULL_END
