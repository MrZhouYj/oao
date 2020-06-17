//
//  CAAddPayViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAddPayViewController.h"
#import "CAInputView.h"
#import "CApaymentMethodViewController.h"

@interface CAAddPayViewController ()<UITextFieldDelegate>

{
    UIImage * _qrcodeImage;
}
@property (nonatomic, strong) CAPhotoAlbumImagePicker * picker;
@property (nonatomic, strong) CAInputView * realNameInputView;
@property (nonatomic, strong) CAInputView * accountTf;
@property (nonatomic, strong) CAInputView * nameTf;
@property (nonatomic, strong) CAInputView * cardLocalTf;
@property (nonatomic, assign) BOOL enableSend;
@property (nonatomic, strong) UIImageView * qrcodeImageView;
@property (nonatomic, strong) CABaseButton * saveButton;

@end

@implementation CAAddPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubViews];
}

-(void)updatePay{
    // alipay 支付宝 wechat 微信 bank_card 银行卡
    NSDictionary * para;
    
    NSString * account = self.accountTf.inputView.text;
    NSString * name = self.nameTf.inputView.text;
    NSString * qrcodeKey = @"";
    
    if ([self.payType isEqualToString:@"alipay"]) {
        para = @{
            @"alipay_account":NSStringFormat(@"%@",account)
        };
        qrcodeKey = @"alipay_qr_code";
    }else if ([self.payType isEqualToString:@"wechat"]){
        para = @{
            @"wechat_account":NSStringFormat(@"%@",account)
        };
        qrcodeKey = @"wechat_qr_code";
    }else if ([self.payType isEqualToString:@"bank_card"]){
        para = @{
            @"bank_account_number":NSStringFormat(@"%@",account),
            @"bank_name":NSStringFormat(@"%@",name)
        };
    }
    
    NSMutableArray * qrcodea = @[].mutableCopy;
    if (_qrcodeImage) {
        [qrcodea addObject:_qrcodeImage];
    }
    
    [SVProgressHUD show];
    [CANetworkHelper uploadImagesWithURL:CAAPI_MINE_UPDATE_PAYMENT_METHODS parameters:para name:@[qrcodeKey] images:qrcodea progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[CApaymentMethodViewController class]]) {
                    CApaymentMethodViewController *payment =(CApaymentMethodViewController *)controller;
                         [self.navigationController popToViewController:payment animated:YES];
                         return;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)initSubViews{
    
    
     self.saveButton = [CABaseButton buttonWithTitle:@"保存"];
    [self.view addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(updatePay) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight-10);
        make.height.equalTo(@40);
    }];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.bigTitleLabel.mas_bottom);
        make.bottom.equalTo(self.saveButton.mas_top);
    }];
    
    CAInputView * realNameInputView = [CAInputView showLoginTypeInputView];
    realNameInputView.inputView.text = NSStringFormat(@"%@",[CAUser currentUser].real_name);
    [self.contentView addSubview:realNameInputView];
    realNameInputView.inputView.enabled = NO;
    realNameInputView.notiLabel.text = CALanguages(@"姓名") ;
    realNameInputView.notiLabel.textColor = HexRGB(0x8a8a92);
    self.realNameInputView = realNameInputView;
    [realNameInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    if ([self.payType isEqualToString:@"alipay"]) {
        if (self.dataDic) {
            self.bigNavcTitle = @"支付宝";
        }else{
            self.bigNavcTitle = @"添加支付宝";
        }
         
        [self initAlipayOrWeixinPay];
        if (self.dataDic) {
            self.accountTf.inputView.text = NSStringFormat(@"%@",self.dataDic[@"account"]);
        }
    }else if ([self.payType isEqualToString:@"wechat"]){
        if (self.dataDic) {
            self.bigNavcTitle = @"微信";
        }else{
            self.bigNavcTitle = @"添加微信";
        }
        
        [self initAlipayOrWeixinPay];
        
        if (self.dataDic) {
            self.accountTf.inputView.text = NSStringFormat(@"%@",self.dataDic[@"account"]);
        }
    }else if ([self.payType isEqualToString:@"bank_card"]){
        if (self.dataDic) {
            self.bigNavcTitle = @"银行卡";
        }else{
            self.bigNavcTitle = @"添加银行卡";
        }
        [self initBankCard];
        if (self.dataDic) {
            self.accountTf.inputView.text = NSStringFormat(@"%@",self.dataDic[@"bank_account_number"]);
            self.nameTf.inputView.text = NSStringFormat(@"%@",self.dataDic[@"bank_name"]);
        }
    }
}



