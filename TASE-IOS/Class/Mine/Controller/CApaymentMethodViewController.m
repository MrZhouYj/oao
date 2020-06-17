//
//  CApaymentMethodViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CApaymentMethodViewController.h"
#import "CAAddPayListViewController.h"
#import "CAPayMethodsListTableViewCell.h"
#import "CAAddPayViewController.h"

@interface CApaymentMethodViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary * dataDic;

@property (nonatomic, strong) CABaseButton * saveButton;

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation CApaymentMethodViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView&&self.dataDic) {
        [self getData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"收款方式";
    self.dataDic = @{}.mutableCopy;
    
    [self addPayMenthodButton];
    
    [self getData];
    
    [SVProgressHUD show];
}

-(void)getData{

    [CANetworkHelper GET:CAAPI_MINE_SHOW_PAYMENT_METHODS_PAGE parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * dic = responseObject[@"data"];
            for (NSString * key in dic.allKeys) {
                NSDictionary * pay = [dic objectForKey:key];
                if (pay&&[pay[@"is_binded"] boolValue]) {
                    [self.dataDic setValue:dic[key] forKey:key];
                }
            }
            
            if (self.dataDic.allKeys.count==3||self.dataDic.allKeys.count==0) {
                self.saveButton.hidden = YES;
            }else{
                self.saveButton.hidden = NO;
                self.saveButton.enabled = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        self.tableView.ly_emptyView.hidden = self.dataDic.allKeys.count;
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        self.tableView.ly_emptyView.hidden = self.dataDic.allKeys.count;
    }];
}


-(void)emptyViewAddClick{
    
    if ([CAUser currentUser].is_identified_success) {

        CAAddPayListViewController * add = [CAAddPayListViewController new];
        [self.navigationController pushViewController:add animated:YES];
    }else{
        Toast(CALanguages(@"未实名认证"));
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataDic.allKeys.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 132;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CAPayMethodsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAPayMethodsListTableViewCell"];
    
    NSArray * keys = self.dataDic.allKeys;
    if (indexPath.row<keys.count) {
        cell.dataDic = [self.dataDic objectForKey:keys[indexPath.row]];
        cell.key = keys[indexPath.row];
    }
    
    return cell;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    if ([eventName isEqualToString:@"activationAction"]) {
        
        [self updateActivationStatus:userInfo];
    }
}

-(void)updateActivationStatus:(NSString*)pay{
    
    NSDictionary * para = @{
        @"payment":NSStringFormat(@"%@",pay)
    };

    [CANetworkHelper POST:CAAPI_MINE_UPDATE_PAYMENT_ACTIVATED_STATUS parameters:para success:^(id responseObject) {
       
        if ([responseObject[@"code"] integerValue]==20000) {
            [self getData];
        }else{
            Toast(responseObject[@"message"]);
        }
       
    } failure:^(NSError *error) {
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * keys = self.dataDic.allKeys;
    if (indexPath.row<keys.count) {
        NSString * key = keys[indexPath.row];
        CAAddPayViewController * addPay = [CAAddPayViewController new];
        addPay.payType  = key;
        addPay.dataDic = self.dataDic[key];
        [self.navigationController pushViewController:addPay animated:YES];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 49+SafeAreaBottomHeight, 0));
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        UIView * lineView = [UIView new];
        lineView.frame = CGRectMake(0, 0, MainWidth, 10);
        lineView.backgroundColor = HexRGB(0xf6f6fa);
        _tableView.tableHeaderView = lineView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CAPayMethodsListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CAPayMethodsListTableViewCell"];
        [self addEmptyView];
    }
    return _tableView;
}

-(void)addPayMenthodButton{
    
    self.saveButton = [CABaseButton buttonWithTitle:@"新建"];
    [self.view addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(emptyViewAddClick) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.hidden = YES;
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@43);
        make.bottom.equalTo(self.view).offset(-(SafeAreaBottomHeight+10));
    }];
}

-(void)addEmptyView{
    LYEmptyView * emptyView = [LYEmptyView emptyActionViewWithImage:IMAGE_NAMED(@"payment_empty") titleStr:CALanguages(@"请务必使用您本人的实名账户")  detailStr:nil btnTitleStr:CALanguages(@"添加") target:self action:@selector(emptyViewAddClick)];
    emptyView.autoShowEmptyView = NO;
    emptyView.titleLabTextColor = RGB(171, 175, 204);
    emptyView.titleLabFont = FONT_REGULAR_SIZE(15);
    emptyView.actionBtnFont = FONT_REGULAR_SIZE(15);
    emptyView.actionBtnTitleColor = RGB(0, 108, 219);
    emptyView.actionBtnBorderColor = RGB(0, 108, 219);
    emptyView.actionBtnBorderWidth = 1;
    emptyView.actionBtnCornerRadius = 2;
    emptyView.imageSize = CGSizeMake(83/414.f*MainWidth, 83/414.f*MainWidth);
    emptyView.contentViewY = kTopHeight+100;
    emptyView.hidden = YES;
    _tableView.ly_emptyView = emptyView;
    
    
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
