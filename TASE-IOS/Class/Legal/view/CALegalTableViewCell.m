//
//  CALegalTableViewCell.m
//  TASE-IOS
//
//   9/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CALegalTableViewCell.h"
#import "CAChoosePayTypeView.h"

@interface CALegalTableViewCell()

@property (nonatomic, strong) UILabel * headUserNameLabel;

@property (nonatomic, strong) UILabel * usernameLabel;

@property (nonatomic, strong) UIImageView * smallImageV;

@property (nonatomic, strong) UILabel * colseRatioLabel;

@property (nonatomic, strong) UILabel * numberLabel;

@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) UILabel *priceNotiLabel;
/**限额*/
@property (nonatomic, strong) UILabel * quotaLabel;

@property (nonatomic, strong) UIView * payWayView;

@property (nonatomic, strong) UIButton * buyButton;

@end

@implementation CALegalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

+(CGFloat)getCellHeight{
    return 142;
}

-(void)initSubViews{
    
    {
      self.headUserNameLabel = [UILabel new];
      [self.contentView addSubview:self.headUserNameLabel];
      self.headUserNameLabel.font = FONT_SEMOBOLD_SIZE(15);
      self.headUserNameLabel.textColor = [UIColor whiteColor];
      self.headUserNameLabel.layer.masksToBounds = YES;
      self.headUserNameLabel.layer.cornerRadius = 25/2.f;
      self.headUserNameLabel.backgroundColor = RGB(0,108,219);
      self.headUserNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    //用户名
    {
        self.usernameLabel = [UILabel new];
        [self.contentView addSubview:self.usernameLabel];
        self.usernameLabel.font = FONT_MEDIUM_SIZE(15);
        self.usernameLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    }
    
    
    self.smallImageV = [UIImageView new];
    [self.contentView addSubview:self.smallImageV];
    self.colseRatioLabel = [UILabel new];
    [self.contentView addSubview:self.colseRatioLabel];
    self.colseRatioLabel.font = FONT_MEDIUM_SIZE(11);
    self.colseRatioLabel.textColor = RGB(145, 146, 177);
    self.colseRatioLabel.textAlignment = NSTextAlignmentRight;
    
   
    self.numberLabel =  [UILabel new];
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.font = FONT_MEDIUM_SIZE(12);
    self.numberLabel.textColor = RGB(145, 146, 177);
   
    self.quotaLabel =  [UILabel new];
    [self.contentView addSubview:self.quotaLabel];
    self.quotaLabel.font = FONT_MEDIUM_SIZE(12);
    self.quotaLabel.textColor = RGB(145, 146, 177);
    
    
    self.priceNotiLabel = [UILabel new];
    [self.contentView addSubview:self.priceNotiLabel];
    self.priceNotiLabel.font = FONT_MEDIUM_SIZE(12);
    self.priceNotiLabel.textColor = RGB(145, 146, 177);
    self.priceNotiLabel.textAlignment = NSTextAlignmentRight;
    
    
    self.priceLabel = [UILabel new];
    [self.contentView addSubview:self.priceLabel];
    self.priceLabel.font = FONT_MEDIUM_SIZE(20);
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    
    self.payWayView = [UIView new];
    [self.contentView addSubview:self.payWayView];
    
   
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.buyButton];
    self.buyButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buyButton.layer.masksToBounds = YES;
    self.buyButton.layer.cornerRadius = 2;
    self.buyButton.enabled = NO;
    
    
    UIView * lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
 
    [self.headUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@25);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.equalTo(self.headUserNameLabel);
          make.left.equalTo(self.headUserNameLabel.mas_right).offset(10);
      }];
    
    [self.smallImageV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.usernameLabel.mas_right).offset(5);
          make.centerY.equalTo(self.usernameLabel);
          make.width.height.equalTo(@14);
      }];
    
    [self.colseRatioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.contentView).offset(-15);
           make.centerY.equalTo(self.usernameLabel);
           make.width.equalTo(@200);
       }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.headUserNameLabel.mas_left);
           make.top.equalTo(self.headUserNameLabel.mas_bottom).offset(10);
       }];
    [self.quotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.headUserNameLabel.mas_left);
           make.top.equalTo(self.numberLabel.mas_bottom).offset(5);
           make.height.equalTo(self.numberLabel);
       }];
    [self.priceNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.equalTo(self.colseRatioLabel.mas_bottom).offset(10);
              make.width.equalTo(@100);
              make.right.equalTo(self.colseRatioLabel.mas_right);
          }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.colseRatioLabel.mas_right);
           make.top.equalTo(self.priceNotiLabel.mas_bottom).offset(5);
           make.width.equalTo(@150);
       }];
    [self.payWayView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.headUserNameLabel.mas_left);
             make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
             make.width.equalTo(@150);
             make.height.equalTo(@15);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_right);
        make.bottom.equalTo(self.payWayView.mas_bottom);
        make.width.equalTo(@90);
        make.height.equalTo(@30);
    }];
}



