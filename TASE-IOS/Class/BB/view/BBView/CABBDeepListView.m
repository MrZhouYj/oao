//
//  CABBDeepListView.m
//  TASE-IOS
//
//   9/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBDeepListView.h"

@interface CABBDeepListView()

@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UILabel * numberLabel;

@end

@implementation CABBDeepListView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.dir = BackgroundDireactionRightToLeft;
        self.backgroundColor = [UIColor clearColor];
        self.type = TradingSell;
        self.number = @"--";
        self.price = @"--";
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dir = BackgroundDireactionRightToLeft;
        self.backgroundColor = [UIColor redColor];
        self.type = TradingSell;
        self.number = @"--";
        self.price = @"--";
    }
    return self;
}


-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        [self addSubview:_priceLabel];
        _priceLabel.font = ROBOTO_FONT_REGULAR_SIZE(13);
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(self).multipliedBy(0.55);
        }];
    }
    return _priceLabel;
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        [self addSubview:_numberLabel];
        _numberLabel.font = ROBOTO_FONT_REGULAR_SIZE(13);
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(self).multipliedBy(0.4);
        }];
    }
    return _numberLabel;
}

-(void)setPrice:(NSString *)price{
    _price = price;
    self.priceLabel.text = price;
    
}
-(void)setNumber:(NSString *)number{
    _number = number;
    self.numberLabel.text = number;
}

-(void)setType:(TradingType)type{
    [super setType:type];
    if (TradingSell==type) {
        self.numberLabel.textColor = [UIColor decreaseColor];
        self.priceLabel.textColor = [UIColor decreaseColor];
    }else if (TradingBuy==type){
        self.priceLabel.textColor = [UIColor increaseColor];
        self.numberLabel.textColor = [UIColor increaseColor];
    }
}


@end
