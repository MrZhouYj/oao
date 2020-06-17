//
//  UIButton+CALoadImage.m
//  TASE-IOS
//
//  Created by ZEMac on 2020/2/10.
//  Copyright © 2020 CA. All rights reserved.
//

#import "UIButton+CALoadImage.h"
#import <SVGKit.h>

@implementation UIButton (CALoadImage)

-(void)loadSvgImage:(NSString*)imageUrl forState:(UIControlState)state{
    if (imageUrl.length&&imageUrl) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            SVGKImage * image = [SVGKImage imageNamed:imageUrl];
            dispatch_main_async_safe(^{
                [self setImage:image.UIImage forState:state];
            });
        });
    }
}

@end
