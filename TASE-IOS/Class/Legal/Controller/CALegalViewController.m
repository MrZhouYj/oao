//
//  CALegalViewController.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CALegalViewController.h"
#import "CALegalTopMenuView.h"
#import "CASegmentView.h"
#import "CALegalTableViewCell.h"
#import "FSPageContentView.h"
#import "CALegalTableView.h"
#import "CACreatOrderView.h"
#import "CAOrderViewController.h"
#import "CAMyOrderListViewController.h"
#import "CACurrencyModel.h"
#import "CAAdvertisementModel.h"
#import "CAAlertView.h"
#import "CApaymentMethodViewController.h"

@interface CALegalViewController ()
<
CACreatOrderViewDelegate,
CASegmentViewDelegate,
CALegalTopMenuViewDelegata,
FSPageContentViewDelegate
>
{
    NSString * _trade_type;
    BOOL _isLoadingData;
}

@property (nonatomic, assign) NSInteger allPage;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIView *topView;
/**
 我要买 我要卖
 */
@property (nonatomic, strong) CALegalTopMenuView *menuView;
@property (nonatomic, strong) CASegmentView *segmentView;
@property (nonatomic, strong) FSPageContentView * pageView;
@property (nonatomic, strong) NSArray * segmentItemsArray;
@property (nonatomic, strong) NSArray * tableViewsArray;
@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation CALegalViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    if ([[CASkinManager getCurrentSkinType] isEqualToString:DKThemeVersionNormal]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    if (self.pageView.childsViews.count) {
        [self getData];
    }else{
        [self getList];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _trade_type = @"buy";
    self.currentIndex = 0;
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(GrayBackGroundColor);
    
    [self initSubViews];
    
//    [self languageDidChange];
    [SVProgressHUD show];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDidConnect) name:CANetworkDidConenctNotifacation object:nil];
}

-(void)netWorkDidConnect{
    
    if (self.segmentItemsArray.count) {
        [self freshData];
    }else{
        [self languageDidChange];
    }
}

-(void)languageDidChange{
    self.navcTitle = CALanguages(@"法币");
    [self resetPage];
    [self getList];
}

