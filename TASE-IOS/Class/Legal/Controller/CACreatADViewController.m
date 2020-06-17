//
//  CACreatADViewController.m
//  TASE-IOS
//
//   10/22.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CACreatADViewController.h"
#import "CAChoosePayTypeView.h"
#import "CACurrencyModel.h"
#import "CAInputView.h"
#import "CAAlertView.h"
#import "CApaymentMethodViewController.h"

@interface CACreatADViewController ()
<CAChoosePayTypeViewDelegate>
{
    NSInteger _adTypeIndex;
    NSInteger _currencyIndex;
    NSInteger _legalIndex;
    
}

@property (nonatomic, strong) UIView * whiteContentView;

@property (nonatomic, strong) UIButton * adTypeButton;
@property (nonatomic, strong) UIButton * currencyButton;
@property (nonatomic, strong) UIButton * legalButton;

@property (nonatomic, strong) CABaseButton * creatButton;
@property (nonatomic, strong) CABaseButton * cancledButton;

@property (nonatomic, strong) CAChoosePayTypeView * payView;

@property (nonatomic, strong) CAInputView * unitPriceInputView;
@property (nonatomic, strong) CAInputView * minPriceInputView;
@property (nonatomic, strong) CAInputView * maxPriceInputView;
@property (nonatomic, strong) CAInputView * numberInputView;

@property (nonatomic, strong) NSArray * adTypeArray;
@property (nonatomic, strong) NSArray * currencyArray;
@property (nonatomic, strong) NSArray * legalTypeArray;

@end

@implementation CACreatADViewController

