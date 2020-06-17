//
//  CADeepListTableViewCell.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CADeepListTableViewCell.h"
#import "CADeepListView.h"

@interface CADeepListTableViewCell()
{
    UILabel * _leftLabel;
    UILabel * _centerLabel;
    UILabel * _rightLabel;
}
@property (nonatomic, strong) UIView * deepListViews;
@property (nonatomic, strong) NSMutableArray * buyListViewArr;
@property (nonatomic, strong) NSMutableArray * sellListViewArr;

@end

@implementation CADeepListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.buyListViewArr = @[].mutableCopy;
        self.sellListViewArr = @[].mutableCopy;
        [self initTop];
    }
    return self;
}

-(void)setAsk_code:(NSString *)ask_code{
    _ask_code = ask_code;
    NSString * ask = @"";
    if (ask_code.length) {
        ask = [ask_code uppercaseString];
    }
    _leftLabel.text = NSStringFormat(@"%@ %@(%@)",CALanguages(@"买盘"),CALanguages(@"数量"),ask);
    _rightLabel.text = NSStringFormat(@"%@(%@) %@",CALanguages(@"数量"),ask,CALanguages(@"卖盘"));

}
-(void)setBid_code:(NSString *)bid_code{
    _bid_code = bid_code;
    NSString * bid = @"";
    if (_bid_code.length) {
        bid = [_bid_code uppercaseString];
    }
    _centerLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"价格"),bid);

}

-(void)initTop{
    UIView * topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    _leftLabel = [self creatLabel];
    [topView addSubview:_leftLabel];
    _centerLabel = [self creatLabel];
    [topView addSubview:_centerLabel];
    _rightLabel = [self creatLabel];
    [topView addSubview:_rightLabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(10);
        make.centerY.equalTo(topView);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(topView);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-10);
        make.centerY.equalTo(topView);
    }];
    
    self.deepListViews = [UIView new];
    [self.contentView addSubview:self.deepListViews];

    [self.deepListViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    CADeepListView * lastView = nil;
    for (int i=0; i<20; i++) {
      
        CADeepListView * view = [[CADeepListView alloc] init];
        [self.deepListViews addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deepListViews);
            make.top.equalTo(lastView?lastView.mas_bottom:self.deepListViews);
            make.width.equalTo(self.deepListViews).multipliedBy(0.5);
            make.height.mas_equalTo(30);
        }];
        lastView = view;
        [self.buyListViewArr addObject:view];
        
    }
    CADeepListView * lastViewr = nil;
    for (int i=0; i<20; i++) {
        
        CADeepListView * view = [[CADeepListView alloc] init];
        [self.deepListViews addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deepListViews);
            make.top.equalTo(lastViewr?lastViewr.mas_bottom:self.deepListViews);
            make.width.equalTo(self.deepListViews).multipliedBy(0.5);
            make.height.mas_equalTo(30);
        }];
        lastViewr = view;
        [self.sellListViewArr addObject:view];
    }
    
}
-(UILabel*)creatLabel{
    UILabel * label = [UILabel new];
    label.font = FONT_REGULAR_SIZE(11);
    label.textColor = RGB(133, 189, 181);
    return label;
}

-(void)fresh:(NSArray *)buyArr sellArr:(NSArray *)sellArr{
    
        
        for (int i=0; i<20; i++) {
            CADeepListView * view = self.buyListViewArr[i];
            
            if (buyArr.count>i) {
                NSDictionary * data = buyArr[i];
                view.number = NSStringFormat(@"%d",i+1);
                view.price = NSStringFormat(@"%@",data[@"price"]);
                view.num = NSStringFormat(@"%@",data[@"volume"]);
                view.type = 0;
                [view setNeedsDisplay];
            }else{
                [view clear];
            }
        }
        
        for (int i=0; i<20; i++) {
            CADeepListView * view = self.sellListViewArr[i];
            if (sellArr.count>i) {
                NSDictionary * data = sellArr[i];
                view.number = NSStringFormat(@"%d",i+1);
    //            view.radio = [data[0] floatValue];
                 view.price = NSStringFormat(@"%@",data[@"price"]);
                           view.num = NSStringFormat(@"%@",data[@"volume"]);
                view.type = 1;
                [view setNeedsDisplay];
            }else{
                [view clear];
            }
        }
    
}

@end
