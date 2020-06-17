//
//  CAAddPayListViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAddPayListViewController.h"
#import "CAAddPayViewController.h"

@interface CAAddPayListViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation CAAddPayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navcTitle = @"";
     self.dataArray = @[].mutableCopy;
    

    [self tableViewHeaderView];
    [self getData];
}

-(void)getData{

    [CANetworkHelper GET:CAAPI_MINE_NEW_PAYMENT_METHOD parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
       
        if ([responseObject[@"code"] integerValue]==20000) {
            NSArray * data = responseObject[@"data"];
            for (NSString * str in data) {
                if ([str isEqualToString:@"alipay"]) {
                    [self.dataArray addObject:@{
                        @"logoImage":@"Alipay",
                        @"type":str,
                        @"text":@"支付宝",
                    }];
                }else if ([str isEqualToString:@"wechat"]){
                    [self.dataArray addObject:@{
                        @"logoImage":@"WeChat",
                        @"type":str,
                        @"text":@"微信",
                    }];
                }else if ([str isEqualToString:@"bank_card"]){
                    [self.dataArray addObject:@{
                        @"logoImage":@"Bankcard",
                        @"type":str,
                        @"text":@"银行卡",
                    }];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
       
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row<self.dataArray.count) {
        
        cell.imageView.image = IMAGE_NAMED(self.dataArray[indexPath.row][@"logoImage"]);
        
        cell.textLabel.text = CALanguages(self.dataArray[indexPath.row][@"text"]);
        
        cell.textLabel.font = FONT_REGULAR_SIZE(16);
        
        cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.width.height.equalTo(@18);
            make.centerY.equalTo(cell);
        }];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_right).offset(10);
            make.centerY.equalTo(cell.imageView);
        }];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
 
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count>indexPath.row) {
        CAAddPayViewController * view = [CAAddPayViewController new];
        view.payType = self.dataArray[indexPath.row][@"type"];
        [self.navigationController pushViewController:view animated:YES];
    }
}

-(void)tableViewHeaderView{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 50)];
    self.tableView.tableHeaderView = view;
    
    UIImageView * addImageView = [UIImageView new];
    [view addSubview:addImageView];
    addImageView.image = IMAGE_NAMED(@"Addto");
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
        make.width.height.equalTo(@27);
    }];
    
    UILabel * titleLabel = [UILabel new];
    [view addSubview:titleLabel];
    
    titleLabel.font =   FONT_SEMOBOLD_SIZE(27);
    titleLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    titleLabel.text = CALanguages(@"添加") ;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addImageView.mas_right).offset(10);
        make.centerY.equalTo(addImageView);
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
        
    }
    return _tableView;
}

@end
