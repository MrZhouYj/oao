//
//  CABBViewController.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBViewController.h"
#import "CABiBiIOView.h"
#import "CABBtradingHeaderRightView.h"
#import "CABBBottomTimeLineView.h"
#import "CAEntrustTableViewCell.h"
#import "CAMyOrderListViewController.h"
#import "CABBSearshView.h"
#import "CAButton.h"
#import "CAEntrustListViewController.h"
#import "CAEmptyTableViewCell.h"
#import "CAEntrustModel.h"
#import "CASymbolsModel.h"
#import "Y_KLineGroupModel.h"
#import "CAAlertView.h"

@interface CABBViewController ()
<UITableViewDelegate,
UITableViewDataSource,
CABBSearshViewDelegate,
CABiBiIOViewDelegata>
{
    BOOL _isfavorates;
    CAButton * _showAllButton;
    CAButton * _revoleAllButton;
    UIButton * _moreButton;
    UILabel * _marketIdLabel;
    UILabel * titleLable;
}
@property (nonatomic, strong) NSMutableArray * dataSourceArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) CABiBiIOView * bibiIOView;
@property (nonatomic, strong) CABBtradingHeaderRightView * rightHeaderView;
@property (nonatomic, strong) CABBBottomTimeLineView * bottomView;
@property (nonatomic, strong) CABBSearshView * searchView;
@property (nonatomic, strong) NSMutableArray * klineOneMinArray;
@property (nonatomic, strong) NSMutableArray * allEntrustArray;
@property (nonatomic, strong) UILabel * ratioLabel;

@property (nonatomic, copy) NSString * market_id;


@end

@implementation CABBViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.klineOneMinArray = @[].mutableCopy;
    self.allEntrustArray  = @[].mutableCopy;
    [self initMenuView];
    [self initTableView];
    
    [self.bottomView setHidden:NO];

    [self is_add_to_favorates];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignOut) name:CAUserDidSignOutSuccessNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignin) name:CAUserDidSignOutSuccessNotifacation object:nil];

    [self languageDidChange];
}

-(void)languageDidChange{

    self.navcTitle = @"币币";
    [CASymbolsModel getMarketList:^{
    
       self.currentSymbolModel = [CASymbolsModel getDefultSymbol];
       [self initSubViewsData];
       [self freshAll];
       [self.searchView didChange];
        
    }];
    
  _revoleAllButton.titleLabel.text = CALanguages(@"撤销全部");
  _showAllButton.titleLabel.text = CALanguages(@"全部");
  titleLable.text = CALanguages(@"当前委托");
}


-(void)setCurrentSymbolModel:(CASymbolsModel *)currentSymbolModel{
    _currentSymbolModel = currentSymbolModel;
    if (currentSymbolModel) {
        self.market_id = currentSymbolModel.market_id;
    }
}

-(void)initSubViewsData{

    self.bibiIOView.ask_code = self.currentSymbolModel.ask_unit;
    self.bibiIOView.bid_code = [self.currentSymbolModel.bid_unit uppercaseString];
    self.bibiIOView.market_id = self.currentSymbolModel.market_id;
    
    _marketIdLabel.text = NSStringFormat(@"%@/%@",[self.currentSymbolModel.ask_unit uppercaseString],[self.currentSymbolModel.bid_unit uppercaseString]);
    self.bottomView.code = NSStringFormat(@"%@/%@",[self.currentSymbolModel.ask_unit uppercaseString],[self.currentSymbolModel.bid_unit uppercaseString]);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.currentSymbolModel) {
        self.currentSymbolModel = [CASymbolsModel getDefultSymbol];
        if (self.currentSymbolModel) {
            [CASymbolsModel getMarketList:^{
               self.currentSymbolModel = [CASymbolsModel getDefultSymbol];
               [self initSubViewsData];
            }];
        }
    }
    [self initSubViewsData];
    
    [[CASocket shareSocket] addDelegate:self];
    
    [self freshPage];
    [self checkIsLogin];
}
#pragma mark 退出登录
-(void)didSignOut{
    
    [self.allEntrustArray removeAllObjects];
    [self.tableView reloadData];
    [self checkIsLogin];
   
}
-(void)didSignin{
    
    [self is_add_to_favorates];
    [self freshPage];
    [self checkIsLogin];
}

