//
//  YStockChartViewController.m
//  BTC-Kline
//

#import "BTStockChartViewController.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "CACurrencyModel.h"
#import "BTDealMarketModel.h"
#import "BTMarketModel.h"
#import "LineKFullScreenViewController.h"
#import "Y_KLineModel.h"
#import "Y_KLineView.h"
#import "Y_KLineMainView.h"
#import "CASegmentView.h"
#import "DeepTableViewCell.h"
#import "CADeepListTableViewCell.h"
#import "CADealTableViewCell.h"
#import "CABriefTableViewCell.h"
#import "BTBiInfoModel.h"
#import "CABBSearshView.h"
#import "CASymbolsModel.h"
#import "CATabbarController.h"
#import "CAEmptyTableViewCell.h"

#define KHeaderHeight 100+410+10

static NSString *const contentCellID = @"contentCellID";
static NSString *const dealCellID = @"dealCellID";
static NSString *const biInfoCellID = @"biInfoCellID";
static NSString *const biInfoDesCellID = @"biInfoDesCellID";
static NSString *const depthCellID = @"depthCellID";

@interface BTStockChartViewController ()
<CASegmentViewDelegate,
Y_StockChartViewDataSource,
Y_StockChartViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
CABBSearshViewDelegate,
LineFullScreenViewControllerDelegate,
CASocketDelegate>
{
    NSArray * _asks;
    NSArray * _bids;
    UIButton *_optionalButton;
    BOOL _isCurrentRequestHasSendSuccess;
    UILabel * _marketIdLabel;
    NSDictionary * _currentKline;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Y_StockChartView *lineKView;
@property (nonatomic, strong) Y_KLineGroupModel *groupModel;
@property (nonatomic, assign) BOOL isfavorates;
@property (nonatomic, assign) Y_KLineType currentKLineType;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *period;

@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *zfLabel;
@property (strong, nonatomic) UILabel *rightL;
//分段选择
@property (nonatomic, assign) NSInteger biInfoType;
//成交数组
@property (nonatomic, strong) NSArray *real_time_trades;
//深度图 买盘数组
@property (nonatomic, strong) NSArray *buyArray;
//深度图 卖盘数组
@property (nonatomic, strong) NSArray *sellArray;
//币种简介标题
@property (nonatomic, strong) BTBiInfoModel *countryDetailsModel;
//筛选面板
@property (nonatomic, assign) BOOL isShowBiBan;
//头部model
@property (nonatomic, strong) BTMarketModel *marketModel;
//币列表
@property (nonatomic, strong) NSMutableArray *marketModelArr;
//全屏K线
@property (nonatomic, strong) LineKFullScreenViewController *lineKFullScreenViewController;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isHidden;
//深度 成交 简介 选择器
@property (nonatomic, strong) CASegmentView * segmentView;

@property (nonatomic, strong) CABBSearshView * searchView;

@property (nonatomic, strong) NSDictionary * latest_bar;

@end

@implementation BTStockChartViewController


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


-(CACurrencyModel *)currencyModel{
    if (!_currencyModel) {
        _currencyModel = [CACurrencyModel new];
    }
    return _currencyModel;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[CASocket shareSocket] removeDelegate:self];
    [[CASocket shareSocket] unsubCurrentReq];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[CASocket shareSocket] addDelegate:self];
    
    [self sendMessageToSocket];
    [self is_add_to_favorates];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