-(NSArray *)adTypeArray{
    return @[CALanguages(@"购买"),CALanguages(@"卖出")];
}
-(NSArray *)currencyArray{
    if (!_currencyArray) {
        NSArray * array = [CACurrencyModel getModelsByKey:@"otc_currencies"];
       _currencyArray = [CACurrencyModel getCodeBigArray:array];
    }
    return _currencyArray;
}
-(NSArray *)legalTypeArray{
    return @[@"CNY"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _adTypeIndex = 0;
     _currencyIndex = 0;
     _legalIndex = 0;
    
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    self.backTineColor = [UIColor whiteColor];
    self.backGroungImageView.hidden = NO;

    if (self.model&&self.model.ID.length) {
        self.navcTitle = @"编辑广告";
        [self edit_advertisement];
    }else{
        self.navcTitle = @"创建广告";
        self.model = [CAAdvertisementModel new];
    }

    [self initSubViews];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.payView.supportPayMethodArray = @[];
    [self getBindedPayments];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


-(void)getBindedPayments{
    [SVProgressHUD show];
    [CANetworkHelper GET:CAAPI_MINE_SHOW_PAYMENT_METHODS_PAGE parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSMutableArray * enablePayments = @[].mutableCopy;
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * dic = responseObject[@"data"];
            for (NSString * key in dic.allKeys) {
                NSDictionary * pay = [dic objectForKey:key];
                if (pay&&[pay[@"is_binded"] boolValue]) {
                    if ([key isEqualToString:@"alipay"]) {
                        [enablePayments addObject:CAPayAli];
                    }else if ([key isEqualToString:@"wechat"]){
                        [enablePayments addObject:CAPayWechat];
                    }else if ([key isEqualToString:@"bank_card"]){
                        [enablePayments addObject:CAPayBank];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (enablePayments.count) {
                self.payView.supportPayMethodArray = enablePayments;
                [self updateUI];
                
            }else{
                [CAAlertView showAlertWithTitle:CALanguages(@"您还未添加任何收款方式") message:@"" completionBlock:^(NSUInteger buttonIndex, CAAlertView * _Nonnull alertView) {
                    if (buttonIndex==0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        CApaymentMethodViewController * method = [CApaymentMethodViewController new];
                        [self.navigationController pushViewController:method animated:YES];
                    }
                } cancelButtonTitle:CALanguages(@"取消") otherButtonTitles:CALanguages(@"去添加"),nil];
            }
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark 网络请求


-(void)create_advertisement {
    
    NSDictionary * para = @{
        @"code":NSStringFormat(@"%@",[self.model.code lowercaseString]),
        @"trade_type":NSStringFormat(@"%@",self.model.trade_type),
        @"payment_methods":NSStringFormat(@"%@",[self.model stringByLinkWithComma:self.payView.payMethodsArray]),
        @"price":NSStringFormat(@"%@",self.model.unit_price),
        @"min_limit":NSStringFormat(@"%@",self.model.min_limit),
        @"max_limit":NSStringFormat(@"%@",self.model.max_limit),
        @"amount":NSStringFormat(@"%@",self.model.trading_currency_amount),
        @"fiat_type":@"cny"
    };
    [SVProgressHUD show];
    
    [CANetworkHelper POST:CAAPI_OTC_CREATE_ADVERTISEMENT parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)edit_advertisement {

    NSDictionary * para = @{
        @"id":NSStringFormat(@"%@",self.model.ID),
    };
    [SVProgressHUD show];
    
    [CANetworkHelper GET:CAAPI_OTC_EDIT_ADVERTISEMENT parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue]==20000) {
            NSDictionary * advertisement = responseObject[@"data"];
            self.model.code = advertisement[@"currency_code"];
            self.model.unit_price = NSStringFormat(@"%@",advertisement[@"price"]);
            self.model.max_limit = NSStringFormat(@"%@",advertisement[@"max_limit"]);
            self.model.min_limit = NSStringFormat(@"%@",advertisement[@"min_limit"]);
             self.model.trading_currency_amount = NSStringFormat(@"%@",advertisement[@"amount"]);
            self.model.trade_type = advertisement[@"trade_type"];
            self.model.payment_methods = advertisement[@"payment_methods"];
            self.model.is_canceled = [advertisement[@"is_canceled"] boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        }else{
            Toast(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)update_advertisement  {
    

    NSDictionary * para = @{
        @"id":self.model.ID,
        @"code":self.model.code,
        @"trade_type":self.model.trade_type,
        @"payment_methods":[self.model stringByLinkWithComma:self.payView.payMethodsArray],
        @"price":self.model.unit_price,
        @"min_limit":self.model.min_limit,
        @"max_limit":self.model.max_limit,
        @"amount":self.model.trading_currency_amount,
    };

    [SVProgressHUD show];
    
    [CANetworkHelper POST:CAAPI_OTC_UPDATE_ADVERTISEMENT parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)update_advertisement_is_cancelled_status{
    
    NSDictionary * para = @{
        @"id":self.model.ID,
        @"is_canceled":self.model.is_canceled?@"0":@"1"
    };
    [SVProgressHUD show];
    
    
    [CANetworkHelper POST:CAAPI_OTC_UPDATE_ADVERTISEMENT_IS_CANCLLED_STATUS parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            Toast(responseObject[@"message"]);
            if ([responseObject[@"code"] integerValue]==20000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{

    if ([eventName isEqualToString:@"textFieldDidChange"]) {
        if (userInfo[@"item"]==self.unitPriceInputView) {
            self.model.unit_price = userInfo[@"text"];
        }else if (userInfo[@"item"]==self.minPriceInputView){
            self.model.min_limit = userInfo[@"text"];
        }else if (userInfo[@"item"]==self.maxPriceInputView){
            self.model.max_limit = userInfo[@"text"];
        }else if (userInfo[@"item"]==self.numberInputView){
            self.model.trading_currency_amount = userInfo[@"text"];
        }
        
        [self judgeCanSend];
    }
}

-(void)CAChoosePayTypeView_didSelected:(NSString *)payType{
    [self judgeCanSend];
}

-(void)judgeCanSend{
    if (self.model.unit_price.length&&self.model.min_limit.length&&self.model.max_limit&&self.model.trading_currency_amount.length&&self.payView.payMethodsArray.count) {
        self.creatButton.enabled = YES;
    }else{
        self.creatButton.enabled = NO;
    }
}

-(void)updateUI{
    
    if (self.model.ID) {
        
        self.unitPriceInputView.inputView.text = NSStringFormat(@"%@",self.model.unit_price);
        self.minPriceInputView.inputView.text =  NSStringFormat(@"%@",self.model.min_limit);
        self.maxPriceInputView.inputView.text = NSStringFormat(@"%@",self.model.max_limit);
        self.numberInputView.inputView.text =  NSStringFormat(@"%@",self.model.trading_currency_amount);
        
        [self.cancledButton setTitle:CALanguages(self.model.is_canceled?@"上架":@"下架") forState:UIControlStateNormal];
        [self.payView.payMethodsArray removeAllObjects];
        [self.payView.payMethodsArray addObjectsFromArray:self.model.payment_methods];
        [self.payView update];
    }
}

-(void)initSubViews{
    
    NSString * trade_type = self.adTypeArray.firstObject;
    if ([self.model.trade_type isEqualToString:@"sell"]) {
        trade_type = self.adTypeArray.lastObject;
    }else{
        self.model.trade_type = @"buy";
    }
    NSString * currency = self.currencyArray.firstObject;
    if (self.model.code) {
        currency = [self.model.code uppercaseString];
    }else{
        self.model.code = currency;
    }
    
    self.adTypeButton = [self creatTopViewTitle:@"广告类型" rightTitle:trade_type topView:nil tag:1];
    self.currencyButton = [self creatTopViewTitle:@"币种名称" rightTitle:currency topView:self.adTypeButton tag:2];
    self.legalButton = [self creatTopViewTitle:@"法币类型" rightTitle:self.legalTypeArray.firstObject topView:self.currencyButton tag:3];
    
    
    
    [self.whiteContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.legalButton.mas_bottom).offset(25);
    }];

    
    self.whiteContentView.clipsToBounds = NO;

    UILabel * notiLabel = [UILabel new];
    [self.whiteContentView addSubview:notiLabel];
    notiLabel.text = CALanguages(@"支付信息");
    notiLabel.font = FONT_REGULAR_SIZE(15);
    notiLabel.dk_textColorPicker = DKColorPickerWithKey(GrayTextColot_a3a4bd);
    [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.whiteContentView).offset(25);
       make.top.equalTo(self.whiteContentView).offset(25);
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteContentView).offset(25);
        make.right.equalTo(self.whiteContentView).offset(-10);
        make.top.equalTo(notiLabel.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
    
    
    self.unitPriceInputView = [CAInputView showWithType:CAInputViewLeftNotiRightNotiType];
    self.minPriceInputView = [CAInputView showWithType:CAInputViewLeftNotiRightNotiType];
    self.maxPriceInputView = [CAInputView showWithType:CAInputViewLeftNotiRightNotiType];
    self.numberInputView = [CAInputView showWithType:CAInputViewLeftNotiRightNotiType];
    
    [self.whiteContentView addSubview:self.unitPriceInputView];
    [self.whiteContentView addSubview:self.minPriceInputView];
    [self.whiteContentView addSubview:self.maxPriceInputView];
    [self.whiteContentView addSubview:self.numberInputView];
    
    self.unitPriceInputView.notiLabel.text = CALanguages(@"单价") ;
    self.minPriceInputView.notiLabel.text = CALanguages(@"最低限额");
    self.maxPriceInputView.notiLabel.text = CALanguages(@"最高限额");
    self.numberInputView.notiLabel.text = CALanguages(@"交易数量");
    
    self.unitPriceInputView.rightNotiLabel.text = @"CNY";
    self.minPriceInputView.rightNotiLabel.text = @"CNY";
    self.maxPriceInputView.rightNotiLabel.text = @"CNY";
    self.numberInputView.rightNotiLabel.text = currency;
    
    [self setLeftLabelStyle:self.unitPriceInputView.notiLabel rightLabel:self.unitPriceInputView.rightNotiLabel];
    [self setLeftLabelStyle:self.minPriceInputView.notiLabel rightLabel:self.minPriceInputView.rightNotiLabel];
    [self setLeftLabelStyle:self.maxPriceInputView.notiLabel rightLabel:self.maxPriceInputView.rightNotiLabel];
    [self setLeftLabelStyle:self.numberInputView.notiLabel rightLabel:self.numberInputView.rightNotiLabel];
    
    self.unitPriceInputView.inputView.keyboardType = UIKeyboardTypeDecimalPad;
    self.minPriceInputView.inputView.keyboardType = UIKeyboardTypeDecimalPad;
    self.maxPriceInputView.inputView.keyboardType = UIKeyboardTypeDecimalPad;
    self.numberInputView.inputView.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.unitPriceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteContentView).offset(25);
        make.right.equalTo(self.whiteContentView).offset(-25);
        make.top.equalTo(self.payView.mas_bottom).offset(20);
    }];
    [self.minPriceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.unitPriceInputView);
        make.top.equalTo(self.unitPriceInputView.mas_bottom).offset(20);
    }];
    [self.maxPriceInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.unitPriceInputView);
        make.top.equalTo(self.minPriceInputView.mas_bottom).offset(20);
    }];
    [self.numberInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.unitPriceInputView);
        make.top.equalTo(self.maxPriceInputView.mas_bottom).offset(20);
    }];
  
    
    
    if (self.model.ID.length) {
        
        self.creatButton = [self creatSaveButton:@"保存广告信息"];
        [self.creatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteContentView).offset(15);
            make.right.equalTo(self.whiteContentView).offset(-15);
            make.height.equalTo(@44);
            make.top.equalTo(self.numberInputView.mas_bottom).offset(40);
        }];
        
        self.cancledButton = [self creatSaveButton:self.model.is_canceled?@"上架":@"下架"];
        [self.cancledButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteContentView).offset(15);
            make.right.equalTo(self.whiteContentView).offset(-15);
            make.height.equalTo(@44);
            make.top.equalTo(self.creatButton.mas_bottom).offset(20);
        }];
        
     
        [self.creatButton addTarget:self action:@selector(update_advertisement) forControlEvents:UIControlEventTouchUpInside];
        [self.cancledButton addTarget:self action:@selector(update_advertisement_is_cancelled_status   ) forControlEvents:UIControlEventTouchUpInside];
        self.cancledButton.enabled = YES;
        [self.whiteContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cancledButton.mas_bottom).offset(30);
        }];
        
    }else{
        
         self.creatButton = [self creatSaveButton:@"确认发布广告"];
        [self.creatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteContentView).offset(15);
            make.right.equalTo(self.whiteContentView).offset(-15);
            make.height.equalTo(@44);
            make.top.equalTo(self.numberInputView.mas_bottom).offset(40);
        }];
        [self.creatButton addTarget:self action:@selector(create_advertisement) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.creatButton.mas_bottom).offset(30);
        }];
    }
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.whiteContentView.mas_bottom);
    }];
}