-(void)freshPage{
    
    [self getCurrentKlineData];
    [self sendMessageToSocket];
    [self getRatios];
    if ([CAUser currentUser].isAvaliable) {
        [self getCurrentOrders];
    }
}



-(void)checkIsLogin{
    
    if ([CAUser currentUser].isAvaliable) {
        _showAllButton.hidden = NO;
    }else{
        _showAllButton.hidden = YES;
    }
    [self.bibiIOView judgeLogin];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
     [[CASocket shareSocket] removeDelegate:self];
     [[CASocket shareSocket] unsubCurrentReq];
    
}

-(void)CABBSearshView_didsectedMarket:(CASymbolsModel *)model{
    
    self.currentSymbolModel = model;
    [self initSubViewsData];
    [self freshAll];
}

-(void)freshAll{
    
     [[CASocket shareSocket] unsubCurrentReq];
    
     [self is_add_to_favorates];
     
     [self freshPage];
}

-(void)sendMessageToSocket{
    
    
    [[CASocket shareSocket] sendDataToSever:[self getMarketList]];
    [[CASocket shareSocket] sendDataToSever:[self getOrderBooks]];
    [[CASocket shareSocket] sendDataToSever:[self getLatestBar]];
    [[CASocket shareSocket] sendDataToSever:[self getMemberAccount]];
    
    if ([CAUser currentUser].isAvaliable) {
        [[CASocket shareSocket] sendDataToSever:[self getOrder]];
    }
    
}

-(void)getCurrentKlineData{

    NSDictionary * para = @{
        @"market":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"period":@"1"
    };

    [CANetworkHelper GET:@"kline"  parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self.bottomView.klineDataArray removeAllObjects];
            
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:responseObject];

//            NSArray * initData = responseObject;
//            NSMutableArray * mut = @[].mutableCopy;
//            Y_KLineModel * lastModel = [Y_KLineModel new];
//            for (NSArray * arr in initData) {
//                Y_KLineModel *model = [Y_KLineModel new];
//                [model initWithArray:arr];
//                model.PreviousKlineModel = lastModel;
//                [mut addObject:model];
//                lastModel = model;
//            }

            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.bottomView setGroupModel:groupModel];
                 [[CASocket shareSocket] sendDataToSever:[self getKline]];
            });
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)getRatios{
    
    NSDictionary * para = @{
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id)
    };

    [CANetworkHelper GET:CAAPI_CRYPTO_TO_CRYPTO_MARKET_SCALE parameters:para success:^(id responseObject) {
       
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * precision = responseObject[@"data"][@"precision"];
            NSMutableDictionary * precisionMut = precision.mutableCopy;
            if ([precision[@"ask_currency_scale"] isKindOfClass:[NSNull class]]) {
                precisionMut[@"ask_currency_scale"] = @"0";
            }
            if ([precision[@"bid_currency_scale"] isKindOfClass:[NSNull class]]) {
                precisionMut[@"bid_currency_scale"] = @"0";
            }
            self.bibiIOView.precision = precisionMut;
            self.bibiIOView.member_assets = responseObject[@"data"][@"member_assets"];
        }
       
    } failure:^(NSError *error) {
    }];
}