-(void)getList{
    
    [CANetworkHelper GET:CAAPI_OTC_LANDING parameters:nil success:^(id responseObject) {
        //刷新数据
        NSArray * currency = responseObject[@"data"][@"otc_currencies"];
        self.segmentItemsArray = [CACurrencyModel getModels:currency];
        [CACurrencyModel saveModels:currency byKey:@"otc_currencies"];
        [self performSelector:@selector(freshListData) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
        

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)creatOrderClick:(NSString *)order_price
          order_amount:(NSString *)order_amount
       originDictinary:(nonnull NSDictionary *)originDictionary
             orderView:(nonnull CACreatOrderView *)orderView{
     
    
    NSDictionary * para = @{
        @"advertisement_id":originDictionary[@"id"],
        @"value":order_price,
    };
    
    [SVProgressHUD show];
    [CANetworkHelper POST:CAAPI_OTC_CREATE_TRADING parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [orderView hide:NO];
                CAOrderViewController * order = [CAOrderViewController new];
                order.advertisement_id = responseObject[@"data"];
                [self.navigationController pushViewController:order animated:YES];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(LYEmptyView*)getEmptyView{
    
  
    LYEmptyView * emptyView = [LYEmptyView emptyActionViewWithImage:IMAGE_NAMED(@"networknull") titleStr:CALanguages(@"无网络") detailStr:nil btnTitleStr:CALanguages(@"点击重新加载") target:self action:@selector(freshData)];
    
    emptyView.titleLabTextColor = RGB(171, 175, 204);
    emptyView.titleLabFont = FONT_REGULAR_SIZE(15);
    emptyView.actionBtnFont = FONT_REGULAR_SIZE(15);
    emptyView.actionBtnTitleColor = RGB(0, 108, 219);
    emptyView.actionBtnBorderColor = RGB(0, 108, 219);
    emptyView.actionBtnBorderWidth = 1;
    emptyView.actionBtnCornerRadius = 2;
    emptyView.imageSize = CGSizeMake(83/414.f*MainWidth, 83/414.f*MainWidth);
    emptyView.contentViewY = kTopHeight+100;
    emptyView.autoShowEmptyView = NO;
    
    return emptyView;
}

-(void)freshListData{

    self.segmentView.segmentItems = [CASegmentView getItemsFromArray:self.segmentItemsArray];
    [self initPageContentView];
    
    self.segmentView.segmentCurrentIndex = 0;
}


-(void)getData{
    
    if (self.currentIndex>=self.segmentItemsArray.count) {
        [SVProgressHUD dismiss];
        return;
    }
    
    CACurrencyModel * currency = self.segmentItemsArray[self.currentIndex];
    CALegalTableView * tableView = (CALegalTableView*)[self.pageView.childsViews objectAtIndex:self.currentIndex];

    tableView.isLoadingData = YES;
  
    NSDictionary * para = @{
        @"current_page":@(self.currentPage),
        @"trade_type":_trade_type,
        @"code":NSStringFormat(@"%@",currency.code)
    };
    
    
    [CANetworkHelper GET:CAAPI_OTC_GET_ADVERTISEMENTS parameters:para success:^(id responseObject) {
        tableView.isLoadingData = NO;
        [tableView endFresh];
        //刷新数据
        if ([responseObject[@"code"] integerValue]==20000) {
            
            self.currentPage = [responseObject[@"current_page"] integerValue];
            self.allPage = [responseObject[@"total_page"] integerValue];
            if (self.currentPage>=self.allPage) {
                [tableView noMoreData];
            }else{
                [tableView setStateToIdle];
            }
            
            if (responseObject[@"data"]) {
                NSMutableArray * currentData = @[].mutableCopy;
                NSArray * models = [CAAdvertisementModel getModels:responseObject[@"data"]];
                if (self.currentPage==1) {
                    currentData = models.mutableCopy;
                }else{
                    [currentData addObjectsFromArray:models];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    tableView.dataSourceArray = currentData;
                });
            }
        }else{
            //数据请求失败 没有数据会自动显示占位图
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        tableView.isLoadingData = NO;
        [tableView endFresh];
        [SVProgressHUD dismiss];
    }];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:@"creatOrderAction"]) {
        
        CAUser * user = [CAUser currentUser];
        if (!user.isAvaliable) {
          
            CAloginViewController * login = [[CAloginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            return;
        }
        
        if (_isLoadingData) {
            return;
        }
        _isLoadingData = YES;
        CAAdvertisementModel * model = (CAAdvertisementModel*)userInfo;
        NSDictionary * para = @{
            @"id":model.ID
        };
        
        [SVProgressHUD show];
        [CANetworkHelper GET:CAAPI_OTC_IS_ADVERTISEMENT_CANCELLED parameters:para success:^(id responseObject) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",responseObject);
            if ([responseObject[@"code"] integerValue]==20000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCreatOrderView:responseObject[@"data"]];
                });
            }else if ([responseObject[@"code"] integerValue]==40039){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CAAlertView showAlertWithTitle:responseObject[@"message"] message:@"" completionBlock:^(NSUInteger buttonIndex, CAAlertView * _Nonnull alertView) {
                        
                        if (buttonIndex==1) {
                            CApaymentMethodViewController * method = [CApaymentMethodViewController new];
                            [self.navigationController pushViewController:method animated:YES];
                        }
                        
                    } cancelButtonTitle:CALanguages(@"取消")  otherButtonTitles:CALanguages(@"添加"),nil];
                });
            }else{
                Toast(responseObject[@"message"]);
            }
            self->_isLoadingData = NO;
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            self->_isLoadingData = NO;
        }];
    }else if ([eventName isEqualToString:@"loadNextPageData"]){
        //加载下一页的数据
        self.currentPage++;
        [self getData];
    }else if ([eventName isEqualToString:@"freshData"]){
        //加载下一页的数据
        [self freshData];
    }
}

-(void)freshData{
    [self resetPage];
    [self getData];
}

#pragma mark 购买弹窗

-(void)showCreatOrderView:(NSDictionary*)originDictionary{
    
    
    CGFloat height = SafeAreaBottomHeight+285+45+15;
    CACreatOrderView * creatOrderView = [[CACreatOrderView alloc] initWithFrame:CGRectMake(0, MainHeight-height, MainWidth, height)];
    creatOrderView.dele = self;
    creatOrderView.originDictionary = originDictionary;
    [creatOrderView showInView:self.navigationController.view isAnimation:YES direaction:CABaseAnimationDirectionFromBottom];
    
}

