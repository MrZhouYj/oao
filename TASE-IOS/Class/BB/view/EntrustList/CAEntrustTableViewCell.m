//
//  CAEntrustTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEntrustTableViewCell.h"

@interface CAEntrustTableViewCell()

/**撤销*/
@property (nonatomic, strong) UIButton * revokeButton;
/**时间*/
@property (nonatomic, strong) UILabel * entrustTimeLabel;
/**委托价*/
@property (nonatomic, strong) UILabel * entrustPriceLabel;
/**委托量*/
@property (nonatomic, strong) UILabel * entrustNumberLabel;
/**成交总额*/
@property (nonatomic, strong) UILabel * entrustAllPriceLabel;

@property (nonatomic, strong) UILabel * PriceNotiLabel;

@property (nonatomic, strong) UILabel * NumberNotiLabel;

@property (nonatomic, strong) UILabel * AllPriceNotiLabel;

@end

@implementation CAEntrustTableViewCell



#pragma mark 初始化布局
-(void)initSubview{
    [super initSubview];
    
    self.entrustTimeLabel.font = FONT_REGULAR_SIZE(11);
    self.entrustTimeLabel.dk_textColorPicker = DKColorPickerWithKey(NormalgrayColor_c5c9db);
    [self.entrustTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currencyLabel.mas_right).offset(10);
        make.bottom.equalTo(self.typeLabel.mas_bottom);
    }];
    
    NSArray * level1 = @[self.PriceNotiLabel,self.NumberNotiLabel,self.AllPriceNotiLabel];
    NSArray * level2 = @[self.entrustPriceLabel,self.entrustNumberLabel,self.entrustAllPriceLabel];
    
    [self initLabel:level1 isUp:YES];
    [self initLabel:level2 isUp:NO];
    
    [self layout:level1
         topView:self.typeLabel
           space:15];
    
     [self layout:level2
          topView:self.PriceNotiLabel
            space:10];
    
    [self.revokeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.typeLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
    }];
    
}

-(void)setModel:(CAEntrustModel *)model{
    [super setModel:model];
    
    self.currencyLabel.text = NSStringFormat(@"%@/%@",model.ask,model.bid);;
    self.typeLabel.text = NSStringFormat(@"%@",model.type);
    self.entrustTimeLabel.text = NSStringFormat(@"%@",model.time);
    self.PriceNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"价格"),model.bid);
    self.NumberNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"数量"),model.ask);
    self.AllPriceNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"实际成交"),model.bid);
    self.entrustPriceLabel.text = NSStringFormat(@"%@",model.price);
    self.entrustNumberLabel.text = NSStringFormat(@"%@",model.origin_volume);
    self.entrustAllPriceLabel.text = NSStringFormat(@"%@",model.actual_volume);
    
    if ([model.sell_or_buy isEqualToString:@"bid"]) {
        self.typeLabel.textColor = [UIColor increaseColor];
    }else{
        self.typeLabel.textColor = [UIColor decreaseColor];
    }
    if (_revokeButton) {
        [_revokeButton setTitle:CALanguages(@"撤销")  forState:UIControlStateNormal];
    }
}


#pragma mark 懒加载

-(UIButton *)revokeButton{
    if (!_revokeButton) {
        _revokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_revokeButton];
        _revokeButton.enabled = NO;
        _revokeButton.titleLabel.font = FONT_MEDIUM_SIZE(12);
        _revokeButton.backgroundColor = HexRGB(0xebf3fb);
        [_revokeButton setTitleColor:HexRGB(0x0a6cdb) forState:UIControlStateNormal];
        _revokeButton.layer.masksToBounds = YES;
        _revokeButton.layer.cornerRadius = 2;
    }
    return _revokeButton;
}


-(UILabel *)PriceNotiLabel{
    if (!_PriceNotiLabel) {
        _PriceNotiLabel = [UILabel new];
        [self.contentView addSubview:_PriceNotiLabel];
    }
    return _PriceNotiLabel;
}

-(UILabel *)NumberNotiLabel{
    if (!_NumberNotiLabel) {
        _NumberNotiLabel = [UILabel new];
        [self.contentView addSubview:_NumberNotiLabel];
    }
    return _NumberNotiLabel;
}
-(UILabel *)AllPriceNotiLabel{
    if (!_AllPriceNotiLabel) {
        _AllPriceNotiLabel = [UILabel new];
        [self.contentView addSubview:_AllPriceNotiLabel];
    }
    return _AllPriceNotiLabel;
}

-(UILabel *)entrustAllPriceLabel{
    if (!_entrustAllPriceLabel) {
        _entrustAllPriceLabel = [UILabel new];
        [self.contentView addSubview:_entrustAllPriceLabel];
    }
    return _entrustAllPriceLabel;
}
-(UILabel *)entrustNumberLabel{
    if (!_entrustNumberLabel) {
        _entrustNumberLabel = [UILabel new];
        [self.contentView addSubview:_entrustNumberLabel];
    }
    return _entrustNumberLabel;
}
-(UILabel *)entrustPriceLabel{
    if (!_entrustPriceLabel) {
        _entrustPriceLabel = [UILabel new];
        [self.contentView addSubview:_entrustPriceLabel];
    }
    return _entrustPriceLabel;
}
-(UILabel *)entrustTimeLabel{
    if (!_entrustTimeLabel) {
        _entrustTimeLabel = [UILabel new];
        [self.contentView addSubview:_entrustTimeLabel];
    }
    return _entrustTimeLabel;
}
@end
