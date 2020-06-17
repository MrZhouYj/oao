//
//  CABBtradingHeaderRightView.m
//  TASE-IOS
//
//   9/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBtradingHeaderRightView.h"
#import "CARowView.h"

@interface CABBtradingHeaderRightView()
<CARowViewDelegata>
{
    NSInteger _curIndex;
    NSString * _lastPrice;
    UILabel * notiPriceLabel;
    UILabel * notiNumberLabel;
}
@property (nonatomic, strong) CABBTradingListView * bidView;

@property (nonatomic, strong) CABBTradingListView * askView;
//放 卖盘 买盘 centerview
@property (nonatomic, strong) UIView * centerContentView;

@property (nonatomic, strong) UIView * centerView;

@property (nonatomic, strong) UILabel * centerPriceLabel;

@property (nonatomic, strong) UIImageView * menuImageView;

@property (nonatomic, strong) CARowView * changeDeepView;

@property (nonatomic, strong) UILabel * centerSubPriceLabel;
/**
 0 默认
 1 买盘
 2 卖盘
 */
@property (nonatomic, assign) int showType;

@end

@implementation CABBtradingHeaderRightView

-(UIImageView *)menuImageView{
    if (!_menuImageView) {
        _menuImageView = [UIImageView new];
    
    }
    return _menuImageView;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];

        _curIndex  = 0;
        [self initSubViews];
    }
    return self;
}

-(void)CARowView_didChangeRowState:(int)state rowView:(nonnull CARowView *)rowView{
    
    if (rowView.tag==1000) {
        
        NSArray * array = @[@"1",@"2",@"3",@"4",@"5",@"6"];
        
        [CAActionSheetView showActionSheet:array selectIndex:_curIndex click:^(NSInteger index) {
            
            self->_curIndex = index;
            self.changeDeepView.title = [NSString stringWithFormat:@"%@%@",CALanguages(@"深度"),array[index]];
        }];
    }
}

-(void)languageDidChange{
    notiPriceLabel.text = CALanguages(@"价格") ;
    notiNumberLabel.text = CALanguages(@"数量");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initSubViews{
    
    notiPriceLabel = [UILabel new];
    [self addSubview:notiPriceLabel];
    
    notiPriceLabel.font = FONT_REGULAR_SIZE(13);
    [notiPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    notiNumberLabel = [UILabel new];
    [self addSubview:notiNumberLabel];
    
    notiNumberLabel.font = FONT_REGULAR_SIZE(13);
    [notiNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
    }];
    [self languageDidChange];
    
    notiPriceLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
    notiNumberLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
    
    self.centerContentView = [UIView new];
    [self addSubview:self.centerContentView];
    
    
#pragma mark 底部按钮 Start
    UIView * changeTypeView = [UIView new];
    [self addSubview:changeTypeView];
    changeTypeView.backgroundColor = RGB(235,243,252);
    changeTypeView.layer.masksToBounds = YES;
    changeTypeView.layer.cornerRadius = 2;
    [changeTypeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTypeKCick)]];
    [changeTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.height.equalTo(@32);
    }];
    [changeTypeView addSubview:self.menuImageView];
    
    
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(changeTypeView);
    }];
    
    
    CARowView * changeDeepView = [CARowView new];
    [self addSubview:changeDeepView];
    self.changeDeepView = changeDeepView;
    
    changeDeepView.backgroundColor = RGB(235,243,252);
    changeDeepView.layer.masksToBounds = YES;
    changeDeepView.layer.cornerRadius = 2;
    changeDeepView.title = @"深度1";
    changeDeepView.titleFont = FONT_REGULAR_SIZE(13);
    changeDeepView.tintColor = RGB(132,172,233);
    changeDeepView.delegata = self;
    changeDeepView.titleColor = RGB(132,172,233);
    changeDeepView.up = NO;
    changeDeepView.tag = 1000;
    changeDeepView.hidden = YES;
    
    [changeDeepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(changeTypeView.mas_height);
        make.right.equalTo(changeTypeView.mas_left).offset(-10);
    }];
    
   
    [self.centerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(notiNumberLabel.mas_bottom).offset(10);
        make.bottom.equalTo(changeDeepView.mas_top).offset(-10);
    }];
    
#pragma mark 设置深度图 买 卖
    self.askView = [CABBTradingListView new];
    [self.centerContentView addSubview:self.askView];
    
    self.bidView = [CABBTradingListView new];
    [self.centerContentView addSubview:self.bidView];
 
