//
//  UIImageView+CALoadImage.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "UIImageView+CALoadImage.h"
#import <SVGKit.h>

@implementation UIImageView (CALoadImage)

-(void)loadImage:(NSString*)imageUrl{
    
    if (imageUrl.length&&imageUrl) {
        if ([imageUrl hasSuffix:@"svg"]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                if (data.length) {
                    SVGKImage * image = [SVGKImage imageWithData:data];
                    dispatch_main_async_safe(^{
                        self.image = image.UIImage;
                    });
                }else{
                    NSLog(@"加载图片失败 %@",imageUrl);
                }
                
            });
        }else{
            [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
    }
}

@end
