//
//  CAMyFriendListViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMyFriendListViewController.h"
#import "CAFriendListTableViewCell.h"
#import "CAFriendsModel.h"
#import "CAFreshTableView.h"

@interface CAMyFriendListViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) CAFreshTableView *tableView;

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation CAMyFriendListViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.navcTitle = @"我的好友";

    [self getData];
}

-(void)getData{

    
    [CANetworkHelper GET:CAAPI_MINE_FRIENDS parameters:nil success:^(id responseObject) {
       
        if ([responseObject[@"code"] integerValue]==20000) {
            self.dataArray = [CAFriendsModel getModels:responseObject[@"data"][@"my_friends"]];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.tableView reloadData];
            });
        }else{
        
            Toast(responseObject[@"messasge"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CAFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAFriendListTableViewCell"];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[CAFreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:NSClassFromString(@"CAFriendListTableViewCell") forCellReuseIdentifier:@"CAFriendListTableViewCell"];
        
    }
    return _tableView;
}

@end