#pragma mark 设置中间显示
    self.centerPriceLabel = [UILabel new];
    [self.centerView addSubview:self.centerPriceLabel];
    self.centerPriceLabel.font = ROBOTO_FONT_MEDIUM_SIZE(15);
    
    self.centerSubPriceLabel = [UILabel new];
    [self.centerView addSubview:self.centerSubPriceLabel];
    self.centerSubPriceLabel.font = ROBOTO_FONT_REGULAR_SIZE(12);
    self.centerSubPriceLabel.textColor = RGB(165,166,191);
    
    [self.centerPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView);
        make.bottom.equalTo(self.centerSubPriceLabel.mas_top);
        make.width.equalTo(self.centerView.mas_width);
    }];
    
    [self.centerSubPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerPriceLabel);
        make.width.equalTo(self.centerView.mas_width);
        make.bottom.equalTo(self.centerView).offset(-7);
    }];
    
    [self.centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerClick)]];
    
    self.showType = 0;
}

-(void)centerClick{
    
    [self routerEventWithName:@"listViewChoosePrice" userInfo:_lastPrice];
}

-(void)updateCenterData:(NSArray*)bid_rate last_price:(NSString*)last_price{
    
    if (_lastPrice.floatValue>last_price.floatValue) {
        self.centerPriceLabel.textColor = [UIColor decreaseColor];
    }else{
        self.centerPriceLabel.textColor = [UIColor increaseColor];
    }
    self.centerPriceLabel.text = NSStringFormat(@"%@",last_price);
    
    _lastPrice = last_price;
    
    if (bid_rate.count<3) {
        return;
    }
    
    self.centerSubPriceLabel.text = NSStringFormat(@"≈%.2f %@",last_price.floatValue*[bid_rate[0] floatValue],bid_rate[2]);
    
}

-(void)changeTypeKCick{
    
    self.showType = self.showType+1>2?0:self.showType+1;
    
}

-(void)updateUI{
    
    switch (self.showType) {
        case 0:
        {
            [self.askView freshWithData:self.asksArray showNumber:5 tradingType:TradingSell];
            [self.bidView freshWithData:self.bidsArray showNumber:5 tradingType:TradingBuy];
        }
            break;
        case 1:
        {
             [self.bidView freshWithData:self.bidsArray showNumber:10 tradingType:TradingBuy];
        }
            break;
        case 2:
        {
            
            [self.askView freshWithData:self.asksArray showNumber:10 tradingType:TradingSell];
        }
            break;
            
        default:
            break;
    }
}

-(void)setShowType:(int)showType{
    _showType = showType;
    
    if (_showType==0) {
        //展示买盘和 卖盘
        
        self.bidView.hidden = NO;
        self.askView.hidden = NO;
        
        self.menuImageView.image = IMAGE_NAMED(@"bb_bid_selling");
        
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerContentView);
            make.left.right.equalTo(self.centerContentView);
            make.height.equalTo(@50);
        }];
        
        [self.askView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.centerContentView);
            make.bottom.equalTo(self.centerView.mas_top);
        }];
    
        [self.bidView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.centerContentView);
            make.top.equalTo(self.centerView.mas_bottom);
        }];
        
        self.centerPriceLabel.textColor = [UIColor decreaseColor];
        
    }else if (_showType==1){
        //展示买盘
        self.bidView.hidden = NO;
        self.askView.hidden = YES;
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.centerContentView);
            make.height.equalTo(@50);
        }];
        [self.bidView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.centerContentView);
            make.top.equalTo(self.centerView.mas_bottom);
        }];
        self.menuImageView.image = IMAGE_NAMED(@"bb_bid");
       
        self.centerPriceLabel.textColor = [UIColor increaseColor];
        
    }else if (_showType==2){
        //展示卖盘
        self.bidView.hidden = YES;
        self.askView.hidden = NO;
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.centerContentView);
            make.height.equalTo(@45);
        }];
        
        [self.askView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.centerContentView);
            make.bottom.equalTo(self.centerView.mas_top);
        }];
        self.menuImageView.image = IMAGE_NAMED(@"bb_selling");
        self.centerPriceLabel.textColor = [UIColor decreaseColor];
        
    }
    
    [self updateUI];
}

-(UIView*)centerView{
    if (!_centerView) {
        _centerView = [UIView new];
        [self.centerContentView addSubview: _centerView];
    }
    return _centerView;
}

@end