-(void)initAlipayOrWeixinPay{
    

    self.accountTf = [CAInputView showLoginTypeInputView];
    self.accountTf.notiLabel.text = CALanguages(@"账号");
    [self.contentView addSubview:self.accountTf];
    [self.accountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.realNameInputView.mas_bottom).offset(25);
    }];
    
    self.accountTf.notiLabel.textColor = HexRGB(0x8a8a92);
    
    
    UILabel * qrcodeNoti = [UILabel new];
    [self.contentView addSubview:qrcodeNoti];
    qrcodeNoti.text = CALanguages(@"二维码");
    qrcodeNoti.font = FONT_REGULAR_SIZE(15);
    qrcodeNoti.textColor = HexRGB(0x8a8a92);
    [qrcodeNoti mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.accountTf.mas_bottom).offset(20);
    }];


    self.qrcodeImageView = [UIImageView new];
    [self.contentView addSubview:self.qrcodeImageView];
    self.qrcodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.qrcodeImageView.image = IMAGE_NAMED(@"addPayImage");
    
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AutoNumber(247));
        make.height.mas_equalTo(AutoNumber(344));
        make.top.equalTo(qrcodeNoti.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.qrcodeImageView.userInteractionEnabled = YES;
    [self.qrcodeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_choseImageCick:)]];
    
    if (self.dataDic&&[self.dataDic[@"qrcode"] length]) {
        
        [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"qrcode"]] placeholderImage:IMAGE_NAMED(@"addPayImage") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                self->_qrcodeImage = image;
            }
        }];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.qrcodeImageView.mas_bottom).offset(20);
    }];
}


-(void)event_choseImageCick:(UIGestureRecognizer*)tap{
    
    [self.picker  getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage * _Nonnull image) {
        self.qrcodeImageView.image = image;
        self->_qrcodeImage = image;
        [self judgeIsenableSend];
    }];
}

-(void)initBankCard{
    
    self.accountTf = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.accountTf];
    self.accountTf.notiLabel.text = CALanguages(@"银行卡号");
    [self.accountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.realNameInputView.mas_bottom).offset(25);
    }];
    
    
    self.nameTf = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.nameTf];
    self.nameTf.notiLabel.text = CALanguages(@"开户银行");
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.accountTf.mas_bottom).offset(25);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameTf.mas_bottom).offset(20);
    }];
}

-(CAPhotoAlbumImagePicker *)picker{
    if (!_picker) {
        _picker = [CAPhotoAlbumImagePicker new];
    }
    return _picker;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    if ([eventName isEqualToString:@"textFieldDidChange"]) {
        // 0 支付宝 1 微信 2 银行卡
        [self judgeIsenableSend];
    }
}

-(void)judgeIsenableSend{
    
    if ([self.payType isEqualToString:@"alipay"]||[self.payType isEqualToString:@"wechat"]) {
        NSString * account = self.accountTf.inputView.text;
        if (account.length&&_qrcodeImage) {
            self.enableSend = YES;
        }else{
            self.enableSend = NO;
        }
    }else if ([self.payType isEqualToString:@"bank_card"]){
        NSString * account = self.accountTf.inputView.text;
        NSString * name = self.nameTf.inputView.text;
        if (account.length&&name.length) {
            self.enableSend = YES;
        }else{
            self.enableSend = NO;
        }
    }
}

-(void)setEnableSend:(BOOL)enableSend{
    _enableSend = enableSend;
    self.saveButton.enabled = enableSend;
}

@end
