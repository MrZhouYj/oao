//
//  CFKLineFullScreenViewController.m
//
//  Created by Zhimi on 2018/9/3.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import "LineKFullScreenViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "Y_KLineModel.h"
#import "BTBiModel.h"
#import "BTMarketModel.h"
#import "BTDealMarketModel.h"
#import "Y_KLineView.h"
#import "Y_KLineMainView.h"
#import "CASymbolsModel.h"

@interface LineKFullScreenViewController ()<Y_StockChartViewDelegate,Y_StockChartViewDataSource>
{
    NSDictionary * _currentKline;
}
@property (strong, nonatomic)  UILabel *priceLabel;
@property (strong, nonatomic)  UILabel *radioLabel;
@property (strong, nonatomic)  UILabel *zfLabel;
@property (strong, nonatomic)  UILabel *highLabel;
@property (strong, nonatomic)  UILabel *lowLabel;
@property (strong, nonatomic)  UILabel *volLabel;
@property (nonatomic, assign) Y_KLineType currentKLineType;

@property (strong, nonatomic)  UIButton *closeButton;
@property (strong, nonatomic)  Y_StockChartView *lineKView;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *period;

@property (nonatomic, assign) int klineRequestID;
@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat requestInterval;
@property (nonatomic, strong) NSDictionary * latest_bar;

@end

@implementation LineKFullScreenViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    _lineKView.isFullScreen = YES;

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [[CASocket shareSocket] removeDelegate:self];
    [[CASocket shareSocket] unsubCurrentReq];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteBackGroundColor);
    
    [self setuptopView];
    
    _lineKView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(SafeAreaTopHeight+2, 50, MainHeight - SafeAreaBottomHeight-SafeAreaTopHeight-2, MainWidth-50 + 0)];
    
    _lineKView.isFullScreen = YES;
    
    _lineKView.itemModels = @[
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"分时") klineType:KLineTypeTimeLine type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1分") klineType:KLineType1Min type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"5分") klineType:KLineType5Min type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"15分") klineType:KLineType15Min type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"30分") klineType:KLineType30Min type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1小时") klineType:KLineType1Hour type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"日线") klineType:KLineType1Day type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1周") klineType:KLineType1Week type:Y_StockChartcenterViewTypeKline],
                              [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1月") klineType:KLineType1Month type:Y_StockChartcenterViewTypeKline],
                              ];

    _lineKView.delegate = self;
    [self.view addSubview:_lineKView];
    [self addLinesView];
    self.lineKView.lastKlineType = self.lastType;
    self.lineKView.dataSource = self;//设置datasource 开始出发请求数据
    
}
-(void)webSocketDidOpen{
    [self sendKlineWebSocket];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[CASocket shareSocket] addDelegate:self];
    NSLog(@"页面出现了  哈哈哈");
    [self sendKlineWebSocket];
    [self sendMessageToSocket];
}
-(void)sendKlineWebSocket{
    
    [[CASocket shareSocket] sendDataToSever:[self getKline]];
}
-(void)sendMessageToSocket{
   
    [[CASocket shareSocket] sendDataToSever:[self getLatestBar]];

}

#pragma mark kline 频道拼接
-(NSDictionary*)getKline{
    NSDictionary * dic = @{
        @"channel" : @"kline",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"period":NSStringFormat(@"%@",self.period)
    };
    if (_currentKline) {
        [[CASocket shareSocket] unsub:_currentKline];
    }
    _currentKline = [CASocket getSub:dic];
    return _currentKline;
}
#pragma mark getLatestBar 频道拼接
-(NSDictionary*)getLatestBar{
    NSDictionary * dic = @{
        @"channel" : @"latest_bar",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
}

-(void)webSocket:(CASocket *)webSocket didReceiveMessage:(NSDictionary *)message{

    if (message[@"channel"]) {
        if ([message[@"channel"] isEqualToString:[self getLatestBar][@"subscribe"]]){
            
            _latest_bar = message[@"content"];
            [self freshTopViewData];
        }else if ([message[@"channel"] isEqualToString:_currentKline[@"subscribe"]]){
            NSArray * newKline = message[@"content"][@"k"];
            NSLog(@"%@",message);
            if (self.groupModel&&[self.groupModel.type isEqualToString:self.type]&&newKline.count) {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    [self.groupModel addData:newKline];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.lineKView reloadData];
                    });
                });
            }
        }
    }
}