-(CABaseButton*)creatSaveButton:(NSString*)title{
    CABaseButton * saveButton = [CABaseButton buttonWithTitle:title];
    [self.whiteContentView addSubview:saveButton];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 22;
    return saveButton;
}

-(void)setLeftLabelStyle:(UILabel*)leftLabel rightLabel:(UILabel*)rightLabel{
    
    leftLabel.font = FONT_REGULAR_SIZE(15);
//    leftLabel.textColor = HexRGB(0x191d26);
    
    rightLabel.font = FONT_REGULAR_SIZE(15);
    rightLabel.textColor = HexRGB(0x191d26);
    rightLabel.textAlignment = NSTextAlignmentCenter;
    
}

-(void)setLabel:(UIButton*)button title:(NSString*)title{
    
    if (self.model.ID.length) {
        
        [button setTitle:NSStringFormat(@"%@",title) forState:UIControlStateNormal];
    }else{
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                                    attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                                                                                        NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                           }];
        
        [button setAttributedTitle:attrStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showActionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

-(UIButton*)creatTopViewTitle:(NSString*)title rightTitle:(NSString*)rightTitle topView:(UIView*)topView tag:(NSInteger)tag{
    
    UILabel * label = [UILabel new];
    [self.contentView addSubview:label];
    label.font =FONT_REGULAR_SIZE(16);
    label.textColor = [UIColor whiteColor];
    label.text = NSStringFormat(@"%@",CALanguages(title));
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        if (topView) {
            make.top.equalTo(topView.mas_bottom).offset(15);
        }else{
            make.top.equalTo(self.contentView).offset(15);
        }
    }];
    

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    button.titleLabel.font = FONT_REGULAR_SIZE(16);
    [self setLabel:button title:rightTitle];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(self.contentView).offset(-20);
       make.centerY.equalTo(label);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.tag  = 2000+tag;
    
    return button;
}