-(void)getCurrentOrders{
    
    NSDictionary * para = @{
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id)
    };

    [CANetworkHelper GET:CAAPI_CRYPTO_TO_CRYPTO_CURRENT_ORDERS parameters:para success:^(id responseObject) {
       
        if ([responseObject[@"code"] integerValue]==20000) {
            [self.allEntrustArray removeAllObjects];
            [self.allEntrustArray addObjectsFromArray:[CAEntrustModel getModels:responseObject[@"data"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        if (self.allEntrustArray.count) {
           self->_revoleAllButton.hidden = NO;
        }else{
            self->_revoleAllButton.hidden = YES;
        }
       
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 频道拼接
#pragma mark order_books 频道拼接
-(NSDictionary*)getOrderBooks{
    NSDictionary * dic = @{
        @"channel" : @"order_books",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
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
#pragma mark order 频道拼接
-(NSDictionary*)getOrder{
    NSDictionary * dic = @{
        @"channel" : @"order",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"token":NSStringFormat(@"%@",[CAUser currentUser].app_token),
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
}
#pragma mark market_list_app 频道拼接
-(NSDictionary*)getMarketList{
    NSDictionary * dic = @{
        @"channel" : @"market_list_app",
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
}

#pragma mark kline 频道拼接
-(NSDictionary*)getKline{
    NSDictionary * dic = @{
        @"channel" : @"kline",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"period":@"1"
    };
    return [CASocket getSub:dic];
}

#pragma mark kline 频道拼接
-(NSDictionary*)getMemberAccount{
    NSDictionary * dic = @{
        @"channel" : @"member_account",
        @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id),
        @"token":NSStringFormat(@"%@",[CAUser currentUser].app_token),
        @"lang":LocalLanguage
    };
    return [CASocket getSub:dic];
}

-(void)webSocketDidOpen{
    
    [self sendMessageToSocket];
    [self getCurrentKlineData];
}

-(void)webSocket:(CASocket *)webSocket didReceiveMessage:(NSDictionary *)message{
    
    
    if (message[@"channel"]) {
        
        if ([message[@"channel"] isEqualToString:[self getOrderBooks][@"subscribe"]]) {
           
//            NSLog(@"%@",message);
            NSArray * ask_orders = message[@"content"][@"data"][@"ask_orders"];
            NSArray * bid_orders = message[@"content"][@"data"][@"bid_orders"];
            
            self.rightHeaderView.asksArray = ask_orders;
            self.rightHeaderView.bidsArray = bid_orders;
            [self.rightHeaderView updateUI];
        
        }else if ([message[@"channel"] isEqualToString:[self getLatestBar][@"subscribe"]]){

            
            NSArray * bid_rate = message[@"content"][@"bid_rate"];
            NSArray * ask_rate = message[@"content"][@"ask_rate"];

            self.bibiIOView.bid_rate = bid_rate;
            self.bibiIOView.ask_rate = ask_rate;
            
            NSString * price_change_ratio  = message[@"content"][@"price_change_ratio"];
            NSString * last_price  = message[@"content"][@"last_price"];

            if (!self.bibiIOView.priceStr.length&&self.bibiIOView.isFirstSetPriceStr) {
                self.bibiIOView.isFirstSetPriceStr = NO;
                self.bibiIOView.priceStr = last_price;
            }
            [self dealRadio:price_change_ratio];
            [self.rightHeaderView updateCenterData:bid_rate last_price:last_price];
            
        }else if ([message[@"channel"] isEqualToString:[self getOrder][@"subscribe"]]){
            
            [self getRatios];
            [self getCurrentOrders];
            
        }else if ([message[@"channel"] isEqualToString:[self getMarketList][@"subscribe"]]){

//            NSLog(@"%@",message);
            [CASymbolsModel getModels:message[@"content"][@"markets"]];
            [self.searchView reloadData];
            
            NSArray * market_sort = message[@"content"][@"market_sort"];
            if (market_sort.count) {
                [CommonMethod writeToUserDefaults:market_sort withKey:CAMaretSortKey];
            }
        }else if ([message[@"channel"] isEqualToString:[self getKline][@"subscribe"]]){
//            NSLog(@"%@",message);
            NSArray * newKline = message[@"content"][@"k"];
            if (self.bottomView.groupModel&&newKline.count) {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    [self.bottomView.groupModel addData:newKline];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.bottomView reDraw];
                    });
                });
            }
        }else if ([message[@"channel"] isEqualToString:[self getMemberAccount][@"subscribe"]]){
            NSLog(@"-=-==-=-%@",message);
            
        }
    }
}

-(void)dealRadio:(NSString*)price_change_ratio{
    if (price_change_ratio.length) {
        self.ratioLabel.text = NSStringFormat(@" %@ ",price_change_ratio);
        if ([price_change_ratio containsString:@"-"]) {
            self.ratioLabel.textColor = [UIColor decreaseColor];
            self.ratioLabel.backgroundColor = [[UIColor decreaseColor] colorWithAlphaComponent:0.1];
        }else{
            self.ratioLabel.textColor = [UIColor increaseColor];
            self.ratioLabel.backgroundColor = [[UIColor increaseColor] colorWithAlphaComponent:0.1];
        }
    }else{
        self.ratioLabel.backgroundColor = [UIColor clearColor];
    }
}


-(void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.menuView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-40);
    }];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerClass:[CAEntrustTableViewCell class] forCellReuseIdentifier:@"CAEntrustTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CAEmptyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CAEmptyTableViewCell"];
    [self tableHeaderView];
    

}

