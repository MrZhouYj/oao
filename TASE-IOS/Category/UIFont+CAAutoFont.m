//
//  UIFont+CAAutoFont.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/17.
//  Copyright © 2019 CA. All rights reserved.
//

#import "UIFont+CAAutoFont.h"
#import "NSObject+CASwizzle.h"

@implementation UIFont (CAAutoFont)

+(void)load
{
    [self swizzleClassMethod:@selector(fontWithName:size:) with:@selector(CA_FontWithName:size:)];
}

+ (UIFont *)CA_FontWithName:(NSString*)fontName size:(CGFloat)size{
    
    UIFont *font = [UIFont CA_FontWithName:fontName size:size*[UIScreen mainScreen].bounds.size.width/375.f];

    return font;
}


@end
