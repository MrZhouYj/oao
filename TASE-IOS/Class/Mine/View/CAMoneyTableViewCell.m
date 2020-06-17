//
//  CAMoneyTableViewCell.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMoneyTableViewCell.h"

@interface CAMoneyTableViewCell()

@property (nonatomic, strong) UILabel * priceNameLabel;

@property (nonatomic, strong) UILabel * enableUseLabel;

@property (nonatomic, strong) UILabel * localLabel;

@end

@implementation CAMoneyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    self.priceNameLabel = [UILabel new];
    [self.contentView addSubview:self.priceNameLabel];
    
    UILabel * notiLabel = [UILabel new];
    [self.contentView addSubview:notiLabel];
    notiLabel.textColor = RGB(150, 157, 191);
    notiLabel.font = FONT_MEDIUM_SIZE(13);
    notiLabel.text = CALanguages(@"可用");
    
    self.enableUseLabel = [UILabel new];
    [self.contentView addSubview:self.enableUseLabel];
    self.enableUseLabel.textColor = RGB(13, 13, 35);
    self.enableUseLabel.font = FONT_MEDIUM_SIZE(13);
    
    
    self.localLabel = [UILabel new];
    [self.contentView addSubview:self.localLabel];
    self.localLabel.textColor = RGB(133, 139, 181);
    self.localLabel.font = FONT_MEDIUM_SIZE(13);
    self.localLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel * lockNotiLabel = [UILabel new];
    [self.contentView addSubview:lockNotiLabel];
    lockNotiLabel.textColor = RGB(133, 139, 181);
    lockNotiLabel.font = FONT_MEDIUM_SIZE(13);
    
     lockNotiLabel.text = CALanguages(@"锁定");
    
    UIImageView * lockImageView = [UIImageView new];
    [self.contentView addSubview:lockImageView];
    lockImageView.image = IMAGE_NAMED(@"lock");
//布局
    [self.priceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    [self.enableUseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceNameLabel.mas_left);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enableUseLabel.mas_left);
        make.bottom.equalTo(self.enableUseLabel.mas_top).offset(-5);
    }];
    [self.localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.enableUseLabel.mas_bottom);
        make.width.equalTo(@100);
    }];
    [lockNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.localLabel.mas_right);
        make.bottom.equalTo(self.localLabel.mas_top).offset(-5);
    }];
    [lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lockNotiLabel.mas_left).offset(-5);
        make.centerY.equalTo(lockNotiLabel);
        make.width.height.equalTo(@11);
    }];
    
    UIView * lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.5);
    }];
    
}

-(void)setModel:(CACurrencyMoneyModel *)model{
    _model = model;
    
    NSString * mainText = model.currency_code_big;
    NSString * subText = NSStringFormat(@" %@",model.fiat);
    
    NSDictionary * mut = @{
                           NSForegroundColorAttributeName:HexRGB(0x006cdb),
                           NSFontAttributeName:[UIFont boldSystemFontOfSize:17]
                           };
    NSDictionary * mut1 = @{
                            NSForegroundColorAttributeName:RGB(149,156,190),
                            NSFontAttributeName:FONT_MEDIUM_SIZE(13)
                            };
    
    NSMutableAttributedString * mutAttr = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@%@",mainText,subText)];
    [mutAttr addAttributes:mut range:NSMakeRange(0, mainText.length)];
    [mutAttr addAttributes:mut1 range:NSMakeRange(mainText.length, subText.length)];
    self.priceNameLabel.attributedText = mutAttr;
    self.enableUseLabel.text = NSStringFormat(@"%@",model.balance);
    self.localLabel.text = NSStringFormat(@"%@",model.locked);
   
}

@end