-(void)showActionSheetClick:(UIButton*)btn{
    
    switch (btn.tag-2000) {
        case 1:
        {
            [CAActionSheetView showActionSheet:self.adTypeArray selectIndex:_adTypeIndex click:^(NSInteger index) {
                self->_adTypeIndex = index;
                [self setLabel:self.adTypeButton title:self.adTypeArray[index]];
                if (self->_adTypeIndex==0) {
                    self.model.trade_type = @"buy";
                }else{
                    self.model.trade_type = @"sell";
                }
            }];
        }
            break;
        case 2:
        {
            [CAActionSheetView showActionSheet:self.currencyArray selectIndex:_currencyIndex click:^(NSInteger index) {
                self->_currencyIndex = index;
                [self setLabel:self.currencyButton title:self.currencyArray[index]];
                self.model.code = [self.currencyArray[index] lowercaseString];
                self.numberInputView.rightNotiLabel.text = self.currencyArray[index];
            }];
        }
            break;
        case 3:
        {
            [CAActionSheetView showActionSheet:self.legalTypeArray selectIndex:_legalIndex click:^(NSInteger index) {
                self->_legalIndex = index;
                [self setLabel:self.legalButton title:self.legalTypeArray[index]];
                
            }];
        }
            break;
            
        default:
            break;
    }
}



-(CAChoosePayTypeView *)payView{
    if (!_payView) {
        _payView = [CAChoosePayTypeView new];
        [self.whiteContentView addSubview:_payView];
        _payView.canMultipleSelection = YES;
        _payView.delegata = self;
    }
    return _payView;
}

-(UIView *)whiteContentView{
    if (!_whiteContentView) {
        _whiteContentView = [UIView new];
        [self.contentView addSubview:_whiteContentView];
        _whiteContentView.backgroundColor = [UIColor whiteColor];
        _whiteContentView.layer.masksToBounds = YES;
        _whiteContentView.layer.cornerRadius = 5;
       
    }
    return _whiteContentView;
}

@end
