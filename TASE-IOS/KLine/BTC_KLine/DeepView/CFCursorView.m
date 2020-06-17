//
//  CFCursorView.m
//  CCLineChart
//
//  Created by ZM on 2018/9/14.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import "CFCursorView.h"

@implementation CFCursorView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = 3;
    
    CGFloat arcX = self.selectedPoint.x  > radius ? self.selectedPoint.x : radius;
    
    if (radius > self.selectedPoint.x ) {
        arcX = radius;
    }
    CGFloat arcY = self.selectedPoint.y > radius ? self.selectedPoint.y : radius;
    //画圆。
    
    NSLog(@"  %@",NSStringFromCGPoint(self.selectedPoint));
    
    switch (self.type) {
        case TradingSell:
            [[UIColor decreaseColor] set];
            break;
        case TradingBuy:
            [[UIColor increaseColor] set];
            break;
            
        default:
            break;
    }
    
    CGContextAddArc(ctx, arcX, arcY, radius, 0, 4 * M_PI, 0);
    CGContextFillPath(ctx);
    
    CGContextAddArc(ctx, arcX, arcY , 8, 0, 4 * M_PI, 0);
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokePath(ctx);
    
//
//    // 画提示框
//    CGContextSetStrokeColorWithColor(ctx,  [UIColor colorWithRed:38/255.0 green:43/255.0 blue:65/255.0 alpha:1].CGColor);
//    CGContextSetLineWidth(ctx, 0.5);
//    CGFloat originX = arcX - 110;
//    CGFloat originY = arcY - radius;
//
//    if (originX < 0) {
//        originX = 2*radius + self.selectedPoint.x ;
//    }
//
//    CGContextStrokeRect(ctx, CGRectMake(originX, originY, 110, 50));
//
//    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:38/255.0 green:43/255.0 blue:65/255.0 alpha:1].CGColor);
//    CGContextFillRect(ctx, CGRectMake(originX, originY, 110, 50));
//
//    NSString *priceString = [NSString stringWithFormat:@"委托价:%f",[self.selectModel[0] doubleValue]];
//    NSString *volumeString = [NSString stringWithFormat:@"累计:%f",[self.selectModel[1] doubleValue]];
//    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorWithRed:96/255.0 green:103/255.0 blue:135/255.0 alpha:1.0f]};
//
//    CGSize priceSize = [self rectOfNSString:priceString attribute:attribute].size;
//    CGSize volumeSize = [self rectOfNSString:volumeString attribute:attribute].size;
//
//    CGFloat stringY = (50 - priceSize.height - volumeSize.height - 5)/2 + originY;
//    CGFloat priceStringX = (110 - priceSize.width)/2 + originX;
//    CGFloat volumeStringX = (110 - volumeSize.width)/2 + originX;
//    [priceString drawAtPoint:CGPointMake(priceStringX , stringY) withAttributes:attribute];
//    [volumeString drawAtPoint:CGPointMake(volumeStringX, stringY + priceSize.height + 5) withAttributes:attribute];
    
    
}


- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
