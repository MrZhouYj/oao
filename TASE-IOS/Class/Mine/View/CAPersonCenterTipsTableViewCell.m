//
//  CAPersonCenterTipsTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPersonCenterTipsTableViewCell.h"



@implementation CAPersonCenterTipsTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * radioView = [UIView new];
        [self.contentView addSubview:radioView];
        radioView.backgroundColor = [UIColor blackColor];
        radioView.layer.cornerRadius = 3;
        radioView.layer.masksToBounds = YES;
        [radioView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@6);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(20);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(radioView.mas_right).offset(5);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(radioView.mas_top).offset(-2);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

-(void)setContentString:(NSString *)contentString{
    _contentString = contentString;
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 5 - (self.contentLabel.font.lineHeight - self.contentLabel.font.pointSize);

    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:contentString attributes:@{
        NSParagraphStyleAttributeName:style,
        
    }];
    
    self.contentLabel.attributedText = str;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        [self.contentView addSubview:_contentLabel];
        _contentLabel.font = FONT_REGULAR_SIZE(14);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HexRGB(0x191d26);
//        _contentLabel.backgroundColor = [UIColor redColor];
    }
    return _contentLabel;
}

@end