-(void)freshTopViewData{
    
    UIColor * showColor = [UIColor increaseColor];
    NSString * priceText = @"--";
    NSString * zfText = @"--";
    NSString * price_change_ratio = @"";
    NSString * unit_sign = @"";
    
    NSString * high = @"--";
    NSString * low = @"--";
    NSString * volume = @"--";
    
    if (_latest_bar) {
        
        priceText = NSStringFormat(@"%@",_latest_bar[@"last_price"]);
        NSArray * ask_rate =  _latest_bar[@"ask_rate"];
        price_change_ratio = NSStringFormat(@"%@",_latest_bar[@"price_change_ratio"]);
        
        if ([price_change_ratio containsString:@"-"]) {
            showColor = [UIColor decreaseColor];
        }
        
        if (ask_rate.count==3) {
            NSString * ask_rate_number = ask_rate.firstObject;
            unit_sign = ask_rate.lastObject;
             zfText = NSStringFormat(@"≈%@%@",ask_rate_number,unit_sign);
        }
        
        NSDictionary * ticker = _latest_bar[@"ticker"];
        if (ticker) {
            high = ticker[@"high"];
            low = ticker[@"low"];
            volume = ticker[@"volume"];
        }
    }
    _priceLabel.text = priceText;
    self.zfLabel.text = zfText;
    
    NSString * highNoti = CALanguages(@"高");
    NSString * lowNoti = CALanguages(@"低");
    NSString * volueNoti = @"24H";

    _volLabel.text = NSStringFormat(@"%@ %@",volueNoti,volume);
    _lowLabel.text = NSStringFormat(@"%@ %@",lowNoti,low);
    _highLabel.text = NSStringFormat(@"%@ %@",highNoti,high);
    _radioLabel.text = NSStringFormat(@"%@",price_change_ratio);
    _radioLabel.textColor = showColor;
    _priceLabel.textColor = showColor;
    
    [_volLabel setRangeSize:1 font:9 starIndex:0 index:volueNoti.length+1 rangeColor:RGB(98, 124, 158)];
    [_lowLabel setRangeSize:1 font:9 starIndex:0 index:lowNoti.length+1 rangeColor:RGB(98, 124, 158)];
    [_highLabel setRangeSize:1 font:9 starIndex:0 index:highNoti.length+1 rangeColor:RGB(98, 124, 158)];
    

}


-(void)orientationDidChange{
    UIDeviceOrientation  orientation = [[UIDevice currentDevice] orientation];
    if (orientation==UIDeviceOrientationPortrait){
        NSLog(@"竖屏");
    }
}
-(void)getCurrentKlineData{
    
    if (self.isHasGroupModel) {
        self.isHasGroupModel = NO;
        [self.lineKView reloadData];
        return;
    }

    NSDictionary * para = @{
        @"market":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"period":NSStringFormat(@"%@",self.period),
    };
    
    [CANetworkHelper GET:@"kline"  parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray * data = (NSArray*)responseObject;
                
                if (data.count) {
                    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:data];
                    groupModel.type = self.type;
                    self.groupModel = groupModel;
                    [self.lineKView reloadData];
                    [self sendKlineWebSocket];
                }
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)setuptopView
{
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, MainHeight, 50);
    [self.view addSubview:topView];
    
    UILabel *biType = [UILabel new];
    biType.font = FONT_SEMOBOLD_SIZE(14);
    biType.textColor = HexRGB(0x191d26);
    [topView addSubview:biType];
    biType.text = NSStringFormat(@"%@/%@",[self.currentSymbolModel.ask_unit uppercaseString],[self.currentSymbolModel.bid_unit uppercaseString]);
    [biType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(15);
    }];
    
    UILabel *price = [[UILabel alloc] init];
    price.font = FONT_MEDIUM_SIZE(14);
    [topView addSubview:price];
    _priceLabel = price;
    
    UILabel *radioLabel = [[UILabel alloc] init];
    radioLabel.font = FONT_REGULAR_SIZE(13);
    [topView addSubview:radioLabel];
    _radioLabel = radioLabel;

    UILabel *zfLabel = [[UILabel alloc] init];
    zfLabel.textColor = RGB(136, 143, 158);
    zfLabel.font = FONT_MEDIUM_SIZE(13);
    [topView addSubview:zfLabel];
    _zfLabel = zfLabel;

    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(biType.mas_right).offset(10);
        make.centerY.equalTo(topView);
    }];
    
    [radioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(price.mas_right).offset(5);
       make.centerY.equalTo(topView);
    }];
    
    [zfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(radioLabel.mas_right).offset(5);
        make.centerY.equalTo(topView);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:IMAGE_NAMED(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-15-SafeAreaBottomHeight);
        make.centerY.equalTo(topView);
    }];
    [closeBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];

    UILabel *high = [[UILabel alloc] init];
    high.font = ROBOTO_FONT_REGULAR_SIZE(9);
    [topView addSubview:high];
    _highLabel = high;
    
    UILabel *low = [[UILabel alloc] init];
    low.font = ROBOTO_FONT_REGULAR_SIZE(9);
    [topView addSubview:low];
    _lowLabel = low;
    
    UILabel *hour = [[UILabel alloc] init];
    hour.font = ROBOTO_FONT_REGULAR_SIZE(9);
    [topView addSubview:hour];
    _volLabel = hour;
    
    high.textColor = HexRGB(0x0b0826);
    low.textColor = HexRGB(0x0b0826);
    hour.textColor = HexRGB(0x0b0826);
    
    [hour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(closeBtn.mas_left).offset(-15);
    }];
    
    [low mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(hour.mas_left).offset(-10);
    }];
    
    [high mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(low.mas_left).offset(-10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [topView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.equalTo(@1);
    }];
}