-(void)orientationDidChange{
    
    UIDeviceOrientation  orientation = [[UIDevice currentDevice] orientation];
    if (orientation==UIDeviceOrientationLandscapeLeft) {
        NSLog(@"横屏");
//        [self showKLineFullScreenViewController:YES];
    }else if (orientation==UIDeviceOrientationPortrait){
        NSLog(@"竖屏");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.currentKLineType = KLineType15Min;//默认是15分钟的k线
    
    self.isHidden = YES;
     //导航栏
    [self setupNavView];

    //初始化头部
    [self setuptopView];

    [self setupDownMenuView];
    
    [self loadCurrencyDetails];
    
    [SVProgressHUD show];
    
    self.isfavorates = NO;
    
    [self freshMarketData];
    
}

-(void)CABBSearshView_didsectedMarket:(CASymbolsModel *)model{
    self.currentSymbolModel = model;
    
    [[CASocket shareSocket] unsubCurrentReq];
    
    [self is_add_to_favorates];

    [self loadCurrencyDetails];
    
    [self freshMarketData];
    
    [self getCurrentKlineData];
    
    [self sendMessageToSocket];
}

-(void)freshMarketData{
    
     _marketIdLabel.text = NSStringFormat(@"%@/%@",[self.currentSymbolModel.ask_unit uppercaseString],[self.currentSymbolModel.bid_unit uppercaseString]);
}

-(void)getCurrentKlineData{

    NSDictionary * para = @{
        @"market":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"period":NSStringFormat(@"%@",self.period),
    };
    
    [CANetworkHelper GET:@"kline"  parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray * data = (NSArray*)responseObject;
            NSLog(@"======%@",data);
            if (data.count) {
                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:data];
                groupModel.type = self.type;
                self.groupModel = groupModel;
                [self.lineKView reloadData];
                [self.lineKView.kLineView.kLineMainView updateMainViewWidth];
                [self sendKlineWebSocket];
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)sendKlineWebSocket{
    [[CASocket shareSocket] sendDataToSever:[self getKline]];
}

-(void)webSocketDidOpen{
    
    [self sendMessageToSocket];
    if (_currentKline) {
        [self sendKlineWebSocket];
    }
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
#pragma mark order_books 频道拼接
-(NSDictionary*)getOrderBooks{
    NSDictionary * dic = @{
        @"channel" : @"order_books",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
}
#pragma mark real_time_trades 频道拼接
-(NSDictionary*)getRealTimeTrades{
    NSDictionary * dic = @{
        @"channel" : @"real_time_trades",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
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

-(void)sendMessageToSocket{
   
    [[CASocket shareSocket] sendDataToSever:[self getLatestBar]];
    [[CASocket shareSocket] sendDataToSever:[self getOrderBooks]];
    [[CASocket shareSocket] sendDataToSever:[self getRealTimeTrades]];
    
}

-(void)webSocket:(CASocket *)webSocket didReceiveMessage:(NSDictionary *)message{
    
    BOOL neesFreshTableView = NO;
    [SVProgressHUD dismiss];
   
    if (message[@"channel"]) {
        if ([message[@"channel"] isEqualToString:[self getLatestBar][@"subscribe"]]){
            
            
            _latest_bar = message[@"content"];
            [self freshTopViewData];
            
        }else if ([message[@"channel"] isEqualToString:[self getOrderBooks][@"subscribe"]]) {
            NSArray * sellArray = message[@"content"][@"data"][@"ask_orders"];
            NSArray * buyArray = message[@"content"][@"data"][@"bid_orders"];
            
            if (sellArray.count>20) {
                self.sellArray = [[[sellArray subarrayWithRange:NSMakeRange(sellArray.count-20, 20)] reverseObjectEnumerator] allObjects];
            }else{
                self.sellArray = [[sellArray reverseObjectEnumerator] allObjects];
            }
            if (buyArray.count>20) {
                self.buyArray = [buyArray subarrayWithRange:NSMakeRange(0, 20)];
            }else{
                self.buyArray = buyArray;
            }
            if (self.biInfoType==0) {
                neesFreshTableView = YES;
            }
           
        }else if ([message[@"channel"] isEqualToString:[self getRealTimeTrades][@"subscribe"]]) {
            
            NSArray * real_times = message[@"content"][@"data"];
            if (real_times.count>=20) {
                self.real_time_trades = [real_times subarrayWithRange:NSMakeRange(0, 20)];
            }else{
                self.real_time_trades = real_times;
            }
            
            if (self.biInfoType==1) {
                neesFreshTableView = YES;
            }
            
        }else if ([message[@"channel"] isEqualToString:_currentKline[@"subscribe"]]){
            NSLog(@"%@",message);
            NSArray * newKline = message[@"content"][@"k"];
            if (self.groupModel&&[self.groupModel.type isEqualToString:self.type]&&newKline.count) {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    [self.groupModel addData:newKline];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.lineKView reloadData];
                        [self.lineKView.kLineView.kLineMainView updateMainViewWidth];
                    });
                });
            }
        }
    }
    
    if (neesFreshTableView) {
        [self.tableView reloadData];
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
            
             zfText = NSStringFormat(@"≈%@%@ %@",ask_rate_number,unit_sign,price_change_ratio);
        }
        
        NSDictionary * ticker = _latest_bar[@"ticker"];
        if (ticker) {
            high = ticker[@"high"];
            low = ticker[@"low"];
            volume = ticker[@"volume"];
        }
    }
    self.price.text = priceText;
    self.zfLabel.text = zfText;
    self.price.textColor = showColor;
    [self.zfLabel setRangeSize:1 font:13 starIndex:self.zfLabel.text.length-price_change_ratio.length index:price_change_ratio.length rangeColor:showColor];

    self.rightL.text = [NSString stringWithFormat:@"%@\n%@\n%@",high,low,volume];
    [self.rightL setSpace:self.rightL.text lineSpace:8 paraSpace:0 alignment:3 kerSpace:0];
    
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, MainWidth, MainHeight-kTopHeight-50-SafeAreaBottomHeight) style:UITableViewStyleGrouped];
           
       _tableView.backgroundColor = [UIColor clearColor];
       _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       _tableView.delegate = self;
       _tableView.dataSource = self;
       _tableView.showsVerticalScrollIndicator = NO;
       _tableView.tableFooterView = [UIView new];
       [self.view addSubview:_tableView];
    
       [_tableView registerClass:[CABriefTableViewCell class] forCellReuseIdentifier:@"CABriefTableViewCell"];
       [_tableView registerClass:[CADealTableViewCell class] forCellReuseIdentifier:@"CADealTableViewCell"];
       [_tableView registerClass:[CADeepListTableViewCell class] forCellReuseIdentifier:@"CADeepListTableViewCell"];
       [_tableView registerClass:[DeepTableViewCell class] forCellReuseIdentifier:@"DeepTableViewCell"];
       [_tableView registerNib:[UINib nibWithNibName:@"CAEmptyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CAEmptyTableViewCell"];

    }
    return _tableView;
}