#pragma mark tableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allEntrustArray.count?self.allEntrustArray.count:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.allEntrustArray.count?115:180;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.allEntrustArray.count) {
       
        CAEntrustTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAEntrustTableViewCell"];
        if (self.allEntrustArray.count>indexPath.row) {
            cell.model = self.allEntrustArray[indexPath.row];
        }
        
        return cell;
    }else{
        CAEmptyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAEmptyTableViewCell"];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.allEntrustArray.count) {
        
        [self cancleEntrust:self.allEntrustArray[indexPath.row]];
    }
}

-(void)cancleEntrust:(CAEntrustModel *)model{
    kWeakSelf(self);
    [CAAlertView showAlertWithTitle:CALanguages(@"您确定取消当前委托吗？")  message:@"" completionBlock:^(NSUInteger buttonIndex, CAAlertView * _Nonnull alertView) {
        if (buttonIndex==1) {
            NSDictionary * para = @{
                @"order_id":NSStringFormat(@"%@",model.ID)
            };
            [SVProgressHUD show];

            [CANetworkHelper POST:CAAPI_CRYPTO_TO_CRYPTO_CANCEL_ORDERS parameters:para success:^(id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject[@"code"] integerValue]==20000) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself getRatios];
                        [weakself getCurrentOrders];
                    });
                }
                Toast(responseObject[@"message"]);
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }
    } cancelButtonTitle:CALanguages(@"取消") otherButtonTitles:CALanguages(@"确定"),nil];
    
    
}