-(void)setModel:(CAAdvertisementModel *)model{
    _model = model;
    
    self.headUserNameLabel.text = model.first_name;
    self.usernameLabel.text = NSStringFormat(@"%@",model.otc_nick_name);
    self.smallImageV.image = IMAGE_NAMED(@"transaction");
    self.numberLabel.text = NSStringFormat(@"%@ %@ %@",CALanguages(@"数量"),model.trading_currency_amount,model.code_big);
    
    NSString *min_limit = [NSStringFormat(@"%@",model.min_limit) formatterDecimalString];
    NSString *max_limit = [NSStringFormat(@"%@",model.max_limit) formatterDecimalString];
    NSString *unit_price = [NSStringFormat(@"%@",model.unit_price) formatterDecimalString];

    
    self.quotaLabel.text  = NSStringFormat(@"%@ %@ - %@",CALanguages(@"限额"),min_limit,max_limit);
    self.priceLabel.text = NSStringFormat(@"%@",unit_price);
    self.priceNotiLabel.text = CALanguages(@"单价");
    
    if ([self.action_type isEqualToString:@"MyAdvertisementList"]) {
        self.buyButton.backgroundColor = RGB(0, 108, 219);
        self.priceLabel.textColor = RGB(0, 108, 219);
        [self.buyButton setTitle:CALanguages(@"编辑此广告") forState:UIControlStateNormal];
        self.colseRatioLabel.text = model.shelves_status;
        self.colseRatioLabel.textColor = [UIColor colorWithHexString:model.shelves_color];
        self.colseRatioLabel.font = FONT_MEDIUM_SIZE(15);
        
    }else{
        
        self.colseRatioLabel.text = NSStringFormat(@"%@ | %@",model.volume, model.favorable_rate);
        
        if ([model.trade_type isEqualToString:@"sell"]) {
            
            self.buyButton.backgroundColor = RGB(55,68,164);
            self.priceLabel.textColor = RGB(55,68,164);
            [self.buyButton setTitle:NSStringFormat(@"%@ %@",CALanguages(@"卖出"),model.code_big) forState:UIControlStateNormal];
            
        }else if ([model.trade_type isEqualToString:@"buy"]){
            
            self.buyButton.backgroundColor = RGB(0, 108, 219);
            self.priceLabel.textColor = RGB(0, 108, 219);
            [self.buyButton setTitle:NSStringFormat(@"%@ %@",CALanguages(@"购买"),model.code_big) forState:UIControlStateNormal];
        }
    }
    
    [self.payWayView removeAllSubViews];
    NSArray * array = model.payment_methods;
    UIImageView * lastImageV = nil;
    for (int i=0; i<array.count; i++) {
        UIImageView * cartImageV = [UIImageView new];
        [self.payWayView addSubview:cartImageV];
        cartImageV.contentMode = UIViewContentModeScaleAspectFit;
        
        [cartImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastImageV) {
                make.left.equalTo(lastImageV.mas_right).offset(10);
            }else{
                make.left.equalTo(self.payWayView);
            }
            make.bottom.top.equalTo(self.payWayView);
            make.width.equalTo(self.payWayView.mas_height);
        }];
        
        if ([array[i] isEqualToString:CAPayBank]) {
            cartImageV.image = IMAGE_NAMED(@"Bankcard");
        }else if ([array[i] isEqualToString:CAPayAli]){
            cartImageV.image = IMAGE_NAMED(@"Alipay");
        }else if ([array[i] isEqualToString:CAPayWechat]){
            cartImageV.image = IMAGE_NAMED(@"WeChat");
        }
        
        lastImageV = cartImageV;
    }
    lastImageV = nil;
}
@end