-(void)setupDownMenuView{
    
    UIView * downView = [UIView new];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
    }];
    downView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
    
    UIButton * buyBtn = [self private_creatButton:CALanguages(@"买入") color:[UIColor colorWithRGBHex:0x4bc68f]];
    UIButton * sellBtn = [self private_creatButton:CALanguages(@"卖出") color:[UIColor colorWithRGBHex:0xff5974]];
    
    [downView addSubview:buyBtn];
    [downView addSubview:sellBtn];
    
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(downView);
        make.width.mas_equalTo((MainWidth-25)/2.f);
        make.height.mas_equalTo(40);
        make.left.equalTo(downView).offset(10);
    }];
    [sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(downView);
        make.width.height.equalTo(buyBtn);
        make.right.equalTo(downView.mas_right).offset(-10);
    }];
    
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sellBtn addTarget:self action:@selector(sellBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 下面的购买 卖出 点击事件
-(void)buyBtnClick{
    if (self.currentSymbolModel) {
        if (self.backBlock) {
            self.backBlock(self.currentSymbolModel,TradingBuy);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)sellBtnClick{
    if (self.currentSymbolModel) {
        if (self.backBlock) {
            self.backBlock(self.currentSymbolModel,TradingSell);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(UIButton*)private_creatButton:(NSString*)text color:(UIColor*)color{
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [buyBtn setTitle:text forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    buyBtn.titleLabel.font = FONT_SEMOBOLD_SIZE(14);
    buyBtn.backgroundColor = color;
    buyBtn.layer.masksToBounds = YES;
    buyBtn.layer.cornerRadius  = 2;
    
    return buyBtn;
}

- (void)setupNavView
{

    UIView *contentView = [[UIView alloc] init];
    [self.navcBar.navcContentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navcBar.backButton.mas_right).offset(20);
        make.centerY.equalTo(self.navcBar.backButton);
        make.height.mas_offset(23);
        make.width.equalTo(@150);
    }];
    
    UIImageView * imageV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"more")];
    [contentView addSubview:imageV];
    UILabel * label = [UILabel new];
    _marketIdLabel = label;
    [contentView addSubview:label];
    label.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
    label.font = FONT_SEMOBOLD_SIZE(20);
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.centerY.equalTo(contentView);
        make.width.height.equalTo(@14);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(5);
        make.centerY.equalTo(contentView);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchView)];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchView)];
    label.userInteractionEnabled = YES;
    imageV.userInteractionEnabled = YES;
    [label addGestureRecognizer:tap];
    [imageV addGestureRecognizer:tap1];
    
    UIButton *full = [UIButton buttonWithType:UIButtonTypeCustom];
