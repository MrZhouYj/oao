//
//  CAChatHeaderView.m
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChatHeaderView.h"
#import "CAOrderInfoModel.h"
@interface CAChatHeaderView()

@property (nonatomic, strong) UILabel * nameFirstLabel;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * stateLabel;

@end

@implementation CAChatHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    self.nameFirstLabel = [UILabel new];
    [self addSubview:self.nameFirstLabel];
    self.nameFirstLabel.font = FONT_MEDIUM_SIZE(15);
    self.nameFirstLabel.textColor = HexRGB(0xffffff);
    self.nameFirstLabel.backgroundColor = HexRGB(0x3744a4);
    self.nameFirstLabel.textAlignment = NSTextAlignmentCenter;
    self.nameFirstLabel.layer.masksToBounds = YES;
    self.nameFirstLabel.layer.cornerRadius = 13;
    [self.nameFirstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.height.equalTo(@26);
    }];
    
    
    self.nameLabel = [UILabel new];
    [self addSubview:self.nameLabel];
    self.nameLabel.textColor = HexRGB(0x191d26);
    self.nameLabel.font = FONT_SEMOBOLD_SIZE(16);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameFirstLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nameFirstLabel);
    }];
    
   
    
   UILabel * priceNotiLabel = [UILabel new];
   [self addSubview:priceNotiLabel];
   priceNotiLabel.textColor = HexRGB(0xa2a3bd);
   priceNotiLabel.font = FONT_MEDIUM_SIZE(13);
   [priceNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.nameFirstLabel);
       make.top.equalTo(self.nameFirstLabel.mas_bottom).offset(15);
   }];
   
   
    
    self.priceLabel = [UILabel new];
    [self addSubview:self.priceLabel];
    self.priceLabel.textColor = HexRGB(0x006cdb);
    self.priceLabel.font = FONT_SEMOBOLD_SIZE(20);
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameFirstLabel);
        make.top.equalTo(priceNotiLabel.mas_bottom).offset(5);
    }];
    
    
    self.stateLabel = [UILabel new];
    [self addSubview:self.stateLabel];
    self.stateLabel.textColor = HexRGB(0x006cdb);
    self.stateLabel.font = FONT_SEMOBOLD_SIZE(17);
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleButton];
    [cancleButton setImage:IMAGE_NAMED(@"close") forState:UIControlStateNormal];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.width.height.equalTo(@30);
    }];
    
    [cancleButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    priceNotiLabel.text = CALanguages(@"交易总额");
    
}
-(void)hideSelf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CAChatHeaderView_hideChatViewClick)]) {
        [self.delegate CAChatHeaderView_hideChatViewClick];
    }
}

-(void)setOrderInfoModel:(CAOrderInfoModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    
    NSString *showName = orderInfoModel.showNickName;
   
    self.nameFirstLabel.text = [CommonMethod getFirstFromString:orderInfoModel.showNickName];;
    self.nameLabel.text = showName;
    self.priceLabel.text = [NSStringFormat(@"%@",orderInfoModel.fiat_amount) formatterDecimalString];
    self.stateLabel.text = orderInfoModel.state_name;
       
}

@end
