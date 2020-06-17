//
//  CABindPhoneViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABindPhoneViewController.h"
#import "CAInputView.h"
#import "CACountryViewController.h"

@interface CABindPhoneViewController ()
<CACountryViewControllerDelegate>

@property (nonatomic, strong) CAInputView * phoneTf;
@property (nonatomic, strong) CAInputView * codeTf;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) UILabel * mobileLabel;

@end
 
@implementation CABindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navcTitle = @"绑定手机";
    
     
    [SVProgressHUD show];
    
    [self initSubViews];
    [self getMobileFromServer];
}

-(void)getMobileFromServer{
    
    [CANetworkHelper GET:CAAPI_MINE_GET_BIND_MOBILE parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"code"] integerValue]==20000) {
            dispatch_async(dispatch_get_main_queue(), ^{
               NSDictionary * data = responseObject[@"data"];
                if ([data[@"mobile"] length]) {
                    self.mobileLabel.text = NSStringFormat(@"%@：%@ %@",CALanguages(@"您已经绑定了手机号"),data[@"country_code"],data[@"mobile"]);
                    self.phoneTf.country_code = data[@"country_code"];
                }
            });
        }
       
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)initSubViews{
    
    UIImageView * imageV = [UIImageView new];
    [self.contentView addSubview:imageV];
    imageV.image = IMAGE_NAMED(@"bindPhone");
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AutoNumber(70));
        make.height.mas_equalTo(AutoNumber(122));
        make.top.equalTo(self.contentView).offset(35);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.phoneTf = [CAInputView showLoginTypeInputView];
    self.codeTf  = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.phoneTf];
    [self.contentView addSubview:self.codeTf];
    //组件发送段信息验证 需要传递发送的接口
    self.phoneTf.requestUrl = CAAPI_MINE_SEND_SMS_VALIDATION_CODE;
    
    self.phoneTf.inputView.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTf.notiLabel.text = CALanguages(@"手机号码");
    self.phoneTf.sendButton.hidden = NO;
    self.phoneTf.country_code = @"+86";
    self.phoneTf.contentType = CAInputViewContentPhoneType;
    
    self.codeTf.notiLabel.text =CALanguages(@"验证码");
    self.codeTf.inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(imageV.mas_bottom).offset(10);
    }];
    
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTf);
        make.top.equalTo(self.phoneTf.mas_bottom).offset(10);
    }];
    
    if (@available(iOS 12.0, *)) {
        //Xcode 10 适配
        self.codeTf.inputView.textContentType = UITextContentTypeOneTimeCode;
    }
    
    self.saveButton = [CABaseButton buttonWithTitle:@"保存"];
    [self.contentView addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTf);
        make.height.equalTo(@43);
        make.top.equalTo(self.codeTf.mas_bottom).offset(30);
    }];
    
    self.mobileLabel = [UILabel new];
    [self.contentView addSubview:self.mobileLabel];
    self.mobileLabel.font = FONT_MEDIUM_SIZE(14);
    self.mobileLabel.textColor = HexRGB(0x8a8a92);
    self.mobileLabel.numberOfLines = 0;
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.saveButton);
        make.top.equalTo(self.saveButton.mas_bottom).offset(15);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mobileLabel.mas_bottom).offset(20);
    }];
    
    
    [self.phoneTf.chooseCountryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountryClick)]];
}

-(void)saveAction{
   
    NSDictionary * para = @{
        @"validation_code":NSStringFormat(@"%@",self.codeTf.inputView.text),
        @"new_mobile":NSStringFormat(@"%@",self.phoneTf.inputView.text),
        @"country_code":NSStringFormat(@"%@",self.phoneTf.country_code)
    };
    [SVProgressHUD show];
    [CANetworkHelper POST:CAAPI_MINE_BIND_MOBILE parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:CAInputViewSendMessageSuccess]) {
        [self.codeTf.inputView becomeFirstResponder];
    }else if ([eventName isEqualToString:@"textFieldDidChange"]) {
        if ([self.codeTf.inputView.text length]&&[self.phoneTf.inputView.text length]) {
            self.saveButton.enabled = YES;
        }else{
            self.saveButton.enabled = NO;
        }
    }
}

-(void)CACountryViewController_didSelected:(CACountryModel *)model{
    
    self.phoneTf.chooseCountryLabel.text = model.code;
    self.phoneTf.country_code = model.code;
    
}

-(void)chooseCountryClick{
    
    CACountryViewController * chooseCountry = [CACountryViewController new];
    chooseCountry.delegate = self;
    [self.navigationController pushViewController:chooseCountry animated:YES];
}

@end