//    [full setImage:IMAGE_NAMED(@"fullscreen")  forState:UIControlStateNormal];
    [full addTarget:self action:@selector(showKLineFullScreenViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navcBar addSubview:full];
    [full loadSvgImage:@"fullscreen-fill.svg" forState:UIControlStateNormal];
    [full mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(self.navcBar).offset(-15);
        make.width.height.equalTo(@25);
    }];
    [full setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    _optionalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ _optionalButton addTarget:self action:@selector(optionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navcBar addSubview: _optionalButton];
    [ _optionalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(full.mas_left).offset(-20);
        make.width.height.equalTo(@20);
    }];
    

    
}

-(CABBSearshView *)searchView{
    if (!_searchView) {
        _searchView = [[CABBSearshView alloc] initWithFrame:CGRectMake(0, 0, MainWidth*0.7,MainHeight)];
        _searchView.delegata  = self;
    }
    return _searchView;
}

-(void)showSearchView{
 
    [self.searchView showInView:self.navigationController.view isAnimation:YES direaction:CABaseAnimationDirectionFromLeft];
}

- (void)setuptopView
{
    UIView *topView = [[UIView alloc] init];
    topView.height = KHeaderHeight;
    self.tableView.tableHeaderView = topView;
    topView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
    
    UIView *biTopInfo = [[UIView alloc] init];
    [topView addSubview:biTopInfo];
    [biTopInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(topView);
        make.height.equalTo(@100);
    }];

    
    _lineKView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(0, 100, MainWidth, 410)];
    _lineKView.isFullScreen = NO;
    _lineKView.itemModels = @[
                            [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"分时")
                                                                klineType:KLineTypeTimeLine
                                                                     type:Y_StockChartcenterViewTypeKline],
                            [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"15分")
                                                                klineType:KLineType15Min
                                                                     type:Y_StockChartcenterViewTypeKline],
                            [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1小时")
                                                                klineType:KLineType1Hour
                                                                     type:Y_StockChartcenterViewTypeKline],
                            [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"日线")
                                                                klineType:KLineType1Day
                                                                     type:Y_StockChartcenterViewTypeKline]
                            ];
    _lineKView.dataSource = self;
    _lineKView.delegate = self;
    [self addLinesView];
    [topView addSubview:self.lineKView];
    
    UILabel *price = [[UILabel alloc] init];
    price.textColor = [UIColor increaseColor];
    price.font = FONT_SEMOBOLD_SIZE(25.f);
    [biTopInfo addSubview:price];
    _price = price;
    
    UILabel *zfLabel = [[UILabel alloc] init];
    zfLabel.textColor = RGB(98, 124, 158);
    zfLabel.font = FONT_REGULAR_SIZE(13);
    [biTopInfo addSubview:zfLabel];
    _zfLabel = zfLabel;
    
    UILabel *rightTL = [[UILabel alloc] init];
    rightTL.text = NSStringFormat(@"%@\n%@\n24H",CALanguages(@"高"),CALanguages(@"低"));
    rightTL.textColor = RGB(98, 124, 158);
    rightTL.font = FONT_MEDIUM_SIZE(14);
    rightTL.numberOfLines = 3;
    [rightTL setSpace:rightTL.text lineSpace:8 paraSpace:0 alignment:1 kerSpace:0];
    [biTopInfo addSubview:rightTL];

    UILabel *rightL = [[UILabel alloc] init];
    rightL.textColor = HexRGB(0x0b0826);
    rightL.font = FONT_MEDIUM_SIZE(13);
    rightL.numberOfLines = 3;
    [biTopInfo addSubview:rightL];
    _rightL = rightL;
    
    [rightTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerY.equalTo(rightL);
        make.right.equalTo(rightL.mas_left).offset(-15);
    }];
    
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(biTopInfo).offset(15);
        make.top.equalTo(biTopInfo).offset(17);
    }];
    
    [zfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(price);
        make.top.equalTo(price.mas_bottom).offset(10);
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(biTopInfo).offset(15);
        make.right.equalTo(biTopInfo).offset(-15);
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.lineKView hideMoreViewAndIndicatorView];
}

