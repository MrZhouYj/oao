//
//  CASearchTableViewCell.m
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASearchTableViewCell.h"

@interface CASearchTableViewCell()


@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UILabel * leftSmallLabel;

@property (nonatomic, strong) UILabel * rightPriceLabel;
@end

@implementation CASearchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubviews];
    }
    return self;
}

-(void)layoutSubviews{
    
    UIView * bgView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    bgView.dk_backgroundColorPicker = DKColorPickerWithKey(TableViewSelectedBackgroundColor);
    self.selectedBackgroundView = bgView;
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self).offset(15);
         make.centerY.equalTo(self);
     }];
    
     [self.leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.leftLabel.mas_right);
         make.bottom.equalTo(self.leftLabel.mas_bottom);
     }];
    
    [self.rightPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
     
}

-(void)initSubviews{
    
    self.leftLabel = [UILabel new];
    [self addSubview:self.leftLabel];
    self.leftSmallLabel = [UILabel new];
    [self addSubview:self.leftSmallLabel];
    self.rightPriceLabel = [UILabel new];
    [self addSubview:self.rightPriceLabel];
    
    
    self.leftLabel.font = FONT_SEMOBOLD_SIZE(14);
    self.leftLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
       
    self.leftSmallLabel.font = FONT_REGULAR_SIZE(10);
    self.leftSmallLabel.dk_textColorPicker = DKColorPickerWithKey(SmallGrayTextColor_969ec1);
    
    self.rightPriceLabel.font = FONT_REGULAR_SIZE(13);
    self.rightPriceLabel.dk_textColorPicker = DKColorPickerWithKey(SmallGrayTextColor_969ec1);

    UIView * lineView = [UIView new];
    [self addSubview:lineView];
    
    lineView.dk_backgroundColorPicker  = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    
}

-(void)setCountryModel:(CACountryModel *)countryModel{
    _countryModel = countryModel;
    
    self.leftLabel.text = countryModel.name;
    
    self.rightPriceLabel.text = countryModel.code;
    
}


-(void)setModel:(CASymbolsModel *)model{
    _model = model;
    
    self.leftLabel.text = NSStringFormat(@"%@",model.ask_unit);
    self.leftSmallLabel.text = NSStringFormat(@"/%@",model.bid_unit);
    self.rightPriceLabel.text = NSStringFormat(@"%@",model.last_price);
    if ([model.price_change_ratio containsString:@"-"]) {
        self.rightPriceLabel.textColor = [UIColor decreaseColor];
    }else{
        self.rightPriceLabel.textColor = [UIColor increaseColor];
    }
}

@end
