//
//  CAEntrustBaseTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEntrustBaseTableViewCell.h"

@implementation CAEntrustBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubview];
    }
    return self;
}

-(void)initSubview{
     
    self.typeLabel = [UILabel new];
    [self.contentView addSubview:self.typeLabel];
    self.typeLabel.font = ROBOTO_FONT_MEDIUM_SIZE(16);
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    self.currencyLabel = [UILabel new];
    [self.contentView addSubview:self.currencyLabel];
    self.currencyLabel.font = ROBOTO_FONT_MEDIUM_SIZE(16);
    self.currencyLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    [self.currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(5);
        make.centerY.equalTo(self.typeLabel);
    }];
    

    UIView * lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

-(void)initLabel:(NSArray*)labels isUp:(BOOL)isUp{
    
    for (int i=0; i<labels.count; i++) {
        UILabel * label = (UILabel*)labels[i];
    
        if (isUp) {
            label.font = ROBOTO_FONT_MEDIUM_SIZE(12);//c5c9db
            label.dk_textColorPicker = DKColorPickerWithKey(NormalgrayColor_c5c9db);
        }else{
            label.font = ROBOTO_FONT_REGULAR_SIZE(14);
            label.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        }
        if (i==2) {
            label.textAlignment = NSTextAlignmentRight;
        }
    }
}

-(void)layout:(NSArray*)labels topView:(UILabel*)topLabel space:(CGFloat)topSpace{
    
    for (int i=0; i<labels.count; i++) {
        UILabel * label = labels[i];
        switch (i) {
            case 0:
            {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView).offset(15);
                    make.top.equalTo(topLabel.mas_bottom).offset(topSpace);
                    make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.3);
                }];
            }
                break;
            case 1:
            {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(labels[i-1]);
                    make.centerX.equalTo(self.contentView);
                    make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.3);
                }];
            }
                break;
            case 2:
            {
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.contentView).offset(-15);
                    make.centerY.equalTo(labels[i-1]); make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.3);
                }];
            }
                break;
                
            default:
                break;
        }
    }
    
}

-(void)setModel:(CAEntrustModel *)model{
    _model = model;
    
}

@end
