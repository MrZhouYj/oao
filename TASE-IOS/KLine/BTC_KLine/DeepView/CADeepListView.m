//
//  CADeepListView.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CADeepListView.h"

@implementation CADeepListView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    
    NSMutableDictionary * priceAttr = @{
                                 NSFontAttributeName:ROBOTO_FONT_REGULAR_SIZE(12),
                                 NSForegroundColorAttributeName:[UIColor increaseColor]
                                 }.mutableCopy;
    CGSize priceSize = [self rectOfNSString:self.price attribute:priceAttr].size;
    
    NSDictionary * numberAttr = @{
                                  NSFontAttributeName:ROBOTO_FONT_REGULAR_SIZE(12),
                                  NSForegroundColorAttributeName:HexRGB(0x7caae9),
                                  };
    CGSize numberSize = [self rectOfNSString:self.number attribute:numberAttr].size;
    
    NSDictionary * numAttr = @{
                               NSFontAttributeName:ROBOTO_FONT_REGULAR_SIZE(12),
                               NSForegroundColorAttributeName:HexRGB(0x0b0826),
                               };
    CGSize numSize = [self rectOfNSString:self.num attribute:numAttr].size;
    
    CGPoint numberPoint = CGPointZero;
    CGPoint numPoint = CGPointZero;
    CGPoint pricePoint = CGPointZero;
    CGRect bgRect = CGRectZero;
    UIColor * bgColor = nil;

    if (self.type==0) {
        //买盘
        bgColor = HexRGBA(0xd6fbe9, 0.65);
        numberPoint = CGPointMake(10, (selfHeight-numberSize.height)/2.f);
        numPoint = CGPointMake(numberSize.width+10+10, (selfHeight-numSize.height)/2.f);
        pricePoint = CGPointMake(selfWidth-5-priceSize.width, (selfHeight-priceSize.height)/2.f);
        bgRect = CGRectMake(selfWidth*(1-self.radio), 0, selfWidth*self.radio, selfHeight);
    }else if(self.type==1){
        [priceAttr setValue:[UIColor decreaseColor] forKey:NSForegroundColorAttributeName];
        bgColor =  HexRGBA(0xffd2d8, 0.3);
        numberPoint = CGPointMake(selfWidth-numberSize.width-10, (selfHeight-numberSize.height)/2.f);
        numPoint = CGPointMake(selfWidth-numberSize.width-10-numSize.width-10, (selfHeight-numSize.height)/2.f);
        pricePoint = CGPointMake(5, (selfHeight-priceSize.height)/2.f);
        bgRect = CGRectMake(0, 0, selfWidth*self.radio, selfHeight);
    }
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:bgRect];
    [bgColor set];
    CGContextAddPath(ctx, path.CGPath);
    CGContextFillPath(ctx);
    
    
    [self.price drawAtPoint:pricePoint withAttributes:priceAttr];
    [self.number drawAtPoint:numberPoint withAttributes:numberAttr];
    [self.num drawAtPoint:numPoint withAttributes:numAttr];
    
    
}
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

-(void)clear{
    //0 买盘 1卖盘
//    @property (nonatomic, assign) int type;
//    @property (nonatomic, assign) CGFloat radio;
//    @property (nonatomic, copy) NSString * number;
//    @property (nonatomic, copy) NSString * num;
//    @property (nonatomic, copy) NSString * price;
    self.type = 2;
    self.radio = 0;
    self.number = @"";
    self.num = @"";
    self.price = @"";
    
    [self setNeedsDisplay];
    
}
@end
