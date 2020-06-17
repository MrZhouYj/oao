//
//  CAMoneyTableViewHeaderView.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMoneyTableViewHeaderView.h"
#import "CAShadowView.h"
#import "CAMoneyActionMenuView.h"

@interface CAMoneyTableViewHeaderView()

@property (nonatomic, strong) CAShadowView * priceActionView;

@property (nonatomic, strong) UILabel * allCurrencyLabel;

@property (nonatomic, strong) UILabel * allMoneyLabel;

@end

@implementation CAMoneyTableViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    
    
    UIImageView * bgImageV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"Backgroundmap")];
    [self addSubview:bgImageV];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(198+KTopRevise);
    }];
    
    
    
    self.priceActionView = [CAShadowView new];
    [self addSubview:self.priceActionView];
    [self.priceActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@80);
        make.top.equalTo(bgImageV.mas_bottom).offset(-10);
    }];
    
    
    CAMoneyActionMenuView * menuView = [CAMoneyActionMenuView new];
    [self.priceActionView.contentView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceActionView.contentView).offset(10);
        make.bottom.equalTo(self.priceActionView.contentView).offset(-10);
        make.left.equalTo(self.priceActionView.contentView).offset(30);
        make.right.equalTo(self.priceActionView.contentView).offset(-30);
    }];
    
    
    
    UILabel * allPriceNotiLabel = [UILabel new];
    [bgImageV addSubview:allPriceNotiLabel];
    allPriceNotiLabel.text =CALanguages(@"总资产");
    allPriceNotiLabel.font = FONT_MEDIUM_SIZE(17);
    allPriceNotiLabel.textColor = [UIColor whiteColor];
    [allPriceNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageV).offset(15);
        make.top.equalTo(bgImageV).offset(kTopHeight+10);
    }];
    
//    UIImageView * allPriceImageViewLogo = [UIImageView new];
//    [bgImageV addSubview:allPriceImageViewLogo];
//    allPriceImageViewLogo.image = [IMAGE_NAMED(@"Assets") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [allPriceImageViewLogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(allPriceNotiLabel.mas_right).offset(5);
//        make.centerY.equalTo(allPriceNotiLabel);
//        make.width.height.equalTo(@14);
//    }];
    
    
    self.allCurrencyLabel = [UILabel new];
    [bgImageV addSubview:self.allCurrencyLabel];
    self.allCurrencyLabel.font = FONT_MEDIUM_SIZE(32);
    self.allCurrencyLabel.textColor = [UIColor whiteColor];
    [self.allCurrencyLabel setAdjustsFontSizeToFitWidth:YES];
    [self.allCurrencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allPriceNotiLabel.mas_left);
        make.right.equalTo(bgImageV).offset(-15);
        make.top.equalTo(allPriceNotiLabel.mas_bottom).offset(15);
        make.height.equalTo(@26);
    }];
    
    
    
    self.allMoneyLabel = [UILabel new];
    [bgImageV addSubview:self.allMoneyLabel];
    self.allMoneyLabel.font = FONT_MEDIUM_SIZE(14);
    self.allMoneyLabel.textColor = RGB(247, 249, 255);
    [self.allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allCurrencyLabel.mas_left);
        make.top.equalTo(self.allCurrencyLabel.mas_bottom).offset(15);
    }];
    
}

-(void)setTotal_in_fiat:(NSString *)total_in_fiat{
    _total_in_fiat = total_in_fiat;
    self.allMoneyLabel.text = NSStringFormat(@"%@",total_in_fiat);
}

-(void)setTotal_in_crypto:(NSString *)total_in_crypto{
    _total_in_crypto = total_in_crypto;
    self.allCurrencyLabel.text = NSStringFormat(@"%@",total_in_crypto);
}




@end
