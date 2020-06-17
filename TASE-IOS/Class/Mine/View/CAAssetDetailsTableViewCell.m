//
//  CAAssetDetailsTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAssetDetailsTableViewCell.h"

@interface CAAssetDetailsTableViewCell()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * numberLabel;

@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation CAAssetDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.titleLabel.text = NSStringFormat(@"%@",dataDic[@"type"]);
    self.numberLabel.text = NSStringFormat(@"%@",dataDic[@"amount"]);
    self.timeLabel.text = NSStringFormat(@"%@",dataDic[@"time"]);

}

-(void)initSubViews{
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = HexRGB(0x151528);
    self.titleLabel.font = FONT_MEDIUM_SIZE(14);
   
    
    self.numberLabel = [UILabel new];
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.textColor = HexRGB(0x151528);
    self.numberLabel.font = FONT_SEMOBOLD_SIZE(13);
    
    
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = HexRGB(0x969dbf);
    self.timeLabel.font = FONT_MEDIUM_SIZE(12);
    
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.width.mas_lessThanOrEqualTo(MainWidth*0.7);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.titleLabel.mas_top);
        make.width.mas_lessThanOrEqualTo(MainWidth*0.29);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

@end
