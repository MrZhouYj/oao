//
//  WelcomeVIew.m
//  TASE-IOS
//
//  Created by 周永建 on 2020/3/31.
//  Copyright © 2020 CA. All rights reserved.
//

#import "WelcomeVIew.h"

@implementation WelcomeVIew

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexRGB(0x001176);
    
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    NSLog(@"%f--%f",MainWidth,MainHeight);
    
    self.iconImageView = [UIImageView new];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AutoNumber(30));
        make.right.equalTo(self).offset(-AutoNumber(30));
        make.top.equalTo(self).offset(AutoNumber(120/414*MainWidth));
        make.height.equalTo(self.iconImageView.mas_width);
    }];
    
    
    self.hanziLabel = [UILabel new];
    [self addSubview:self.hanziLabel];
    self.hanziLabel.textColor = [UIColor whiteColor];
    self.hanziLabel.font = FONT_SEMOBOLD_SIZE(27);
    self.hanziLabel.textAlignment = NSTextAlignmentCenter;
    [self.hanziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AutoNumber(40));
        make.width.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    self.enLabel = [UILabel new];
    [self addSubview:self.enLabel];
    self.enLabel.textColor = HexRGB(0xa3a7c2);
    self.enLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    self.enLabel.textAlignment = NSTextAlignmentCenter;
    [self.enLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hanziLabel.mas_bottom).offset(AutoNumber(15));
        make.width.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    self.progressImageView = [UIImageView new];
    [self addSubview:self.progressImageView];
    self.progressImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.progressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.4);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-40-SafeAreaBottomHeight);
        make.height.equalTo(@10);
    }];
    
    
    self.enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.enterButton];
    [self.enterButton setTitle: @"点击进入" forState:UIControlStateNormal];
    self.enterButton.layer.masksToBounds = YES;
    self.enterButton.layer.cornerRadius = AutoNumber(20);
    self.enterButton.backgroundColor = [UIColor whiteColor];
    [self.enterButton setTitleColor:HexRGB(0x001274) forState:UIControlStateNormal];
    self.enterButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(AutoNumber(160)));
        make.height.equalTo(@(AutoNumber(40)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.progressImageView.mas_top).offset(AutoNumber(-30));
    }];
    self.enterButton.hidden = YES;
    
}

@end
