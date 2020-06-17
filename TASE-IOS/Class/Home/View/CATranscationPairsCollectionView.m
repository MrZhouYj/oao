//
//  CATranscationPairsCollectionView.m
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CATranscationPairsCollectionView.h"

@interface CATranscationPairsCollectionView()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *labelTop;
@property (nonatomic, strong) UILabel *labelMid;
@property (nonatomic, strong) UILabel *labelBtm;

@end

@implementation CATranscationPairsCollectionView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    UILabel * leftLabel = [self creatLabel:RGB(0, 145, 219)];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.height.mas_equalTo(26);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    UILabel * rightLabel = [self creatLabel:RGB(55, 68, 164)];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.height.equalTo(leftLabel);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    
    UIView * bottomView = [UIView new];
    [self.contentView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(leftLabel.mas_bottom);
    }];
    
    UILabel * labelTop = [UILabel new];
    [bottomView addSubview:labelTop];
    labelTop.font = ROBOTO_FONT_MEDIUM_SIZE(17);
    labelTop.textAlignment = NSTextAlignmentCenter;
    labelTop.textColor = HexRGB(0x191d26);
    
    UILabel * labelMid = [UILabel new];
    [bottomView addSubview:labelMid];
    labelMid.font = FONT_MEDIUM_SIZE(12);
    labelMid.textAlignment = NSTextAlignmentCenter;
    
    UILabel * labelBtm = [UILabel new];
    [bottomView addSubview:labelBtm];
    labelBtm.textAlignment = NSTextAlignmentCenter;
    labelBtm.font = ROBOTO_FONT_REGULAR_SIZE(12);
    labelBtm.textColor = HexRGB(0x858bb5);
    
    
    NSArray * subArray = @[labelTop,labelMid,labelBtm];
    [subArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
    [subArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bottomView);
    }];
    
    self.labelTop = labelTop;
    self.labelMid = labelMid;
    self.labelBtm = labelBtm;
    
    self.leftLabel = leftLabel;
    self.rightLabel = rightLabel;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClick)]];
}

-(void)selfClick{
    
    [self routerEventWithName:NSStringFromClass([self class]) userInfo:self.model];
}

-(void)setModel:(CASymbolsModel *)model{
    _model = model;
    
    if (model) {
        
        self.leftLabel.text = NSStringFormat(@"%@",model.ask_unit);
        self.rightLabel.text = NSStringFormat(@"%@",model.bid_unit);
        
        self.labelTop.text = NSStringFormat(@"%@",model.last_price);
        self.labelMid.text = NSStringFormat(@"%@",model.price_change_ratio);
        self.labelBtm.text = NSStringFormat(@"≈%@ %@",model.ask_m,model.ask_c);

        if ([model.price_change_ratio containsString:@"-"]) {
            
            self.labelMid.textColor = [UIColor decreaseColor];
        }else{
            
            self.labelMid.textColor = [UIColor increaseColor];
        }
    }
}


-(UILabel*)creatLabel:(UIColor*)backGroundColor{
    UILabel * label = [UILabel new];
    [self.contentView addSubview:label];
    label.backgroundColor = backGroundColor;
    label.font = FONT_SEMOBOLD_SIZE(13);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
    
}

@end
