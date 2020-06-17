//
//  CAOrderViewController.m
//  TASE-IOS
//
//   10/15.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAOrderViewController.h"
#import "CAOrderTopView.h"
#import "CAOrderBottomView.h"
#import "CAChatView.h"
#import "CAOrderInfoModel.h"
#import "CAAlertInsureView.h"
#import "CAAppealViewController.h"
#import "CAMessageModel.h"
#import "CAOrderinfoCell.h"
#import "CAChoosePayTypeView.h"
#import "CAOrderInfoCurrencyTableViewCell.h"
#import "CAOrderInfoCellModel.h"
#import "CAPayInfoPopView.h"

@interface CAOrderViewController ()
<UITableViewDelegate,
UITableViewDataSource,
CAChoosePayTypeViewDelegate>
{
    CALogalOrderState _currentState;
    NSString * _payTypeString;
    
    NSDictionary * _payment_methods;
}

@property (nonatomic, copy) NSString* payType;
@property (nonatomic, strong) NSDictionary *payDictionary;

@property (nonatomic, strong) CAOrderTopView * topView;
@property (nonatomic, strong) CAOrderBottomView * bottomView;
@property (nonatomic, strong) CAChatView * chatView;
@property (nonatomic, strong) CAOrderInfoModel * orderInfoModel;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * detailLists;
@property (nonatomic, strong) NSArray * payLists;

@property (nonatomic, strong) CAChoosePayTypeView * payView;
@property (nonatomic, strong) UILabel * payNotiLabel;
@property (nonatomic, strong) UIView * payContentView;

@property (nonatomic, strong) UIImageView * bgImageView;

@end

@implementation CAOrderViewController

#pragma ==================================================

-(NSMutableArray *)detailLists{
    if (!_detailLists) {
        _detailLists = @[].mutableCopy;
    }
    return _detailLists;
}

-(CAChoosePayTypeView *)payView{
    if (!_payView) {
        _payView = [CAChoosePayTypeView new];
        _payView.delegata = self;
        _payView.canMultipleSelection = NO;
        _payView.isMustOnlyOneSelected = YES;
    }
    return _payView;
}

-(UILabel *)payNotiLabel{
    if (!_payNotiLabel) {
        _payNotiLabel = [UILabel new];
        _payNotiLabel.font = FONT_REGULAR_SIZE(13);
        _payNotiLabel.numberOfLines = 0;
    }
    return _payNotiLabel;
}

-(UIView *)payContentView{
    if (!_payContentView) {
        _payContentView = [UIView new];
        
        [_payContentView addSubview:self.payNotiLabel];
        [self.payNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payContentView).offset(15);
            make.right.equalTo(_payContentView).offset(-15);
            make.top.equalTo(_payContentView).offset(10);
        }];
        
        [_payContentView addSubview:self.payView];
        [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payContentView).offset(15);
            make.right.equalTo(_payContentView).offset(-15);
            make.top.equalTo(self.payNotiLabel.mas_bottom);
            make.height.equalTo(@50);
        }];
        
    }
    return _payContentView;
}

-(void)setPayNotiLabelText{
    
    if (_payTypeString.length&&[CAUser currentUser].real_name.length) {
        NSString * langStr = CALanguages(@"请使用本人((%@))[%@]向以下账户自行转账");
        NSString * member_real_name = [CAUser currentUser].real_name;

        NSRange rang1 = [langStr rangeOfString:@"(%@)"];
        if (rang1.location!=NSNotFound) {
            langStr = [langStr stringByReplacingCharactersInRange:rang1 withString:member_real_name];
            NSRange rang2 = [langStr rangeOfString:@"[%@]"];
            if (rang2.location!=NSNotFound) {
                langStr = [langStr stringByReplacingCharactersInRange:rang2 withString:_payTypeString];
                self.payNotiLabel.text = langStr;
            }
        }
    }
}

