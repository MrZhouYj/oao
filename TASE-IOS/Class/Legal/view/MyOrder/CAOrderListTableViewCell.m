//
//  CAOrderListTableViewCell.m
//  TASE-IOS
//
//   10/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAOrderListTableViewCell.h"
#import "CAChoosePayTypeView.h"

@interface CAOrderListTableViewCell()
/**
 用户名
 */
@property (nonatomic, strong) UILabel * usernameLabel;
/**订单状态*/
@property (nonatomic, strong) UILabel * orderStateLabel;
/**订单时间*/
@property (nonatomic, strong) UILabel * orderTimeLabel;
/**订单类型*/
@property (nonatomic, strong) UILabel * orderTypeLabel;
/**单价*/
@property (nonatomic, strong) UILabel * unitPriceNotiLabel;
/**单价 具体数字*/
@property (nonatomic, strong) UILabel * unitPriceLabel;
/**数字币数量提示*/
@property (nonatomic, strong) UILabel * numberNotiLabel;
/**数字币数量*/
@property (nonatomic, strong) UILabel * numberLabel;
/**法币数量提示*/
@property (nonatomic, strong) UILabel * legalNumberNotiLabel;
/**法币数量*/
@property (nonatomic, strong) UILabel * legalNumberLabel;
/**法币单位*/
@property (nonatomic, strong) UILabel * unitLabel;

@property (nonatomic, strong) UIImageView * payWayImageView;

@property (nonatomic, strong) UIButton * infoButton;

@end

@implementation CAOrderListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

+(CGFloat)getCellHeight{
    return 195;
}

-(void)initSubViews{
    
    self.usernameLabel   = [self creatLabel];
    self.usernameLabel.textColor = HexRGB(0x006cdb);
    self.usernameLabel.font = FONT_REGULAR_SIZE(18);
    
    self.orderTimeLabel = [self creatLabel];
//    self.orderStateLabel.textColor = HexRGB(0x29b778);
    
    self.unitPriceNotiLabel = [self creatLabel];
    self.numberNotiLabel = [self creatLabel];
    self.legalNumberNotiLabel = [self creatLabel];
    
    self.orderStateLabel = [self creatLabel];
    self.orderTypeLabel = [self creatLabel];
    self.unitPriceLabel = [self creatLabel];
    self.numberLabel = [self creatLabel];
    self.unitLabel = [self creatLabel];

    self.legalNumberLabel = [self creatLabel];
    self.legalNumberLabel.textColor = HexRGB(0x191d26);
    self.legalNumberLabel.font = FONT_REGULAR_SIZE(18);
    
    NSArray * leftArray = @[self.usernameLabel,self.orderTimeLabel,self.unitPriceNotiLabel,self.numberNotiLabel,self.legalNumberNotiLabel];
    NSArray * rightArray = @[self.orderStateLabel,self.orderTypeLabel,self.unitPriceLabel,self.numberLabel,self.unitLabel];
    
    [leftArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
    }];
    [rightArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
    
    [leftArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx==0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(15);
            }];
        }else{
            UIView * top = leftArray[idx-1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(top.mas_bottom).offset(5);
            }];
        }
    }];
    [rightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx==0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(15);
            }];
        }else{
            UIView * top = leftArray[idx-1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(top.mas_bottom).offset(5);
            }];
        }
    }];
    
    [self.legalNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unitLabel.mas_left).offset(-2);
        make.bottom.equalTo(self.unitLabel.mas_bottom);
    }];
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.infoButton];
    self.infoButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    self.infoButton.backgroundColor = HexRGB(0x3744a4);
    [self.infoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.infoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.infoButton.layer.masksToBounds = YES;
    self.infoButton.layer.cornerRadius = 2;
    self.infoButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.infoButton.enabled = NO;
    [self.infoButton setTitle:CALanguages(@"查看详情") forState:UIControlStateNormal];
    
    [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderStateLabel.mas_right);
        make.top.equalTo(self.legalNumberLabel.mas_bottom).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    self.payWayImageView = [UIImageView new];
    [self.contentView addSubview:self.payWayImageView];
    [self.payWayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    UIView * lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
}

-(void)setModel:(CAOrderModel *)model{
    _model = model;
    
    self.usernameLabel.text = NSStringFormat(@"%@",model.otc_nick_name);
    self.orderStateLabel.text = model.state_name;
    self.orderTimeLabel.text = model.updated_at;
    self.orderTypeLabel.text = model.sell_or_buy;
    self.unitPriceNotiLabel.text = CALanguages(@"单价");
    self.unitPriceLabel.text = NSStringFormat(@"%@",model.current_unit_price);
    self.numberNotiLabel.text = CALanguages(@"数字币数量");
    self.numberLabel.text = NSStringFormat(@"%@",model.currency_amount);
    self.legalNumberNotiLabel.text = CALanguages(@"法币数量");
    self.unitLabel.text = NSStringFormat(@"%@",model.fiat_type);
    self.legalNumberLabel.text = NSStringFormat(@"%@",model.fiat_amount);
    self.orderStateLabel.textColor = [UIColor colorWithHexString:model.state_color];
    
    
    if ([model.mode_of_payment isEqualToString:CAPayBank]) {
        self.payWayImageView.image = IMAGE_NAMED(@"Bankcard");
    }else if ([model.mode_of_payment isEqualToString:CAPayAli]){
        self.payWayImageView.image = IMAGE_NAMED(@"Alipay");
    }else if ([model.mode_of_payment isEqualToString:CAPayWechat]){
        self.payWayImageView.image = IMAGE_NAMED(@"WeChat");
    }
    
}

-(UILabel *)creatLabel{
    UILabel * label = [UILabel new];
    label.font = FONT_REGULAR_SIZE(14);
    label.textColor = HexRGB(0x969dbf);
    [self.contentView addSubview:label];
    
    return label;
}

@end
