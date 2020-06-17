//
//  CAMyOrderListViewController.m
//  TASE-IOS
//
//   10/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMyOrderListViewController.h"
#import "CARowView.h"
#import "CASegmentView.h"
#import "CAOrderListTableViewCell.h"
#import "CACreatADViewController.h"
#import "CACurrencyModel.h"
#import "CAOrderModel.h"
#import "CAAdvertisementModel.h"
#import "CALegalTableViewCell.h"
#import "CAOrderViewController.h"
#import "CAFreshTableView.h"
@interface CAMyOrderListViewController ()
<UITableViewDelegate,
UITableViewDataSource,
CASegmentViewDelegate,
CARowViewDelegata
>
{
    BOOL _isDidAppear;
}
@property (nonatomic, strong) NSMutableArray * dataSourceArray;
@property (nonatomic, strong) CAFreshTableView * tableView;
@property (nonatomic, strong) CARowView * rowView;
@property (nonatomic, strong) CASegmentView * segmentView;

@property (nonatomic, copy) NSString * sellTitle;
@property (nonatomic, copy) NSString * buyTitle;

@property (nonatomic, copy) NSString * trade_type;

@property (nonatomic, strong) NSArray * currencies;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger allPage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isNoMoreData;


@end

@implementation CAMyOrderListViewController

-(NSArray *)currencies{
    if (!_currencies) {
        _currencies = [CACurrencyModel getModelsByKey:@"otc_currencies"];
    }
    return _currencies;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    
    if (self.type==1) {
        self.navcTitle = @"我的广告";
    }else if (self.type==2){
        self.navcTitle = @"我的订单";
    }
    
    self.trade_type = @"sell";
    
    [self initTopView];
    [SVProgressHUD show];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.segmentView&&self.segmentView.segmentItems.count) {
        self.segmentView.segmentCurrentIndex = self.currentIndex;
    }
}

-(void)CASegmentView_didSelectedIndex:(NSInteger)index{
    self.currentIndex = index;
    [self resetPage];
    [self getData];
}

-(void)getData{
    
    NSString * url = CAAPI_OTC_MY_ADVERTISEMENTS;
    if (self.type==2) {
        url = CAAPI_OTC_MY_ORDERS;
    }
    
    CACurrencyModel * model = self.currencies[self.currentIndex];
    if (!model.code) {
        return;
    }
    NSMutableDictionary*para = @{}.mutableCopy;
    if (self.type==2) {
        [para setValue:@(self.currentPage) forKey:@"current_page"];
    }
    [para setValue:NSStringFormat(@"%@",model.code) forKey:@"code"];
    [para setValue:NSStringFormat(@"%@",self.trade_type) forKey:@"trade_type"];
    
    [CANetworkHelper GET:url parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            if (self.type==1) {
                [self.dataSourceArray removeAllObjects];
                [self.dataSourceArray addObjectsFromArray:[CAAdvertisementModel getModels:responseObject[@"data"]]];
            }else if (self.type==2){
                
                self.currentPage = [responseObject[@"current_page"] integerValue];
                self.allPage = [responseObject[@"total_page"] integerValue];
                if (self.currentPage>=self.allPage) {
                    self.isNoMoreData = YES;
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }else{
                    self.isNoMoreData = NO;
                    [self.tableView.mj_footer setState:MJRefreshStateIdle];
                }
                
                if (self.currentPage==1) {
                    [self.dataSourceArray removeAllObjects];
                }
                
                [self.dataSourceArray addObjectsFromArray:[CAOrderModel getModels:responseObject[@"data"]]];
            }
            
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

-(void)initTopView{
    
    UIView * topView = [UIView new];
    [self.view addSubview:topView];
    topView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navcBar.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    self.rowView = [CARowView new];
    [topView addSubview:self.rowView];
    self.rowView.title = self.sellTitle;
    self.rowView.titleFont = FONT_REGULAR_SIZE(17);
    self.rowView.titleColor = HexRGB(0x191d26);
    self.rowView.imageTineColor = HexRGB(0x191d26);
    self.rowView.up = YES;
    self.rowView.delegata = self;
    self.rowView.layOut = CARowViewLayoutBetween;
    
    [self.rowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.top.bottom.equalTo(topView);
        make.width.equalTo(@200);
    }];
    
    if (self.type==1) {
        //添加+
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:addButton];
        
        [addButton setImage:[IMAGE_NAMED(@"order_add") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [addButton setTintColor:HexRGB(0x000000)];
        [addButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topView).offset(-15);
            make.centerY.equalTo(topView);
            make.width.height.equalTo(@20);
        }];
        
        [addButton addTarget:self action:@selector(addAvClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    self.segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 40)];
    [self.view addSubview:self.segmentView];
    self.segmentView.delegata = self;
    self.segmentView.isFixedSpace = NO;
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.rowView.mas_bottom);
        make.height.equalTo(@40);
    }];
    self.segmentView.segmentItems = [CACurrencyModel getCodeBigArray:self.currencies];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentView.mas_bottom);
    }];
    
   