-(void)CAChoosePayTypeView_didSelected:(NSString *)payType{
  
    self.payType = payType;
  
    CAOrderInfoCellModel * model1 = [CAOrderInfoCellModel new];
    CAOrderInfoCellModel * model2 = [CAOrderInfoCellModel new];
    CAOrderInfoCellModel * model3 = [CAOrderInfoCellModel new];
    model1.enableCopy = YES;
    model3.enableCopy = YES;
    
    if ([payType isEqualToString: CAPayAli]) {
        _payTypeString = CALanguages(@"支付宝");
        
        self.payDictionary = _payment_methods[@"alipay"];
        
        model1.leftTitle = @"收款人";
        model2.leftTitle = @"收款二维码";
        model3.leftTitle = @"收款手机号";

        model1.rightContentText = _payment_methods[@"alipay"][@"alipay_real_name"];
        model2.rightContentImage = IMAGE_NAMED(@"qrcode_icon");
        model3.rightContentText = _payment_methods[@"alipay"][@"alipay_account"];
       
        
    }else if ([payType isEqualToString:CAPayWechat]){
         _payTypeString = CALanguages(@"微信");
        
        self.payDictionary = _payment_methods[@"wechat"];
        
        model1.leftTitle = @"收款人";
        model2.leftTitle = @"收款二维码";
        model3.leftTitle = @"收款手机号";

        model1.rightContentText = _payment_methods[@"wechat"][@"wechat_real_name"];
        model2.rightContentImage = IMAGE_NAMED(@"qrcode_icon");
        model3.rightContentText = _payment_methods[@"wechat"][@"wechat_account"];
     
    }else if ([payType isEqualToString:CAPayBank]){
         _payTypeString = CALanguages(@"银行卡");
        
        self.payDictionary = _payment_methods[@"bank"];
       
        model1.leftTitle = @"收款人";
        model2.leftTitle = @"收款银行";
        model3.leftTitle = @"银行卡号";

        model1.rightContentText = _payment_methods[@"bank"][@"bank_account_username"];
        model2.rightContentText = _payment_methods[@"bank"][@"bank_name"];
        model3.rightContentText = _payment_methods[@"bank"][@"bank_account_number"];
        
        model2.enableCopy = YES;
    }
    
    self.payLists = @[model1,model2,model3];
    [self setPayNotiLabelText];
    
    [self.tableView reloadData];
}


-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        [self.view addSubview:_bgImageView];
        _bgImageView.image = IMAGE_NAMED(@"background");
    }
    return _bgImageView;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight-60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[CAOrderinfoCell class] forCellReuseIdentifier:@"CAOrderinfoCell"];
        [_tableView registerClass:[CAOrderInfoCurrencyTableViewCell class] forCellReuseIdentifier:@"CAOrderInfoCurrencyTableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.frame = _tableView.bounds;
        layer.path = maskPath.CGPath;
        _tableView.layer.mask = layer;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.orderInfoModel.hasContent) {
        return 3;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1) {
        if (self.orderInfoModel.is_showPaymethod) {
            return self.payLists.count;
        }
    }else if(section==2){
        
        return self.detailLists.count;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = HexRGB(0xefefef);
    
    return lineView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ((section==1&&self.orderInfoModel.is_showPaymethod)||section==0) {
        return 10;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==1&&self.orderInfoModel.is_showPaymethod) {
        return self.payContentView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1&&self.orderInfoModel.is_showPaymethod) {
        return 80;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 120;
    }
    
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        CAOrderInfoCurrencyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAOrderInfoCurrencyTableViewCell" forIndexPath:indexPath];
        cell.orderInfoModel = self.orderInfoModel;
        return cell;
    }else if (indexPath.section==1){
        
        CAOrderinfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAOrderinfoCell" forIndexPath:indexPath];
        if (indexPath.row<self.payLists.count) {
            CAOrderInfoCellModel * model = self.payLists[indexPath.row];
            cell.leftTitle = model.leftTitle;
            if (model.rightContentImage) {
                cell.rightContentImage = model.rightContentImage;
            }else{
                cell.rightContentText = model.rightContentText;
            }
            cell.enableCopy = model.enableCopy;
            
            kWeakSelf(self);
            cell.block = ^(){
              
                CAPayInfoPopView *popView = [CAPayInfoPopView new];
                popView.payDictionay = weakself.payDictionary;
                popView.payType = weakself.payType;
                [popView show];
                
            };
        }
        
        return cell;
        
    }else if (indexPath.section==2){
        
        CAOrderinfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAOrderinfoCell" forIndexPath:indexPath];
        if (self.detailLists.count>indexPath.row) {
            CAOrderInfoCellModel * model = self.detailLists[indexPath.row];
            cell.leftTitle = model.leftTitle;
            cell.rightContentText = model.rightContentText;
            cell.enableCopy = model.enableCopy;
        }
        
        return cell;
    }
    
    return nil;
}