#pragma mark lineFullScreenViewConteller_BackWithNewIndex
-(void)lineFullScreenViewConteller_BackWithNewIndex:(Y_KLineType)newType{
    
    if (self.currentKLineType!=newType) {
        
        self.lineKView.lastKlineType = newType;
        [self.lineKView initSegmentData];
    }
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
#pragma mark 加载币种简介
-(void)loadCurrencyDetails{
    
    if (!self.currentSymbolModel.ask_unit.length) {
        return;
    }
    NSDictionary * para = @{
        @"code":NSStringFormat(@"%@",[self.currentSymbolModel.ask_unit lowercaseString]),
        @"market_id":NSStringFormat(@"%@",[self.currentSymbolModel.market_id lowercaseString]),
    };
    
    [CANetworkHelper GET:CAAPI_CURRENCY_DETAILS parameters:para success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * data = responseObject[@"data"];
            self.countryDetailsModel.introduction = data[@"introduction"];
            self.countryDetailsModel.published_amount = data[@"published_amount"];
            self.countryDetailsModel.published_at = data[@"published_at"];
            self.countryDetailsModel.tradable_amount = data[@"tradable_amount"];
            self.countryDetailsModel.white_page_url = data[@"white_page_url"];
            self.countryDetailsModel.official_website = data[@"official_website"];
            self.countryDetailsModel.query_website = data[@"query_website"];
            self.countryDetailsModel.full_name = data[@"full_name"];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.biInfoType == 0) {
        return 1;
    }else if(self.biInfoType==1){
        if (self.real_time_trades.count) {
            return self.real_time_trades.count+1;
        }
        return 1;
    }else{
        return 8;
    }
    
    return 0;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.biInfoType==0) {
        
//        if (indexPath.section==0&&indexPath.row==0) {
            //返回深度图
//            DeepTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeepTableViewCell"];
//
//            if (_asks&&_bids) {
////                cell.deepView.dataArrOfX = @[@"6727",@"7474",@"8220"];
////                cell.deepView.dataArrOfY = @[@"3.480",@"2.790",@"1.390",@"0.490"];
////                cell.deepView.buyDataArrOfPoint = _asks;
////                cell.deepView.sellDataArrOfPoint = _bids;
//            }
//
//
//            return cell;
//        }else{
            CADeepListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CADeepListTableViewCell"];
            cell.ask_code = self.currentSymbolModel.ask_unit;
            cell.bid_code = self.currentSymbolModel.bid_unit;
            [cell fresh:self.buyArray sellArr:self.sellArray];
            return cell;
//        }
    }else if (self.biInfoType==1){
        
        if (self.real_time_trades.count) {
            CADealTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CADealTableViewCell"];
            if (indexPath.row==0) {
                [cell setTitleStyle];
            }else{
                cell.dealData = self.real_time_trades[indexPath.row-1];
            }
            return cell;
        }else{
            CAEmptyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAEmptyTableViewCell"];
            return cell;
        }
        
        
    }else if (self.biInfoType==2){
        
        CABriefTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CABriefTableViewCell"];
        cell.enableCopy = NO;
            switch (indexPath.row) {
                case 0:
                    [cell singleBigTitle:self.countryDetailsModel.full_name];
                    break;
                case 1:
                {
                    cell.leftText = CALanguages(@"发行时间");
                    cell.rightText = self.countryDetailsModel.published_at;
                }
                    break;
                case 2:
                {
                    cell.leftText = CALanguages(@"发行总量");
                    cell.rightText = self.countryDetailsModel.published_amount;
                }
                    break;
                case 3:
                {
                    cell.leftText = CALanguages(@"流通总量");
                    cell.rightText = self.countryDetailsModel.tradable_amount;
                }
                    break;
                    break;
                case 4:
                {
                    cell.leftText = CALanguages(@"白皮书");
                    cell.rightText = self.countryDetailsModel.white_page_url;
                    cell.enableCopy = YES;
                }
                    break;
                case 5:
                {
                    cell.leftText = CALanguages(@"官网");
                    cell.rightText = self.countryDetailsModel.official_website;
                    cell.enableCopy = YES;
                }
                    break;
                case 6:
                {
                    cell.leftText = CALanguages(@"区块查询");
                    cell.rightText = self.countryDetailsModel.query_website;
                    cell.enableCopy = YES;
                }
                    break;
                case 7:
                    
                    [cell showBriefIntroduct:self.countryDetailsModel.introduction];
                    
                default:
                    break;
            }
       
        
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.biInfoType == 0) {
//        if (indexPath.row==0) {
//            return MainWidth*0.5+30;
//        }else{
            return 40+MAX(self.buyArray.count, self.sellArray.count)*30;
//        }
//        return 40;
    }else if (self.biInfoType == 1){
        if (self.real_time_trades.count) {
            if (indexPath.row==0) {
                return 40;
            }
            return 30;
        }else{
            return 180;
        }
        
    }else {
        if (indexPath.row==0) {
            return 50;
        }else if (indexPath.row>0&&indexPath.row<7){
            return 45;
        }else{
            
            return self.countryDetailsModel.desCellHeight;
        }
    }
}