- (void)onClickCloseButton:(id)sender {
  
    if (self.delegata&& [self.delegata respondsToSelector:@selector(lineFullScreenViewConteller_BackWithNewIndex:)]) {
        [self.delegata lineFullScreenViewConteller_BackWithNewIndex:self.currentKLineType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict {
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)addLinesView {
    CGFloat white = _lineKView.bounds.size.height /4.f;
    CGFloat height = _lineKView.bounds.size.width /4.f;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineKView.bounds.size.width , 1)];
        hengView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [_lineKView addSubview:hengView];
        [_lineKView sendSubviewToBack:hengView];
    }
    //竖格
    
    for (int i = 0;i<= 5;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * i, 0, 1, _lineKView.bounds.size.height - 41)];
        shuView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [_lineKView addSubview:shuView];
        [_lineKView sendSubviewToBack:shuView];

    }
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 245, 40, 40)];
    [logo setImage:IMAGE_NAMED(@"logo")];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [_lineKView addSubview:logo];
    [_lineKView sendSubviewToBack:logo];
}

#pragma mark - Y_StockChartViewDelegate

- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType{
//    if (!_isShowKLineFullScreenViewController) {
//        [self showKLineFullScreenViewController];
//    }
}

#pragma mark - Y_StockChartViewDataSource

-(id)stockDatasWithIndex:(Y_KLineType)klineType {
    
    NSString *type=@"";
    NSString *period = @"";
    
    switch (klineType) {
        case KLineTypeTimeLine://1min
        {
            type = @"1min";
            period = @"1";
        }
            break;
        case KLineType15Min://15min
            {
                type = @"15min";
                period = @"15";
            }
            break;
        case KLineType1Hour://1小时
            {
                type = @"60min";
                period = @"60";
            }
            break;
        case KLineType1Day://1day
            {
                type = @"1day";
                period = @"1440";
            }
            break;
        case KLineType1Min://1min
            {
                type = @"1min";
                period = @"1";
            }
            break;
        case KLineType5Min://5min
            {
                type = @"5min";
                period = @"5";
            }
            break;
        case KLineType30Min://30min
            {
                type = @"30min";
                period = @"30";
            }
            break;
            break;
        case KLineType1Week://1week
            {
                type = @"1week";
                period = @"10080";
            }
            break;
        case KLineType1Month://1mon
            {
                type = @"1mon";
                period = @"43200";
            }
            break;
        default:
            break;
    }
    
    self.currentKLineType = klineType;
    self.type = type;
    self.period = period;

//    if (klineType == 0 || klineType == 1 || klineType == 2 || klineType == 3) {
//        _lineKView.isMoreTimeDataUpdate = NO;
//    }else{
//        _lineKView.isMoreTimeDataUpdate = YES;
//    }

    if(self.groupModel&&self.groupModel.models.count&&[self.type isEqualToString:self.groupModel.type]){
        return self.groupModel.models;
    }else{
        [self getCurrentKlineData];
    }
    
    return nil;
}

@end
