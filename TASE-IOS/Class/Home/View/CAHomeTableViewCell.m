//
//  CAHomeTableViewCell.m
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAHomeTableViewCell.h"

@interface CAHomeTableViewCell()

@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UILabel * leftSmallLabel;

@property (nonatomic, strong) UILabel * leftBottomLabel;

@property (nonatomic, strong) UILabel * centerLabel;

@property (nonatomic, strong) UILabel * centerBottomLabel;

@property (nonatomic, strong) UILabel * rightLabel;

@end

@implementation CAHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.showInHome = YES;
        [self initSubViews];
        self.cellStyle = 1;
    }
    return self;
}

-(void)initSubViews{
    
    self.leftLabel = [UILabel new];
    [self.contentView addSubview:self.leftLabel];
    self.leftSmallLabel = [UILabel new];
    [self.contentView addSubview:self.leftSmallLabel];
    self.leftBottomLabel = [UILabel new];
    [self.contentView addSubview:self.leftBottomLabel];
    self.centerLabel = [UILabel new];
    [self.contentView addSubview:self.centerLabel];
    self.centerBottomLabel = [UILabel new];
    [self.contentView addSubview:self.centerBottomLabel];
    self.rightLabel = [UILabel new];
    [self.contentView addSubview:self.rightLabel];
    
    self.leftLabel.font = FONT_SEMOBOLD_SIZE(15);
    self.leftLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
    
    self.leftSmallLabel.font = FONT_REGULAR_SIZE(10);
    self.leftSmallLabel.dk_textColorPicker = DKColorPickerWithKey(SmallGrayTextColor_969ec1);
    
    self.leftBottomLabel.font = FONT_REGULAR_SIZE(11);
    self.leftBottomLabel.dk_textColorPicker = DKColorPickerWithKey(SmallGrayTextColor_969ec1);
    
    self.centerLabel.font = FONT_SEMOBOLD_SIZE(15);
    self.centerLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
    
    self.centerBottomLabel.font = FONT_REGULAR_SIZE(11);
    self.centerBottomLabel.dk_textColorPicker = DKColorPickerWithKey(SmallGrayTextColor_969ec1);

    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@74);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.rightLabel.layer.cornerRadius = 2;
    self.rightLabel.layer.masksToBounds = YES;
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.font = ROBOTO_FONT_MEDIUM_SIZE(13);
    
    UIView * lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

-(void)setModel:(CASymbolsModel *)model{
    _model = model;
    
    if (model) {
        self.leftLabel.text = NSStringFormat(@"%@",model.ask_unit);
        self.leftSmallLabel.text = NSStringFormat(@"/%@",model.bid_unit);
        self.centerLabel.text = NSStringFormat(@"%@",model.last_price);
        
        if (self.cellStyle==1) {
            self.rightLabel.text = NSStringFormat(@"%@",model.price_change_ratio);
            self.rightLabel.textColor = [UIColor whiteColor];
            if ([model.price_change_ratio containsString:@"-"]) {
                self.rightLabel.backgroundColor = [UIColor decreaseColor];
            }else{
                self.rightLabel.backgroundColor = [UIColor increaseColor];
            }
        }else{
            self.rightLabel.text = NSStringFormat(@"%@",[CASymbolsModel formatNumber:model.turnover]);
        }
        if (!self.showInHome) {
            self.leftBottomLabel.text = NSStringFormat(@"%@%@",CALanguages(@"24H量"),model.volume);
            self.centerBottomLabel.text = NSStringFormat(@"%@%@",model.ask_s,model.ask_m);
        }
    }
}

-(void)layoutSubviews{
    
    if (self.showInHome) {
        

        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
       
        
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.leftLabel);
        }];
        
    }else{
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(8);
        }];
        
       
        [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
        
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.leftLabel.mas_top);
        }];
        
        
        [self.centerBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerLabel);
            make.centerY.equalTo(self.leftBottomLabel);
        }];
    }
    
    [self.leftSmallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right);
        make.bottom.equalTo(self.leftLabel.mas_bottom).offset(-2);
    }];
}

-(void)setCellStyle:(int)cellStyle{
    _cellStyle = cellStyle;
    if (cellStyle==1) {
        //涨幅榜
        self.rightLabel.textColor = [UIColor whiteColor];
        self.rightLabel.backgroundColor = RGB(46, 193, 119);
        
    }else if (cellStyle==2){
        //成交额榜
        self.rightLabel.textColor = RGBA(0, 108, 219, 1);
        self.rightLabel.backgroundColor = RGBA(0, 108, 219, 0.08);
        
    }
}

@end