-(void)cancleAllEntrust{
    kWeakSelf(self);
    [CAAlertView showAlertWithTitle:CALanguages(@"您确定取消当前所有委托吗？") message:@"" completionBlock:^(NSUInteger buttonIndex, CAAlertView * _Nonnull alertView) {
    if (buttonIndex==1) {
            NSDictionary * para = @{
                @"market_id":NSStringFormat(@"%@",self.currentSymbolModel.market_id)
            };
            [SVProgressHUD show];

            [CANetworkHelper POST:CAAPI_CRYPTO_TO_CRYPTO_CANCEL_ALL_ORDERS parameters:para success:^(id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject[@"code"] integerValue]==20000) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself getRatios];
                        [weakself getCurrentOrders];
                    });
                }
                Toast(responseObject[@"message"]);
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
    }
    } cancelButtonTitle:CALanguages(@"取消") otherButtonTitles:CALanguages(@"确定"),nil];
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
           self->_isfavorates=NO;
        }else{
           self->_isfavorates=YES;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)tableHeaderView{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 455)];
    self.tableView.tableHeaderView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MainWidth);
        make.height.mas_equalTo(455);
    }];
    
    
    
    self.bibiIOView = [CABiBiIOView new];
    [view addSubview:self.bibiIOView];
    self.bibiIOView.delegata = self;
    [self.bibiIOView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view).offset(10);
        make.width.mas_equalTo(MainWidth*0.55);
        make.height.equalTo(@355);
    }];
    
    
    
    self.rightHeaderView = [CABBtradingHeaderRightView new];
    [view addSubview:self.rightHeaderView];
    [self.rightHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bibiIOView.mas_right).offset(15);
        make.top.equalTo(self.bibiIOView.mas_top);
        make.right.equalTo(view).offset(-15);
        make.bottom.equalTo(self.bibiIOView.mas_bottom);
    }];
    
    
    
    UIView * lineView = [UIView new];
    [view addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@10);
        make.top.equalTo(self.rightHeaderView.mas_bottom).offset(15);
    }];
    
    
    titleLable = [UILabel new];
    [view addSubview:titleLable];
    titleLable.font = FONT_SEMOBOLD_SIZE(19);
    titleLable.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(20);
    }];
    
    
    _showAllButton = [CAButton new];
    [view addSubview:_showAllButton];
    _showAllButton.imageView.image = IMAGE_NAMED(@"bb_entrust_all");
    _showAllButton.titleLabel.font = FONT_MEDIUM_SIZE(13);
    _showAllButton.titleLabel.textColor = HexRGB(0xa1a8c7);
    _showAllButton.style = CAButtonStyleLeft;
    
    [_showAllButton layoutWithImageSize:CGSizeMake(15, 15) space:5 style:CAButtonStyleLeft];
    [_showAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(titleLable);
        make.height.equalTo(@25);
    }];
    
    
    
     _revoleAllButton = [CAButton new];
    [view addSubview:_revoleAllButton];
    _revoleAllButton.imageView.image = IMAGE_NAMED(@"bb_entrust_back_action");
    _revoleAllButton.titleLabel.font = FONT_MEDIUM_SIZE(13);
    _revoleAllButton.titleLabel.textColor = HexRGB(0xa1a8c7);
    _revoleAllButton.style = CAButtonStyleLeft;
    [_revoleAllButton layoutWithImageSize:CGSizeMake(15, 15) space:5 style:CAButtonStyleLeft];
    [_revoleAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_showAllButton.mas_left).offset(-20);
        make.centerY.equalTo(titleLable);
        make.height.equalTo(@25);
    }];
    _revoleAllButton.hidden = YES;
    
    [_showAllButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAllEntrustController)]];
    [_revoleAllButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleAllEntrust)]];

}


-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:@"listViewChoosePrice"]) {
        self.bibiIOView.priceStr  = userInfo;
    }
}

