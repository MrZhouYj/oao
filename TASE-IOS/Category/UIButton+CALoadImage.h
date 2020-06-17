//
//  UIButton+CALoadImage.h
//  TASE-IOS
//
//  Created by ZEMac on 2020/2/10.
//  Copyright © 2020 CA. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CALoadImage)

-(void)loadSvgImage:(NSString*)imageUrl forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