-(void)dealDetailsData{
    
    NSMutableArray * mutArray = @[].mutableCopy;
    //昵称
    [mutArray addObject:[CAOrderInfoCellModel modelWithleftTitle:self.orderInfoModel.notiShowNikeName rightContent:self.orderInfoModel.showNickName showRow:NO enableCopy:NO]];
    //实名
    [mutArray addObject:[CAOrderInfoCellModel modelWithleftTitle:self.orderInfoModel.notiShowRealName rightContent:self.orderInfoModel.showRealName showRow:NO enableCopy:NO]];
    //订单号
    [mutArray addObject:[CAOrderInfoCellModel modelWithleftTitle:@"订单号" rightContent:self.orderInfoModel.sn showRow:NO enableCopy:YES]];
    //订单时间
    [mutArray addObject:[CAOrderInfoCellModel modelWithleftTitle:@"订单时间" rightContent:self.orderInfoModel.created_at showRow:NO enableCopy:NO]];

    if (self.orderInfoModel.payment.length) {
        [mutArray addObject:[CAOrderInfoCellModel modelWithleftTitle:_orderInfoModel.notiPay rightContent:self.orderInfoModel.payment showRow:NO enableCopy:NO]];
    }
    if (self.orderInfoModel.dispute_status.length) {
        [mutArray addObject:[CAOrderInfoCellModel modelWithleftTitle:@"申诉进度" rightContent:self.orderInfoModel.dispute_status showRow:NO enableCopy:NO]];
    }
    
    [self.detailLists removeAllObjects];
    [self.detailLists addObjectsFromArray:mutArray];
    
}

#pragma ==================================================


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [self getData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    if (self.chatView) {
        [self.chatView unSubscribeChat];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [SVProgressHUD dismiss];
}

-(void)dealloc{
    if (_chatView) {
        [_chatView removeObserver:self forKeyPath:@"unreadMessagesCount"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.backTineColor = [UIColor whiteColor];
    self.titleColor = [UIColor whiteColor];
    if ([[CASkinManager getCurrentSkinType] isEqualToString:DKThemeVersionNormal]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderInfoModel = [CAOrderInfoModel new];
    [SVProgressHUD show];
    [self.chatView getMessage];
    [self creatUI];
}

-(void)creatUI{
    
    [self.view bringSubviewToFront:self.navcBar];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(MainWidth*0.8));
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navcBar.mas_bottom).offset(0);
        make.height.equalTo(@75);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(60+SafeAreaBottomHeight/2.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.bottomView];
}

-(void)getData{
    
    NSDictionary * para = @{
        @"id":NSStringFormat(@"%@",self.advertisement_id)
    };
    [CANetworkHelper closeLog];
    [CANetworkHelper GET:CAAPI_OTC_SHOW_TRADING parameters:para success:^(id responseObject) {
        //刷新数据
//        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] integerValue]==20000) {
                
                [self.orderInfoModel initWithDictionary:responseObject[@"data"]];
                self.chatView.orderInfoModel = self.orderInfoModel;
                
                if (self->_currentState!=self.orderInfoModel.order_state) {
                    self->_currentState = self.orderInfoModel.order_state;
                    self.topView.orderInfoModel = self.orderInfoModel;
                    self.bottomView.orderInfoModel = self.orderInfoModel;
                }
                
                if (!self->_payment_methods) {
                    self->_payment_methods = self.orderInfoModel.payment_methods;
                    self.payView.supportPayMethodArray = self.orderInfoModel.supportPayMethods;
//                    NSLog(@"%@",self.orderInfoModel.supportPayMethods);
                }
                
                
                [self freshTableView];
            
                if (self.orderInfoModel.order_state==CAOrderStateWaitingPay||self.orderInfoModel.order_state==CAOrderStateHasExpendTime||self.orderInfoModel.order_state==CAOrderStateWaitingCoinRelease) {

                    [self performSelector:@selector(getData) withObject:nil afterDelay:5];
                }
            }
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)freshTableView{
    
    if (self.orderInfoModel.actionButtons.count) {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(60+SafeAreaBottomHeight/2.f));
        }];
    }else{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    }
    
    [self dealDetailsData];
    
    [self.tableView reloadData];
}

-(CAChatView *)chatView{
    if (!_chatView) {
        _chatView = [[CAChatView alloc] initWithFrame:CGRectMake(0, kTopHeight, MainWidth, MainHeight-kTopHeight)];
        _chatView.viewController = self;
        _chatView.ID = self.advertisement_id;
        [_chatView addObserver:self forKeyPath:@"unreadMessagesCount" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _chatView;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"unreadMessagesCount"]) {
        self.topView.unreadMessagesCount = self.chatView.unreadMessagesCount;
    }
}

-(void)showChatView{
    
    [self.chatView showInView:self.navigationController.view isAnimation:YES direaction:CABaseAnimationDirectionFromBottom];
}


