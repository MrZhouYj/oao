//
//  CADealTableViewCell.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CADealTableViewCell.h"

@interface CADealTableViewCell()

@property (nonatomic, strong) NSMutableArray * viewsArray;

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * numLabel;
@end

@implementation CADealTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timeLabel = [self creatLabel];
        self.typeLabel = [self creatLabel];
        self.priceLabel = [self creatLabel];
        self.numLabel = [self creatLabel];
        
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.typeLabel.textAlignment = NSTextAlignmentRight;
        self.numLabel.textAlignment = NSTextAlignmentRight;
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(80);
        }];
        
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.timeLabel.mas_right);
            make.width.mas_equalTo(50);
        }];
        
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo((MainWidth-50-80-30)*0.35);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.numLabel.mas_left).offset(-5);
            make.left.equalTo(self.typeLabel).offset(10);
        }];
        
    }
    return self;
}

-(void)setDealData:(NSDictionary *)dealData{
    _dealData = dealData;
    
    [self setNormalStyle:self.timeLabel];
    [self setNormalStyle:self.typeLabel];
    [self setNormalStyle:self.priceLabel];
    [self setNormalStyle:self.numLabel];
    
//    amount = 24.553;
//    closing_time = 15:43:13;
//    price = 146.349;
//    sell_or_buy = bid;
//    direction = 买入;
    
    self.timeLabel.text = NSStringFormat(@"%@",dealData[@"closing_time"]);
    self.typeLabel.text = NSStringFormat(@"%@",dealData[@"direction"]);
    if ([dealData[@"sell_or_buy"] isEqualToString:@"bid"]) {
        self.typeLabel.textColor = [UIColor decreaseColor];
    }else{
        self.typeLabel.textColor = [UIColor increaseColor];
    }
    
    self.priceLabel.text = NSStringFormat(@"%@",dealData[@"price"]);
    self.numLabel.text = NSStringFormat(@"%@",dealData[@"amount"]);
    
}

-(void)setTitleStyle{
    
    [self titleStyle:self.timeLabel];
    [self titleStyle:self.typeLabel];
    [self titleStyle:self.priceLabel];
    [self titleStyle:self.numLabel];
    
    self.timeLabel.text = CALanguages(@"时间");
    self.typeLabel.text = CALanguages(@"方向");
    self.priceLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"价格"),@"USDT");
    self.numLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"数量"),@"XZC");
    
}

-(void)titleStyle:(UILabel*)label{
    label.textColor = RGB(133, 139, 181);
    label.font = FONT_REGULAR_SIZE(11);
}

-(void)setNormalStyle:(UILabel*)label{
    label.textColor = [UIColor colorWithRGBHex:0x6d6e7c];
    label.font = FONT_REGULAR_SIZE(13);
}
-(UILabel*)creatLabel{
    UILabel * label = [[UILabel alloc] init];
    [self.contentView addSubview:label];
    
    return label;
}


@end
