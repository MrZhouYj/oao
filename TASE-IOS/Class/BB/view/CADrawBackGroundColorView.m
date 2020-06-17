//
//  CADrawBackGroundColorView.m
//  TASE-IOS
//
//   9/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CADrawBackGroundColorView.h"

@implementation CADrawBackGroundColorView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bgRect = CGRectZero;
    UIColor * bgColor = nil;
    
    if (self.dir==BackgroundDireactionNone) {
        return;
    }

    if (self.dir==BackgroundDireactionLeftToRight) {
        bgRect = CGRectMake(0, 0, self.width*self.scaleDeep, self.height);
    }else if (self.dir==BackgroundDireactionRightToLeft){
        bgRect = CGRectMake(self.width*(1-self.scaleDeep), 0, self.width*self.scaleDeep, self.height);
    }
    
    if (self.type==TradingBuy) {
        //买盘
        bgColor = HexRGB(0xe6fcf1);
        
    }else if(self.type==TradingSell){
        bgColor =  HexRGB(0xfef1f3);
    }else{
        //未设置
    }
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:bgRect];
    [bgColor set];
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
}

-(void)setscaleDeep:(CGFloat)scaleDeep{
    _scaleDeep = scaleDeep;
    NSLog(@"设置新的值为  %f",scaleDeep);
    [self setNeedsDisplay];
}

-(void)setType:(TradingType)type{
    _type = type;
    [self setNeedsDisplay];
}

@end
