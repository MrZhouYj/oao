//
//  CAProgressView.m
//  TASE-IOS
//
//   9/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAProgressView.h"

@interface CAProgressView()

{
    CGFloat _currentX;
    int _num;//绘制圆点的个数
}

@property (nonatomic, strong) UILabel * startNumberLabel;

@property (nonatomic, strong) UILabel * endNumberLabel;

@end

@implementation CAProgressView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.layer.masksToBounds = YES;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
        [self addGestureRecognizer:pan];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        self.startNumberLabel.text = @"0";
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat radio = 7;
    CGFloat bigRadioBorderWidth = 12;
    CGFloat lineHeight = 4;
    CGFloat lineY = bigRadioBorderWidth-lineHeight/2.f;
    CGFloat num = 5;//有5个小圆点
    CGFloat space = (self.width-2*bigRadioBorderWidth-radio*2)/(num-1);
    CGFloat leftSpace = bigRadioBorderWidth;
  
    [HexRGB(0xe9e9ef) setFill];
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath * grayColorLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(leftSpace, lineY, self.width-leftSpace*2, lineHeight)];
    [grayColorLinePath fill];
    
    for (int i=0; i<num; i++) {
        UIBezierPath * grayColorCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(i*space+leftSpace, bigRadioBorderWidth-radio, radio*2, radio*2)];
        grayColorCirclePath.lineWidth = 5;
        grayColorCirclePath.lineCapStyle = kCGLineCapButt;
        grayColorCirclePath.lineJoinStyle = kCGLineJoinMiter;
        [grayColorCirclePath stroke];
        [grayColorCirclePath fill];
    }
    
    [self.displayColor setFill];
    
    //画一条直线
    UIBezierPath * grayDeepColorLinePath = [UIBezierPath bezierPathWithRect:CGRectMake(leftSpace, lineY, (self.width-2*bigRadioBorderWidth-radio*2)*_progress, lineHeight)];
    [grayDeepColorLinePath fill];
    
    
    for (int i=0; i<_num; i++) {
        UIBezierPath * grayDeepColorCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(i*space+leftSpace, bigRadioBorderWidth-radio, radio*2, radio*2)];
        grayDeepColorCirclePath.lineWidth = 5;
        grayDeepColorCirclePath.lineCapStyle = kCGLineCapButt;
        grayDeepColorCirclePath.lineJoinStyle = kCGLineJoinMiter;
        [grayDeepColorCirclePath stroke];
        [grayDeepColorCirclePath fill];
    }
    
    [self.displayColor setStroke];
    [[UIColor whiteColor] setFill];
    //绘制大的圆
    UIBezierPath * bigDeepColorCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.width-2*bigRadioBorderWidth-radio*2)*_progress+leftSpace, bigRadioBorderWidth/2.f, bigRadioBorderWidth, bigRadioBorderWidth)];
    bigDeepColorCirclePath.lineWidth = bigRadioBorderWidth;
    bigDeepColorCirclePath.lineCapStyle = kCGLineCapButt;
    bigDeepColorCirclePath.lineJoinStyle = kCGLineJoinMiter;
    [bigDeepColorCirclePath stroke];
    [bigDeepColorCirclePath fill];
    
}

-(void)setDisplayColor:(UIColor *)displayColor{
    _displayColor = displayColor;
    [self setNeedsDisplay];
}

-(void)tapClick:(UIGestureRecognizer*)tap{
    CGPoint point = [tap locationInView:self];
    _currentX = point.x;
    
    [self checkX];
    
    if (_progress>0.85) {
        _num = 5;
        _progress = 1;
    }else if (_progress>0.6){
        _num = 4;
        _progress = 0.75;
    }else if (_progress>0.35){
        _num = 3;
        _progress = 0.5;
    }else if (_progress>0.2){
        _num = 2;
        _progress = 0.25;
    }else{
        _num = 1;
        _progress = 0;
    }
    
    [self didChangeProgress];
    
    [self setNeedsDisplay];
}

-(void)checkX{
    if (_currentX<=1) {
        _currentX = 0;
    }
    if (_currentX>=self.width-12*2) {
        _currentX = self.width-12*2;
    }
    
    _progress = _currentX/(self.width-12*2);
}

-(void)panClick:(UIGestureRecognizer*)pan{
    
    CGPoint point = [pan locationInView:self];
    _currentX = point.x;
    
    [self checkX];
    [self changeNum];
    [self didChangeProgress];
    [self setNeedsDisplay];
}

-(void)changeNum{
    
    if (_progress<0.25) {
        _num = 1;
    }else if (_progress<0.5){
        _num = 2;
    }else if (_progress<0.75){
        _num = 3;
    }else if(_progress<1){
        _num = 4;
    }else{
        _num = 5;
    }
}

-(void)setProgress:(CGFloat)progress{
    if (progress>=1) {
        progress = 1;
    }
    _progress = progress;
    [self changeNum];
    [self setNeedsDisplay];
}

-(void)didChangeProgress{
    
    static CGFloat lastP = 0;
    
    if (lastP==_progress) {
        return;
    }
    
    lastP = _progress;
    
    [self routerEventWithName:@"CAProgressDidChangeProgress" userInfo:@(_progress)];
}

-(UILabel *)endNumberLabel{
    if (!_endNumberLabel) {
        _endNumberLabel = [UILabel new];
        [self addSubview:_endNumberLabel];
        _endNumberLabel.font = FONT_REGULAR_SIZE(10);
        _endNumberLabel.textColor = RGB(145,146,177);
        
        [_endNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
        }];
    }
    return _endNumberLabel;
}


-(UILabel *)startNumberLabel{
    if (!_startNumberLabel) {
        _startNumberLabel = [UILabel new];
        [self addSubview:_startNumberLabel];
        _startNumberLabel.font = FONT_REGULAR_SIZE(10);
        _startNumberLabel.textColor = RGB(145,146,177);
        
        [_startNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self);
        }];
    }
    return _startNumberLabel;
}

-(void)setMaxNumber:(NSString *)maxNumber{
    _maxNumber = maxNumber;
    self.endNumberLabel.text = maxNumber;
    
}

@end
