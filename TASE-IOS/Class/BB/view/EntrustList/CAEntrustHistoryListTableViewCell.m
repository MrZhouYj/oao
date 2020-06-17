//
//  CAEntrustHistoryListTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEntrustHistoryListTableViewCell.h"

@interface CAEntrustHistoryListTableViewCell()
{
    UIButton * rightRow;
}
/***/
@property (nonatomic, strong) UILabel * stateLabel;
/**时间*/
@property (nonatomic, strong) UILabel * entrustTimeLabel;
/**委托价*/
@property (nonatomic, strong) UILabel * entrustPriceLabel;
/**委托量*/
@property (nonatomic, strong) UILabel * entrustNumberLabel;
/**成交总额*/
@property (nonatomic, strong) UILabel * entrustAllPriceLabel;
/**成交均价*/
@property (nonatomic, strong) UILabel * entrustLevelLabel;
/**成交量*/
@property (nonatomic, strong) UILabel * entrustDealLabel;

@property (nonatomic, strong) UILabel * PriceNotiLabel;

@property (nonatomic, strong) UILabel * NumberNotiLabel;

@property (nonatomic, strong) UILabel * AllPriceNotiLabel;

@property (nonatomic, strong) UILabel * LevelNotiLabel;

@property (nonatomic, strong) UILabel * DealNotiLabel;

@property (nonatomic, strong) UILabel * timeNotiLabel;

@end

@implementation CAEntrustHistoryListTableViewCell

-(void)initSubview{
    [super initSubview];
    
    NSArray * level1 = @[self.timeNotiLabel,self.PriceNotiLabel,self.NumberNotiLabel];
    NSArray * level2 = @[self.entrustTimeLabel,self.entrustPriceLabel,self.entrustNumberLabel];
    NSArray * level3 = @[self.AllPriceNotiLabel,self.LevelNotiLabel,self.DealNotiLabel];
    NSArray * level4 = @[self.entrustAllPriceLabel,self.entrustLevelLabel,self.entrustDealLabel];
    
    [self initLabel:level1 isUp:YES];
    [self initLabel:level2 isUp:NO];
    [self initLabel:level3 isUp:YES];
    [self initLabel:level4 isUp:NO];
    
    [self layout:level1
         topView:self.typeLabel
           space:20];
    
    [self layout:level2
         topView:self.timeNotiLabel
           space:10];
    
    [self layout:level3
         topView:self.entrustTimeLabel
           space:20];
    
    [self layout:level4
         topView:self.AllPriceNotiLabel
           space:10];
    
}
-(void)setModel:(CAEntrustModel *)model{
    [super setModel:model];
    
    self.currencyLabel.text = NSStringFormat(@"%@/%@",[model.ask_code uppercaseString],[model.bid_code uppercaseString]);;
    self.typeLabel.text = NSStringFormat(@"%@",model.type);
    
    self.timeNotiLabel.text = CALanguages(@"时间");
    self.PriceNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"委托价"),[model.bid_code uppercaseString]);
    self.NumberNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"委托量"),[model.ask_code uppercaseString]);
    self.AllPriceNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"成交总额"),[model.bid_code uppercaseString]);
    self.LevelNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"成交均价"),[model.bid_code uppercaseString]);
    self.DealNotiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"成交量"),[model.ask_code uppercaseString]);
    
    self.stateLabel.text = CALanguages(@"已成交");
    
    self.entrustTimeLabel.text = NSStringFormat(@"%@",model.time);
    self.entrustPriceLabel.text = NSStringFormat(@"%@",model.price);
    self.entrustNumberLabel.text = NSStringFormat(@"%@",model.origin_volume);
    self.entrustAllPriceLabel.text = NSStringFormat(@"%@",model.total_cost);
    self.entrustLevelLabel.text = NSStringFormat(@"%@",model.average_price);
    self.entrustDealLabel .text = NSStringFormat(@"%@",model.volume);

    if ([model.ask_or_bid isEqualToString:@"bid"]) {
        self.typeLabel.textColor = [UIColor increaseColor];
    }else{
        self.typeLabel.textColor = [UIColor decreaseColor];
    }
}


-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        [self.contentView addSubview:_stateLabel];
        _stateLabel.font = FONT_MEDIUM_SIZE(13);
        _stateLabel.dk_textColorPicker = DKColorPickerWithKey(NormalgrayColor_c5c9db);
        _stateLabel.textAlignment = NSTextAlignmentRight;
        
        
        rightRow = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:rightRow];
        [rightRow setImage:IMAGE_NAMED(@"arrowright") forState:UIControlStateNormal];
        rightRow.imageView.contentMode = UIViewContentModeScaleAspectFit;
        rightRow.enabled = NO;
        rightRow.tintColor = HexRGB(0xc5c9db);
        [rightRow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.typeLabel);
            make.width.height.equalTo(@12);
        }];

        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightRow.mas_left).offset(-5);
            make.centerY.equalTo(self.typeLabel);
            make.width.equalTo(@100);
        }];
    }
    return _stateLabel;
}

-(void)setHideRightRow:(BOOL)hideRightRow{
    _hideRightRow = hideRightRow;
    rightRow.hidden = hideRightRow;
}

-(UILabel *)timeNotiLabel{
    if (!_timeNotiLabel) {
        _timeNotiLabel = [UILabel new];
        [self.contentView addSubview:_timeNotiLabel];
    }
    return _timeNotiLabel;
}
-(UILabel *)PriceNotiLabel{
    if (!_PriceNotiLabel) {
        _PriceNotiLabel = [UILabel new];
        [self.contentView addSubview:_PriceNotiLabel];
    }
    return _PriceNotiLabel;
}
-(UILabel *)DealNotiLabel{
    if (!_DealNotiLabel) {
        _DealNotiLabel = [UILabel new];
        [self.contentView addSubview:_DealNotiLabel];
    }
    return _DealNotiLabel;
}
-(UILabel *)LevelNotiLabel{
    if (!_LevelNotiLabel) {
        _LevelNotiLabel = [UILabel new];
        [self.contentView addSubview:_LevelNotiLabel];
    }
    return _LevelNotiLabel;
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

-(UILabel *)entrustDealLabel{
    if (!_entrustDealLabel) {
        _entrustDealLabel = [UILabel new];
        [self.contentView addSubview:_entrustDealLabel];
    }
    return _entrustDealLabel;
}
-(UILabel *)entrustLevelLabel{
    if (!_entrustLevelLabel) {
        _entrustLevelLabel = [UILabel new];
        [self.contentView addSubview:_entrustLevelLabel];
    }
    return _entrustLevelLabel;
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