-(CAOrderBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [CAOrderBottomView new];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(CAOrderTopView *)topView{
    if (!_topView) {
        _topView = [CAOrderTopView new];
        [self.view addSubview:_topView];
    }
    return _topView;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    if ([eventName isEqualToString:@"order_action"]) {

        switch ([userInfo integerValue]) {
            case CALogalOrderActionCancle:{
                [[CAAlertInsureView new] showAlert:@"" title:@"确认取消交易" subTitle:@"如果您已经向卖家付款，请千万不要取消交易" notiTitle:@"取消规则：当日累计取消法币订单超过3次,会限制当日法币交易功能" confirmBlock:^(id idex){
                    
                    [self dealActionRequest_cancle];
                } cancleBlock:^{
                    
                }];
              }
            break;
            case CALogalOrderActionHasPaied:
            {
                [[CAAlertInsureView new] showAlertTitle:@"付款确认" subTitle:@"请选择您的支付方式" importPayMethods:self.orderInfoModel.supportPayMethods confirmBlock:^(NSString * payMethod) {
                    [self dealActionRequest_hasPaied:payMethod];
                } cancleBlock:^{
                    
                }];
            }
                
            break;
            case CALogalOrderActionExpendTime:
                {
                    [[CAAlertInsureView new] showAlert:@"" title:@"是否延长时间" subTitle:@"将延长15分钟时间" notiTitle:@"" confirmBlock:^(id idex){
                         [self dealActionRequest_expendTime];
                    } cancleBlock:^{
                        
                    }];
                }
               
            break;
            case CALogalOrderActionReleaseCoin:
                {
                   [[CAAlertInsureView new] showAlert:@"" title:@"确认放行" subTitle:@"请务必登录网上银行或第三方支付账号确认收到该笔款项" notiTitle:@"" confirmBlock:^(id idex){
                        [self dealActionRequest_releaseCoin];
                   } cancleBlock:^{
                       
                   }];
                 }
                 
            break;
                
            default:
                break;
        }
    }
    else if ([eventName isEqualToString:@"showChatView"]){
        [self showChatView];
    }else if ([eventName isEqualToString:@"showAppealView"]){
        if (NSStringFormat(@"%@",self.orderInfoModel.ID).length) {
            CAAppealViewController * appeal = [CAAppealViewController new];
            appeal.infoModel = self.orderInfoModel;
            appeal.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController presentViewController:appeal animated:YES completion:nil];
        }
    }
}

//取消订单
-(void)dealActionRequest_cancle{
    
    [SVProgressHUD show];
   
    NSDictionary * para = @{
        @"id":NSStringFormat(@"%@",self.orderInfoModel.ID)
    };
    [CANetworkHelper POST:CAAPI_OTC_CANCLE_TRADING parameters:para success:^(id responseObject) {
        //刷新数据
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] integerValue]==20000) {
                [self getData];
            }else{
                Toast(responseObject[@"message"]);
            }
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
//我已成功付款
-(void)dealActionRequest_hasPaied:(NSString*)payMethod{
    
      [SVProgressHUD show];
      
       NSDictionary * para = @{
           @"id":NSStringFormat(@"%@",self.orderInfoModel.ID),
           @"mode_of_payment":NSStringFormat(@"%@",payMethod)
       };
       [CANetworkHelper POST:CAAPI_OTC_MARK_BUYER_HAS_PAID parameters:para success:^(id responseObject) {
           //刷新数据
           [SVProgressHUD dismiss];
           dispatch_async(dispatch_get_main_queue(), ^{
               if ([responseObject[@"code"] integerValue]==20000) {
                   [self getData];
               }else{
                   Toast(responseObject[@"message"]);
               }
           });
       } failure:^(NSError *error) {
           [SVProgressHUD dismiss];
       }];
}
//延长付款时间
-(void)dealActionRequest_expendTime{
    
    [SVProgressHUD show];
    
     NSDictionary * para = @{
         @"id":NSStringFormat(@"%@",self.orderInfoModel.ID)
     };
     [CANetworkHelper POST:CAAPI_OTC_MARK_TRADING_OVERTIME parameters:para success:^(id responseObject) {
         //刷新数据
         [SVProgressHUD dismiss];
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([responseObject[@"code"] integerValue]==20000) {
                 [self getData];
             }else{
                 Toast(responseObject[@"message"]);
             }
         });
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}
//放币
-(void)dealActionRequest_releaseCoin{
    [SVProgressHUD show];
    
     NSDictionary * para = @{
         @"id":NSStringFormat(@"%@",self.orderInfoModel.ID)
     };
     [CANetworkHelper POST:CAAPI_OTC_SELLER_HAS_RELEASED parameters:para success:^(id responseObject) {
         //刷新数据
         [SVProgressHUD dismiss];
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([responseObject[@"code"] integerValue]==20000) {
                 [self getData];
             }else{
                 Toast(responseObject[@"message"]);
             }
         });
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}


@end