-(void)gotoLoginController{
    
    CAloginViewController * login = [[CAloginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}
-(void)showAllEntrustController{
    
    CAEntrustListViewController * entrustList = [CAEntrustListViewController new];
    entrustList.market_id = self.currentSymbolModel.market_id;
    [self.navigationController pushViewController:entrustList animated:YES];
}

#pragma mark 初始化顶部选项
-(void)initMenuView{
    
     self.menuView = [UIView new];
    [self.view addSubview:self.menuView];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
        make.height.equalTo(@40);
    }];
    
    
    UIImageView * imageV = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"more")];
    [self.menuView addSubview:imageV];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuView).offset(15);
        make.centerY.equalTo(self.menuView);
        make.width.height.equalTo(@18);
    }];
    
    
    
    _marketIdLabel = [UILabel new];
    [self.menuView addSubview:_marketIdLabel];
    _marketIdLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
    _marketIdLabel.font = FONT_SEMOBOLD_SIZE(20);
    [_marketIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(5);
        make.centerY.equalTo(self.menuView);
    }];
    
    self.ratioLabel = [UILabel new];
    [self.menuView addSubview:self.ratioLabel];
    self.ratioLabel.font = ROBOTO_FONT_REGULAR_SIZE(14);
    self.ratioLabel.layer.masksToBounds = YES;
    self.ratioLabel.layer.cornerRadius = 2;
    [self.ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_marketIdLabel.mas_right).offset(5);
        make.centerY.equalTo(self.menuView);
    }];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchView)];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSearchView)];
    _marketIdLabel.userInteractionEnabled = YES;
    imageV.userInteractionEnabled = YES;
    [_marketIdLabel addGestureRecognizer:tap];
    [imageV addGestureRecognizer:tap1];
    
    
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuView addSubview:_moreButton];
    _moreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_moreButton setImage:IMAGE_NAMED(@"bb_more") forState:UIControlStateNormal];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.menuView);
        make.width.height.equalTo(@22);
        make.right.equalTo(self.menuView).offset(-15);
    }];
    
    
    
    
    UIButton * showChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuView addSubview:showChatButton];
    showChatButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [showChatButton setImage:IMAGE_NAMED(@"bb_jumpto_kline") forState:UIControlStateNormal];
    
    [showChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.menuView);
        make.width.height.equalTo(@20);
        make.right.equalTo(_moreButton.mas_left).offset(-20);
    }];
    
    [showChatButton addTarget:self action:@selector(showChatController) forControlEvents:UIControlEventTouchUpInside];
    [_moreButton addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showMoreAction:(UIButton*)btn{
    
    if (![CAUser currentUser].isAvaliable) {
        
        [self gotoLoginController];
        return;
    }
    
    CAMenuAction * action1;
    if (_isfavorates) {
        action1 = [CAMenuAction actionWithTitle:@"移除自选"  image:nil handler:^(CAMenuAction *action) {
            [self remove_from_favorates];
        }];
    }else{
        action1 = [CAMenuAction actionWithTitle:@"添加自选" image:nil handler:^(CAMenuAction *action) {
            [self add_to_favorates];
        }];
    }
   
    #pragma clang diagnostic pop
    CAMenuView * menuView = [CAMenuView menuWithActions:@[action1] width:150 relyonView:btn];
    
    [menuView show];
}

-(void)add_to_favorates{
     
    [CASymbolsModel add_to_favorates:self.currentSymbolModel.market_id finshed:^(BOOL isTrue) {
        if (isTrue) {
            self->_isfavorates=YES;
        }
    }];
}
-(void)remove_from_favorates{
    
    [CASymbolsModel remove_from_favorates:self.currentSymbolModel.market_id finshed:^(BOOL isTrue) {
        if (isTrue) {
            self->_isfavorates=NO;
        }
    }];
}


-(void)showChatController{
    
    BTStockChartViewController * chat = [[BTStockChartViewController alloc] init];
    chat.currentSymbolModel = self.currentSymbolModel;
    chat.backBlock = ^(CASymbolsModel *model, TradingType type) {
        [self didReciveSymbolModelFromOrtherController:model type:type];
    };
    [self.navigationController pushViewController:chat animated:YES];
}

-(void)didReciveSymbolModelFromOrtherController:(CASymbolsModel*)model type:(TradingType)type{
    if (![self.currentSymbolModel.market_id isEqualToString:model.market_id]) {
        self.currentSymbolModel = model;
        [self didSignin];
    }
    self.bibiIOView.tradeType = type;
}

-(CABBSearshView *)searchView{
    if (!_searchView) {
        _searchView = [[CABBSearshView alloc] initWithFrame:CGRectMake(0, 0, MainWidth*0.7,MainHeight)];
        _searchView.delegata = self;
    }
    return _searchView;
}

-(void)showSearchView{
 
    [self.searchView showInView:self.navigationController.view isAnimation:YES direaction:CABaseAnimationDirectionFromLeft];
}

#pragma mark  初始化底部分时图

-(CABBBottomTimeLineView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[CABBBottomTimeLineView alloc] initWithFrame:CGRectMake(0, MainHeight-SafeAreaBottomHeight-49-40, MainWidth, 210)];
        [self.view addSubview:_bottomView];
        _bottomView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
        [_bottomView isYYTop];        
    }
    return _bottomView;
}

@end
