//
//  CAAssetRecordDetailTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAssetRecordDetailTableViewCell.h"

@interface CAAssetRecordDetailTableViewCell()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * valueLabel;

@end

@implementation CAAssetRecordDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView * lineView = [UIView new];
        [self.contentView addSubview:lineView];
        lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        self.titleLabel = [UILabel new];
        [self.contentView addSubview:self.titleLabel];
        self.valueLabel = [UILabel new];
        [self.contentView addSubview:self.valueLabel];
        
        self.titleLabel.font = FONT_MEDIUM_SIZE(14);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = HexRGB(0x191d26);
        
        self.valueLabel.font = FONT_MEDIUM_SIZE(14);
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.numberOfLines = 0;
        self.valueLabel.textColor = HexRGB(0x8c92b3);
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.width.equalTo(self.contentView).multipliedBy(0.4);
        }];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.titleLabel);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.width.equalTo(self.contentView).multipliedBy(0.5);
        }];
        
        
    }
    return self;
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    
    self.titleLabel.text = NSStringFormat(@"%@",data[@"label"]);
    self.valueLabel.text = NSStringFormat(@"%@",data[@"value"]);
}

@end
