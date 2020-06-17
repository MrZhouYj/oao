//
//  CAPersonCenterTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPersonCenterTableViewCell.h"

@interface CAPersonCenterTableViewCell()


@end

@implementation CAPersonCenterTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    self.leftNotiLabel = [UILabel new];
    [self.contentView addSubview:self.leftNotiLabel];
    self.leftNotiLabel.textColor = HexRGB(0xc5c9db);
    self.leftNotiLabel.font = ROBOTO_FONT_REGULAR_SIZE(14);
    [self.leftNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView);
    }];
    
    self.rightContentLabel = [UILabel new];
    [self.contentView addSubview:self.rightContentLabel];
    self.rightContentLabel.textColor = HexRGB(0x191d26);
    self.rightContentLabel.font = FONT_REGULAR_SIZE(14);
    [self.rightContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.leftNotiLabel);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    self.rightContentLabel.textAlignment = NSTextAlignmentRight;
    
}

@end
