//
//  CALoading.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CALoading : NSObject

+(void)startLoadingInView:(UIView*)view;

+(void)startLoading;

+(void)stopLoading;

@end
