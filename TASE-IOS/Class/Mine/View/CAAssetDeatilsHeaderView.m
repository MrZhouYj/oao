//
//  CAMoneyTableViewHeaderView.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAssetDeatilsHeaderView.h"
#import "CAShadowView.h"
#import "CAMoneyActionMenuView.h"

@interface CAAssetDeatilsHeaderView()

@property (nonatomic, strong) CAShadowView * priceActionView;
@property (nonatomic, strong) UILabel * currencyNameLabel;
@property (nonatomic, strong) UILabel * currencyMoneyLabel;
@property (nonatomic, strong) UILabel * useLabel;
@property (nonatomic, strong) UILabel * lockedLabel;
@property (nonatomic, strong) CAMoneyActionMenuView * menuView;

@end

@implementation CAAssetDeatilsHeaderView

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
    self.menuView = menuView;
    [self.priceActionView.contentView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceActionView.contentView).offset(10);
        make.bottom.equalTo(self.priceActionView.contentView).offset(-10);
        make.left.equalTo(self.priceActionView.contentView).offset(30);
        make.right.equalTo(self.priceActionView.contentView).offset(-30);
    }];
    
    
    
    self.currencyNameLabel = [UILabel new];
    [bgImageV addSubview:self.currencyNameLabel];
    self.currencyNameLabel.font = FONT_SEMOBOLD_SIZE(30);
    self.currencyNameLabel.textColor = [UIColor whiteColor];
    [self.currencyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageV).offset(15);
        make.top.equalTo(bgImageV).offset(kTopHeight+10);
        make.height.equalTo(@25);
    }];
    
    
    self.currencyMoneyLabel = [UILabel new];
    [bgImageV addSubview:self.currencyMoneyLabel];
    self.currencyMoneyLabel.font = FONT_MEDIUM_SIZE(14);
    self.currencyMoneyLabel.textColor = HexRGB(0xd2bffd);
    [self.currencyMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currencyNameLabel.mas_right);
        make.bottom.equalTo(self.currencyNameLabel).offset(2);
    }];
    
    
   
    
    UILabel * useLabel = [UILabel new];
    [bgImageV addSubview:useLabel];
    useLabel.font = FONT_MEDIUM_SIZE(14);
    useLabel.textColor = HexRGB(0xd2bffd);
    [useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageV).offset(25);
        make.bottom.equalTo(self.priceActionView.mas_top).offset(-10);
    }];
    useLabel.text = CALanguages(@"可用");
    
    UILabel * lockLabel = [UILabel new];
    [bgImageV addSubview:lockLabel];
    lockLabel.font = FONT_MEDIUM_SIZE(14);
    lockLabel.textColor = HexRGB(0xd2bffd);
    [lockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImageV).offset(-25);
        make.bottom.equalTo(useLabel.mas_bottom);
    }];
    lockLabel.text = CALanguages(@"锁定");
    
    self.useLabel = [UILabel new];
    [bgImageV addSubview:self.useLabel];
    self.useLabel.font = FONT_MEDIUM_SIZE(14);
    self.useLabel.textColor = [UIColor whiteColor];
    [self.useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(useLabel);
        make.bottom.equalTo(useLabel.mas_top).offset(-5);
    }];
    
    
    self.lockedLabel = [UILabel new];
    [bgImageV addSubview:self.lockedLabel];
    self.lockedLabel.font = FONT_MEDIUM_SIZE(14);
    self.lockedLabel.textColor = [UIColor whiteColor];
    [self.lockedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lockLabel);
        make.bottom.equalTo(self.useLabel.mas_bottom);
    }];
    
    
}

-(void)setIs_transferable:(BOOL)is_transferable{
    _is_transferable = is_transferable;
    self.menuView.is_transferable = is_transferable;
}
-(void)setIs_withdrawable:(BOOL)is_withdrawable{
    _is_withdrawable = is_withdrawable;
    self.menuView.is_withdrawable = is_withdrawable;
}
-(void)setIs_depositable:(BOOL)is_depositable{
    _is_depositable = is_depositable;
    self.menuView.is_depositable = is_depositable;
}

-(void)setUseText:(NSString *)useText{
    _useText = useText;
    self.useLabel.text = NSStringFormat(@"%@",useText);
}

-(void)setLokedText:(NSString *)lokedText{
    _lokedText = lokedText;
    self.lockedLabel.text = NSStringFormat(@"%@",lokedText);
}
-(void)setCurrencyNameText:(NSString *)currencyNameText{
    _currencyNameText = currencyNameText;
    self.currencyNameLabel.text = NSStringFormat(@"%@",currencyNameText);
}
-(void)setCurrencyMoneyText:(NSString *)currencyMoneyText{
    _currencyMoneyText = currencyMoneyText;
    self.currencyMoneyLabel.text = NSStringFormat(@"%@",currencyMoneyText);
    
}

@end