//    self.tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[CAOrderListTableViewCell class] cellHeight:195];
//    self.tableView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
//    self.tableView.tabAnimated.adjustBlock = ^(TABComponentManager * manager){
//        manager.animation(10).remove();
//    };
}

-(void)addAvClick{
    
    CACreatADViewController * ad = [CACreatADViewController new];
    [self.navigationController pushViewController:ad animated:YES];
}

-(void)CARowView_didChangeRowState:(int)state rowView:(nonnull CARowView *)rowView{
    
    CAMenuAction * action1 = [CAMenuAction actionWithTitle:self.sellTitle image:nil handler:^(CAMenuAction *action) {
        self.rowView.title = self.sellTitle;
        self.rowView.up = !self.rowView.up;
        self.trade_type = @"sell";
        [SVProgressHUD show];
        [self resetPage];
        [self getData];
    }];
    CAMenuAction * action2 = [CAMenuAction actionWithTitle:self.buyTitle image:nil handler:^(CAMenuAction *action) {
        self.rowView.title = self.buyTitle;
        self.rowView.up = !self.rowView.up;
        self.trade_type = @"buy";
        [SVProgressHUD show];
        [self resetPage];
        [self getData];
    }];
    
    CAMenuView * menuView = [CAMenuView menuWithActions:@[action1,action2] width:150 relyonView:self.rowView];
    
    [menuView show];
}


#pragma mark tableView代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type==1) {
        return [CALegalTableViewCell getCellHeight];
    }else if (self.type==2){
        return [CAOrderListTableViewCell getCellHeight];
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type==1) {
        CALegalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CALegalTableViewCell"];
        cell.action_type = @"MyAdvertisementList";
        cell.model = self.dataSourceArray[indexPath.row];
        
        return cell;
    }else{
        CAOrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAOrderListTableViewCell"];
         cell.model = self.dataSourceArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type==1) {
        CACreatADViewController * adViewController = [CACreatADViewController new];
        adViewController.model = [self.dataSourceArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:adViewController animated:YES];
    }else if (self.type==2){
        
        CAOrderViewController * order = [CAOrderViewController new];
        CAOrderModel * model = self.dataSourceArray[indexPath.row];
        order.advertisement_id = model.ID;
        [self.navigationController pushViewController:order animated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[CAFreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        kWeakSelf(self);
        [_tableView addReFreshHeader:^{
            [weakself resetPage];
            [weakself getData];
        }];
        if (self.type==2) {
            [_tableView addReFreshFooter:^{
                
            }];
        }
        [_tableView registerClass:[CAOrderListTableViewCell class] forCellReuseIdentifier:@"CAOrderListTableViewCell"];
        [_tableView registerClass:[CALegalTableViewCell class] forCellReuseIdentifier:@"CALegalTableViewCell"];
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row==self.dataSourceArray.count-2&&!self.isNoMoreData&&self.type==2) {
        
        self.currentPage++;
        [self getData];
    }
}
-(void)resetPage{
    self.currentPage = 1;
    
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = @[].mutableCopy;
    }
    return _dataSourceArray;
}

-(NSString *)buyTitle{
    if (self.type==1) {
        return CALanguages(@"买入广告");
    }else if (self.type==2){
        return CALanguages(@"买入订单");
    }else{
        return @"";
    }
}
-(NSString *)sellTitle{
    if (self.type==1) {
        return CALanguages(@"卖出广告") ;
    }else if (self.type==2){
        return CALanguages(@"卖出订单");
    }else{
        return @"";
    }
}


@end
