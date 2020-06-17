//
//  CASetupViewController.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASetupViewController.h"
#import "CAChangeLanguageViewController.h"
#import "CAMineTableViewCell.h"
#import "CAUser.h"
#import "CAUpdatePasswordViewController.h"
#import "CAEditLegalNicknameViewController.h"
#import "CAAboutUsViewController.h"
#import "CAFundPasswordViewController.h"
#import "CAFeedbackViewController.h"

@interface CASetupViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) UIButton * logoutBtn;

//
@end

@implementation CASetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.tableView reloadData];
}

-(NSArray *)dataArray{

    return @[@{
        @"logoImage":@"changeLanguageImage",
        @"text":@"切换语言",
        },
    @{
        @"logoImage":@"changeSecretImage",
        @"text":@"修改登录密码",
        },
             @{
             @"logoImage":@"passwordimage",
             @"text":@"资金密码",
             },
    @{
        @"logoImage":@"editNikeName",
        @"text":@"编辑法币交易昵称",
        },
             @{
             @"logoImage":@"appversion",
             @"text":@"APP版本",
             },
             @{
             @"logoImage":@"feedback",
             @"text":@"意见反馈",
             },
             
             
    @{
        @"logoImage":@"aboutus",
        @"text":@"关于我们",
        }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navcTitle = @"设置";
    if (self.tableView) {
        [self.tableView reloadData];
    }
    self.logoutBtn.hidden = ![CAUser currentUser].isAvaliable;
    [self.logoutBtn setTitle:CALanguages(@"退出登录") forState:UIControlStateNormal];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row<self.dataArray.count&&indexPath.section==0) {
        
        CAMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAMineTableViewCell"];
        cell.imageV.image = IMAGE_NAMED(self.dataArray[indexPath.row][@"logoImage"]);
        cell.textLab.text = CALanguages(self.dataArray[indexPath.row][@"text"]);
        cell.textLab.font = FONT_REGULAR_SIZE(16);
        cell.textLab.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        if (indexPath.row<=5&&indexPath.row>0) {
            if (![CAUser currentUser].isAvaliable) {
                
                CAloginViewController * login = [[CAloginViewController alloc] init];
                [self.navigationController pushViewController:login animated:YES];
                return;
            }
        }
        
        if (indexPath.row==0) {
            CAChangeLanguageViewController * chang = [CAChangeLanguageViewController new];
            [self.navigationController pushViewController:chang animated:YES];
        }else if (indexPath.row==1){
            CAUpdatePasswordViewController * update = [CAUpdatePasswordViewController new];
            [self.navigationController pushViewController:update animated:YES];
        }else if (indexPath.row==2){
            CAFundPasswordViewController * nikename = [CAFundPasswordViewController new];
            [self.navigationController pushViewController:nikename animated:YES];
        }else if (indexPath.row==3){
            CAEditLegalNicknameViewController * nikename = [CAEditLegalNicknameViewController new];
            [self.navigationController pushViewController:nikename animated:YES];
        }else if (indexPath.row==4){
            CAAboutUsViewController * about = [CAAboutUsViewController new];
            [self.navigationController pushViewController:about animated:YES];
        }else if (indexPath.row==5){
             CAFeedbackViewController * about = [CAFeedbackViewController new];
            [self.navigationController pushViewController:about animated:YES];
        }else if (indexPath.row==6){
            NSString * about_us_url = [CommonMethod readFromUserDefaults:ABOUT_US_URL];
            if (about_us_url.length) {
                CAWebViewController * web = [CAWebViewController new];
                web.webUrl = about_us_url;
                web.appointTitle = @"关于我们";
                [self.navigationController pushViewController:web animated:YES];
            }
        }
        
    }
   
}

-(void)signOutAction{
    
    
    [SVProgressHUD show];
    
    [CANetworkHelper POST:CAAPI_MEMBERS_SIGN_OUT parameters:nil success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [[CAUser currentUser] signOutCurrentUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:CAUserDidSignOutSuccessNotifacation object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 60, 0));
        }];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.dk_separatorColorPicker = DKColorPickerWithKey(LineColor);
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:NSClassFromString(@"CAMineTableViewCell") forCellReuseIdentifier:@"CAMineTableViewCell"];
        [_tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
        
    }
    return _tableView;
}

-(UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_logoutBtn];
        
        _logoutBtn.titleLabel.font = FONT_MEDIUM_SIZE(16);
        [_logoutBtn setTitleColor:HexRGB(0xf8fbff) forState:UIControlStateNormal];
        _logoutBtn.backgroundColor = RGB(0, 108, 219);
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 2;
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-(15+SafeAreaBottomHeight));
            make.height.equalTo(@45);
        }];
        
        [_logoutBtn addTarget:self action:@selector(signOutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}

@end
