//
//  CAMoneyViewController.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMoneyViewController.h"
#import "CAMoneyTableViewHeaderView.h"
#import "CAMoneyTableViewCell.h"
#import "CACurrencyMoneyModel.h"
#import "CAAssetDetailsViewController.h"

@interface CAMoneyViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) CAMoneyTableViewHeaderView * headView;

@end

@implementation CAMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"我的资产";
    self.titleColor = [UIColor whiteColor];
    self.backTineColor = [UIColor whiteColor];
    self.navcBar.backgroundColor = [UIColor clearColor];
    
    [SVProgressHUD show];
    [self.view addSubview:self.headView];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getData];
}

-(void)getData{

    
    [CANetworkHelper GET:CAAPI_MINE_ASSETS parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * data = responseObject[@"data"];
            self.dataArray = [CACurrencyMoneyModel getModels:data[@"assets"]];
                   
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.headView.total_in_fiat = data[@"total_in_fiat"];
                self.headView.total_in_crypto = data[@"total_in_crypto"];
               [self.tableView reloadData];
            });
        }else{
            Toast(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CAMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CAMoneyTableViewCell"];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<self.dataArray.count) {
        CAAssetDetailsViewController * asset = [CAAssetDetailsViewController new];
        CACurrencyMoneyModel * model = self.dataArray[indexPath.row];
        asset.code = model.currency_code;
        [self.navigationController pushViewController:asset animated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(278+KTopRevise, 0, 0, 0));
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CAMoneyTableViewCell class] forCellReuseIdentifier:@"CAMoneyTableViewCell"];
        
       
    }
    return _tableView;
}

-(CAMoneyTableViewHeaderView *)headView{
    if (!_headView) {
        _headView = [[CAMoneyTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 278+KTopRevise)];
    }
    return _headView;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    if ([eventName isEqualToString:@"pushViewController"]) {
        UIViewController * contro = [[NSClassFromString(userInfo) alloc] init];
        [self.navigationController pushViewController:contro animated:YES];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