-(void)CALegalTopMenuView_didSelectedIndex:(NSString *)trade_type{
    _trade_type = trade_type;
    [self resetPage];
    [self getData];
}


-(void)initSubViews{
    
    
    self.topView = [UIView new];
    [self.view addSubview:self.topView];
    self.topView.frame = CGRectMake(0, 0, MainWidth, kTopHeight+20+41+33);
    
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"background")];
    [self.topView addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    
    self.menuView = [CALegalTopMenuView new];
    [self.topView addSubview:self.menuView];
    self.menuView.delegata = self;
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.top.equalTo(self.topView).offset(kTopHeight+20);
        make.height.equalTo(@41);
    }];
    
    
    
    self.segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 33)];
    [self.topView addSubview:self.segmentView];
    self.segmentView.isFixedSpace = NO;
    self.segmentView.delegata = self;
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.top.equalTo(self.menuView.mas_bottom);
        make.height.equalTo(@33);
    }];
    
    
    self.pageView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, self.topView.height, MainWidth, MainHeight-kTabBarHeight-self.topView.height) delegate:self];
    [self.view addSubview:self.pageView];
    self.pageView.ly_emptyView = [self getEmptyView];
    
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navcBar addSubview:moreButton];
    [moreButton setEnlargeEdgeWithTop:5 right:15 bottom:5 left:20];
    moreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [moreButton setImage:[IMAGE_NAMED(@"bb_more") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [moreButton setTintColor:[UIColor whiteColor]];
    [moreButton addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navcBar.titleLabel);
        make.width.height.equalTo(@22);
        make.right.equalTo(self.topView).offset(-15);
    }];

}

-(void)showMoreAction:(UIButton*)btn{
    
    kWeakSelf(self);
    CAMenuAction * action1 = [CAMenuAction actionWithTitle:@"我的订单" image:nil handler:^(CAMenuAction *action) {
        
        [weakself checkIsLogin:2];
        
    }];
    CAMenuAction * action2 = [CAMenuAction actionWithTitle:@"我的广告" image:nil handler:^(CAMenuAction *action) {
        [weakself checkIsLogin:1];
        
    }];
    
    CAMenuView * menuView = [CAMenuView menuWithActions:@[action1,action2] width:150 relyonView:btn];
    [menuView show];
}

-(void)checkIsLogin:(NSInteger)type{
    
    CAUser * user = [CAUser currentUser];
    if (!user.isAvaliable) {
      
        CAloginViewController * login = [[CAloginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];

    }else{
        [self jumpToNextController:type];
    }
}

-(void)jumpToNextController:(NSInteger)type{
    if (type==2) {
        CAMyOrderListViewController * order = [CAMyOrderListViewController new];
        order.type = 2;
        [self.navigationController pushViewController:order animated:YES];
    }else if (type==1){
        CAMyOrderListViewController * order = [CAMyOrderListViewController new];
        order.type = 1;
        [self.navigationController pushViewController:order animated:YES];
    }
}

-(void)initPageContentView{
    
    NSMutableArray * tableViews = @[].mutableCopy;
    for (int i=0; i<self.segmentItemsArray.count; i++) {
        CALegalTableView * tableView = [CALegalTableView new];
        [tableViews addObject:tableView];
    }
    self.pageView.childsViews = tableViews;
    
}

#pragma mark FSPageContentViewDelegate

-(void)FSContentViewDidScroll:(FSPageContentView *)contentView index:(NSInteger)index{

    if (self.segmentView.segmentCurrentIndex!=index) {
        self.segmentView.segmentCurrentIndex = index;
    }
}

-(void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    self.segmentView.segmentCurrentIndex = endIndex;
    self.currentIndex = endIndex;
    
}

-(void)CASegmentView_didSelectedIndex:(NSInteger)index{
    
    self.currentIndex = index;
    self.pageView.contentViewCurrentIndex = index;
    
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self resetPage];
    [self getData];
}


-(void)resetPage{
    self.currentPage = 1;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
