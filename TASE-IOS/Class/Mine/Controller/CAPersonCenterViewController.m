//
//  CAPersonCenterViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPersonCenterViewController.h"
#import "CAPersonCenterTableViewCell.h"
#import "CAPersonCenterTipsTableViewCell.h"
#import "CARealNameAuthViewController.h"
#import "FaceidViewController.h"
@interface CAPersonCenterViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) CAUser * user;

@end

@implementation CAPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD show];
    
    self.bigNavcTitle = CALanguages(@"个人中心");
    
    self.user = [CAUser currentUser];
 
    [self initTableView];
    
    [self getData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.tableView) {
        [self getData];
    }
}

-(void)getData{
    
    [self.user getUserDetails:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

-(void)initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HexRGB(0xf6f6fa);
    [self.tableView registerClass:[CAPersonCenterTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CAPersonCenterTableViewCell class])];
    [self.tableView registerClass:[CAPersonCenterTipsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CAPersonCenterTipsTableViewCell class])];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.bigTitleLabel.mas_bottom);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if (self.user.is_identified_success) {
         return 40;
     }
     return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView * bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, MainWidth, 0);

    UIView * lineViewTop = [UIView new];
    [bgView addSubview:lineViewTop];
    lineViewTop.backgroundColor = HexRGB(0xf6f6fa);
    [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.equalTo(bgView);
       make.height.equalTo(@10);
    }];
   
    
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
     [bgView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.top.equalTo(lineViewTop.mas_bottom);
    }];
    
    UIView * lineView = [UIView new];
    [view addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.font = FONT_MEDIUM_SIZE(14);
    titleLabel.textColor = HexRGB(0x191d26);
    [view addSubview:titleLabel];
    titleLabel.text =CALanguages(@"身份认证") ;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.width.equalTo(view).multipliedBy(0.4);
        make.centerY.equalTo(view);
    }];
    
    UILabel * stateLabel = [UILabel new];
    [view addSubview:stateLabel];
    stateLabel.font = FONT_REGULAR_SIZE(14);
    [stateLabel setAdjustsFontSizeToFitWidth:YES];
    stateLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView * stateImageView = [UIImageView new];
    [view addSubview:stateImageView];
    stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    stateLabel.text = self.user.identity_state_name;
    
    
     if ([self.user.identity_state isEqualToString:@"not_audit"]||[self.user.identity_state isEqualToString:@"audit_failure"]) {
         
         stateImageView.image = IMAGE_NAMED(@"arrowright");
         [stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(view).offset(-20);
             make.centerY.equalTo(view);
             make.width.height.equalTo(@10);
         }];
         [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(stateImageView.mas_left).offset(-5);
             make.centerY.equalTo(stateImageView);
         }];
         view.userInteractionEnabled = YES;
         [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ToJumpIdentify)]];
         
     }else if ([self.user.identity_state isEqualToString:@"authentication_successful"]){
         
         stateLabel.textColor = HexRGB(0x006cdb);
         stateImageView.image = IMAGE_NAMED(@"pass");
         [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(view).offset(-20);
             make.centerY.equalTo(view);
         }];
         [stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(stateLabel.mas_left).offset(-5);
             make.centerY.equalTo(stateLabel);
             make.width.height.equalTo(@14);
         }];
     }else{
         [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(view).offset(-20);
             make.centerY.equalTo(view);
         }];
     }
    
    CGSize size = [stateLabel sizeThatFits:CGSizeMake(MainWidth*0.6, 30)];
    if (size.width>MainWidth/2.f) {
        size.width = MainWidth/2.f;
    }
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, MainWidth, 0);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.user.is_identified_success) {
            return 5;
        }
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.user.is_identified_success) {
        CAPersonCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CAPersonCenterTableViewCell class])];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.leftNotiLabel.text = CALanguages(@"姓名") ;
                cell.rightContentLabel.text = NSStringFormat(@"%@",self.user.real_name);
            }
                break;
            case 1:
            {
                cell.leftNotiLabel.text = CALanguages(@"账号");
                cell.rightContentLabel.text = NSStringFormat(@"%@",self.user.account);
            }
                break;
            case 2:
            {
                cell.leftNotiLabel.text = @"UID";
                cell.rightContentLabel.text = NSStringFormat(@"%@",self.user.uid);
            }
                break;
            case 3:
            {
                cell.leftNotiLabel.text = CALanguages(@"国家地区");
                cell.rightContentLabel.text = NSStringFormat(@"%@",self.user.country);
            }
                break;
            case 4:
            {
                cell.leftNotiLabel.text = CALanguages(@"证件号码");
                cell.rightContentLabel.text = NSStringFormat(@"%@",self.user.id_card_number);
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }else{
        CAPersonCenterTipsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CAPersonCenterTipsTableViewCell class])];
        cell.contentString = CALanguages(@"认证后可进行法币交易");
        return cell;
    }
    
    return nil;
}


-(void)ToJumpIdentify{
    
    FaceidViewController * real = [FaceidViewController new];
    [self.navigationController pushViewController:real animated:YES];
}

@end
