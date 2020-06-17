//
//  CAMoneyViewController.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAssetDetailsViewController.h"
#import "CAAssetDeatilsHeaderView.h"
#import "CAAssetDetailsTableViewCell.h"
#import "CACurrencyMoneyModel.h"
#import "CAFreshTableView.h"
#import "CAAssetRecordDetailViewController.h"
#import "CARechargeViewController.h"
#import "CAWithDrawViewController.h"
#import "CATransferViewController.h"

@interface CAAssetDetailsViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) CAFreshTableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) CAAssetDeatilsHeaderView * headView;

@property (nonatomic, assign) NSInteger allPage;
@property (nonatomic, assign) NSInteger currentPage;


@end

@implementation CAAssetDetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[].mutableCopy;
    self.navcTitle = @"资产详情";
    self.titleColor = [UIColor whiteColor];
    self.backTineColor = [UIColor whiteColor];
    self.navcBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headView];
    
    
    [SVProgressHUD show];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.currentPage = 1;
    [self getData];
}

-(void)getData{
    
    NSDictionary * para = @{
        @"code":NSStringFormat(@"%@",self.code),
        @"current_page":@(self.currentPage),
    };
    
    [CANetworkHelper GET:CAAPI_MINE_ASSETS_RECORDS parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        self.currentPage = [responseObject[@"current_page"] integerValue];
        self.allPage = [responseObject[@"total_page"] integerValue];
        if (self.currentPage>=self.allPage) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }else{
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
        }
        
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * data = responseObject[@"data"];
            self.headView.lokedText = data[@"locked"];
            self.headView.currencyNameText = data[@"code_title"];
            self.headView.currencyMoneyText = data[@"total_in_fiat"];
            self.headView.useText = data[@"balance"];
            self.headView.is_depositable = [data[@"is_depositable"] boolValue];
            self.headView.is_withdrawable = [data[@"is_withdrawable"] boolValue];
            self.headView.is_transferable = [data[@"is_transferable"] boolValue];
        
            if (self.currentPage==1) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray * assets_records = data[@"assets_records"];
            [self.dataArray addObjectsFromArray:assets_records];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, 0, MainWidth, 0);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [UILabel new];
    [view addSubview:titleLabel];
    titleLabel.font = FONT_MEDIUM_SIZE(18);
    titleLabel.textColor = HexRGB(0x151751);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
    }];
    titleLabel.text = CALanguages(@"财务记录");
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CAAssetDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CAAssetDetailsTableViewCell"];
    if (indexPath.row<self.dataArray.count) {
        cell.dataDic = self.dataArray[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<self.dataArray.count) {
        CAAssetRecordDetailViewController * record = [CAAssetRecordDetailViewController new];
        record.dataDic = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:record animated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[CAFreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(278+KTopRevise, 0, 0, 0));
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[CAAssetDetailsTableViewCell class] forCellReuseIdentifier:@"CAAssetDetailsTableViewCell"];
        kWeakSelf(self);
        [_tableView addReFreshFooter:^{
            weakself.currentPage++;
            [weakself getData];
        }];
        
    }
    return _tableView;
}

-(CAAssetDeatilsHeaderView *)headView{
    if (!_headView) {
        _headView = [[CAAssetDeatilsHeaderView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 278+KTopRevise)];
        
    }
    return _headView;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    if ([eventName isEqualToString:@"pushViewController"]) {
        
        UIViewController * contro = [[NSClassFromString(userInfo) alloc] init];
        if ([contro isKindOfClass:[CARechargeViewController class]]||[contro isKindOfClass:[CAWithDrawViewController class]]||[contro isKindOfClass:[CATransferViewController class]]) {
            [contro setValue:[self.code uppercaseString] forKey:@"fromCode"];
        }
        [self.navigationController pushViewController:contro animated:YES];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
