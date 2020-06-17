//
//  CAMineView.m
//  TASE-IOS
//
//   9/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMineView.h"
#import "CAMineTableViewCell.h"
#import "CAMineHeaderView.h"

@interface CAMineView ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) CAMineHeaderView * headView;

@property (nonatomic, strong) UIView * bottomView;

@end

@implementation CAMineView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteBackGroundColor);
        
        self.tableView.tableHeaderView = self.headView;
       
        [self.tableView reloadData];
        
        [self initBottomView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];
        
        UIPanGestureRecognizer * longPress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longGestAction:)];
        
        [self.shadowView addGestureRecognizer:longPress];

    }
    return self;
}

-(void)longGestAction:(UIPanGestureRecognizer*)longPressGesture{
    
    
    CGPoint point = [longPressGesture locationInView:self.shadowView];
    CGRect rect = self.frame;
    CGFloat movex = point.x-rect.size.width;

    if (longPressGesture.state==UIGestureRecognizerStateEnded) {
        if (movex<0) {
            if (movex>-rect.size.width/3.f) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.frame = self.originReact;
                }];
            }else{
                [self hide:YES];
            }
        }
    }else if (longPressGesture.state==UIGestureRecognizerStateChanged){
        if (movex<0&&movex>-rect.size.width) {
            rect.origin.x = movex;
            self.frame = rect;
        }
    }else if (longPressGesture.state==UIGestureRecognizerStateFailed){
        NSLog(@"失败了");
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)languageDidChange{
    
    [self.tableView reloadData];
    [self.headView languageDidChange];
    [self initBottomView];
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [self addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-SafeAreaBottomHeight);
            make.height.equalTo(@48);
        }];
        
    }
    return _bottomView;
}

-(void)initBottomView{
    
    [self.bottomView removeAllSubViews];
    
    UIView * lineViewTop = [UIView new];
    [self.bottomView addSubview:lineViewTop];
    lineViewTop.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.bottomView);
    }];
    
    
    UIView * lineViewH = [UIView new];
    [self.bottomView addSubview:lineViewH];
    lineViewH.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineViewH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(@0.5);
    }];
    
    UIView * leftView = [self creatView:@"联系我们" image:@"mine_contact_service"];
    [self.bottomView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.bottomView);
        make.right.equalTo(lineViewH.mas_left);
    }];
    
    UIView * rightView = [self creatView:@"分享应用" image:@"mine_share_app"];
    [self.bottomView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.bottomView);
        make.left.equalTo(lineViewH.mas_right);
    }];
    
    [rightView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareAppClick)]];
    [leftView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactUsClick)]];

}

-(void)contactUsClick{
    [self.delegata contactUsClick];
}

-(void)shareAppClick{
    
    [self.delegata shareApp];
}

-(UIView*)creatView:(NSString*)title image:(NSString*)imageUrl{
    
    UIView * contentView = [UIView new];
    
    UIView * view = [UIView new];
    [contentView addSubview:view];
    view.userInteractionEnabled = NO;
    
    UIImageView * imageV = [UIImageView new];
    [view addSubview:imageV];
    imageV.image = IMAGE_NAMED(imageUrl);
    
    UILabel * label = [UILabel new];
    [view addSubview:label];
    label.text = CALanguages(title);
    label.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    label.font = FONT_REGULAR_SIZE(14);
    label.adjustsFontSizeToFitWidth = YES;
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.left.equalTo(view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(9);
        make.centerY.equalTo(imageV);
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(contentView);
        make.height.equalTo(@21);
        make.right.equalTo(label.mas_right);
    }];
    
    return contentView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CAMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CAMineTableViewCell"];
    
    cell.data = self.dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<self.dataArray.count) {
        
        NSDictionary * dic = self.dataArray[indexPath.row];
        if (dic[@"controller"]) {
            
            if ([dic[@"isNeesLogin"] boolValue]&&![CAUser currentUser].isAvaliable) {
                if (self.delegata&&[self.delegata respondsToSelector:@selector(gotoLoginController)]) {
                    [self.delegata gotoLoginController];
                }
            }else{
                UIViewController * controller = [[NSClassFromString(dic[@"controller"]) alloc] init];
                if (self.delegata&&[self.delegata respondsToSelector:@selector(cellDidSelected:)]) {
                    [self.delegata cellDidSelected:controller];
                }
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        UIView *foot=  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
       
        _tableView.tableFooterView = foot;
        _tableView.showsVerticalScrollIndicator = NO;
              
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, SafeAreaBottomHeight+48, 0));
        }];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CAMineTableViewCell class] forCellReuseIdentifier:@"CAMineTableViewCell"];
        _tableView.backgroundColor = [UIColor clearColor];
        
    }
    return _tableView;
}

#pragma mark 头部代理事件

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    if ([eventName isEqualToString:@"pushViewController"]) {
    
        if ([CAUser currentUser].isAvaliable) {
            UIViewController * contro = [[NSClassFromString(userInfo) alloc] init];
            if (self.delegata&&[self.delegata respondsToSelector:@selector(cellDidSelected:)]) {
                [self.delegata cellDidSelected:contro];
            }
        }else{
            if (self.delegata&&[self.delegata respondsToSelector:@selector(gotoLoginController)]) {
                [self.delegata gotoLoginController];
            }
        }
    }
}

-(void)didSelectedController:(NSString *)controller{
        
    UIViewController * contro = [[NSClassFromString(controller) alloc] init];
    if (self.delegata&&[self.delegata respondsToSelector:@selector(cellDidSelected:)]) {
        [self.delegata cellDidSelected:contro];
    }
}

-(CAMineHeaderView *)headView{
    if (!_headView) {
        _headView = [[CAMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),200+kStatusBarHeight)];
    }
    return _headView;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[
            @{@"image":@"wallet",@"text":@"我的资产",@"controller":@"CAMoneyViewController",@"isNeesLogin":@(YES)},
                       @{@"image":@"Receivables",@"text":@"收款方式",@"controller":@"CApaymentMethodViewController",@"isNeesLogin":@(YES)},
            @{@"image":@"ID",@"text":@"实名认证",@"controller":@"FaceidViewController",@"isNeesLogin":@(YES)},

                       @{@"image":@"Mobile phone",@"text":@"绑定手机",@"controller":@"CABindPhoneViewController",@"isNeesLogin":@(YES)},
                       @{@"image":@"Mailbox",@"text":@"邮箱设置",@"controller":@"CAEmailViewController",@"isNeesLogin":@(YES)},
  
//  @{@"image":@"passwordimage",@"text":@"资金密码",@"controller":@"CAFundPasswordViewController",@"isNeesLogin":@(YES)},CAFeedBackViewController
//                       @{@"image":@"gift",@"text":@"邀请码",@"controller":@"CAInviteFriendViewController",@"isNeesLogin":@(YES)},
//                       @{@"image":@"friends",@"text":@"我的好友",@"controller":@"CAMyFriendListViewController",@"isNeesLogin":@(YES)},
                       
                       @{@"image":@"Setup",@"text":@"设置",@"controller":@"CASetupViewController",@"isNeesLogin":@(NO)},
                       ];
    }
    return _dataArray;
}


@end