-(BTBiInfoModel *)countryDetailsModel{
    if (!_countryDetailsModel) {
        _countryDetailsModel = [BTBiInfoModel new];
    }
    return _countryDetailsModel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //sectionheader的高度，这是要放分段控件的
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.segmentView;
}
#pragma mark segment点击处理时间
-(void) CASegmentView_didSelectedIndex:(NSInteger)index{
    
    self.biInfoType = index;
    [self.tableView reloadData];
}

-(CASegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 40)];
        _segmentView.segmentItems =@[CALanguages(@"委托挂单") ,CALanguages(@"成交"),CALanguages(@"简介")];
        _segmentView.delegata = self;
        _segmentView.segmentCurrentIndex = 0;
    }
    return _segmentView;
}

- (void)addLinesView {
    CGFloat white = _lineKView.bounds.size.height /4;
    CGFloat height = _lineKView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineKView.bounds.size.width , 0.5)];
        hengView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [_lineKView addSubview:hengView];
        [_lineKView sendSubviewToBack:hengView];
    }
    //竖格
    for (int i = 0;i < 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 47, 0.5, _lineKView.bounds.size.height - 62)];
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


- (void)showKLineFullScreenViewController{
    
    LineKFullScreenViewController * full = [LineKFullScreenViewController new];
    full.currentSymbolModel = self.currentSymbolModel;
    full.delegata = self;
    full.lastType = self.currentKLineType;
    full.groupModel = self.groupModel;
    full.isHasGroupModel = YES;
    [self.navigationController pushViewController:full animated:YES];

}

#pragma mark - Y_StockChartViewDelegate
- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType{
    [self showKLineFullScreenViewController];
}
- (void)full{
    [self showKLineFullScreenViewController];
}
-(void)is_add_to_favorates{
    
    if (![CAUser currentUser].isAvaliable) {
        return;
    }
    
    NSDictionary * para = @{
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id)
    };
    
    [CANetworkHelper GET:CAAPI_CRYPTO_TO_CRYPTO_IS_ADD_TO_FAVORATES parameters:para success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==20000) {
           self.isfavorates=NO;
        }else{
           self.isfavorates=YES;
        }
    } failure:^(NSError *error) {
    }];
}
-(void)add_to_favorates{
     
    [CASymbolsModel add_to_favorates:self.currentSymbolModel.market_id finshed:^(BOOL success) {
        if (success) {
            self.isfavorates=YES;
            [self.searchView reloadData];
        }
    }];
}


-(void)remove_from_favorates{
    
    [CASymbolsModel remove_from_favorates:self.currentSymbolModel.market_id finshed:^(BOOL success) {
        if (success) {
            self.isfavorates=NO;
            [self.searchView reloadData];
        }
    }];
}
-(void)setIsfavorates:(BOOL)isfavorates{
    _isfavorates = isfavorates;
    
    if (_isfavorates) {
        [ _optionalButton setImage:[IMAGE_NAMED(@"optional_sel") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    }else{
        [ _optionalButton setImage:[IMAGE_NAMED(@"optional_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    }
}
-(void)optionAction{
    
    if (![CAUser currentUser].isAvaliable) {
        
        CAloginViewController * login = [[CAloginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }else{
        
        if (self.isfavorates) {
            [self remove_from_favorates];
        }else{
            [self add_to_favorates];
        }
    }
}

@end

