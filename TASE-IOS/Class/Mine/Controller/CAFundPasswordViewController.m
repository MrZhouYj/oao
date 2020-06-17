//
//  CABindPhoneViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFundPasswordViewController.h"
#import "CAInputView.h"

@interface CAFundPasswordViewController ()
{
    BOOL _isBindMobile;
}
@property (nonatomic, strong) CAInputView * passwordTf;
@property (nonatomic, strong) CAInputView * phoneTf;
@property (nonatomic, strong) CAInputView * codeTf;

@property (nonatomic, strong) UILabel * codeLabel;
@property (nonatomic, strong) UIButton * saveButton;

@end

@implementation CAFundPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"资金密码";
    
    [SVProgressHUD show];
    
    [self initSubViews];
    [self getMobileFromServer];
}

-(void)getMobileFromServer{
    
    
    [CANetworkHelper GET:CAAPI_MINE_ENTER_ASSET_PASSWORD parameters:nil success:^(id responseObject) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue]==20000) {
                NSDictionary * data = responseObject[@"data"];
                if (data[@"mobile"]&&[data[@"mobile"] length]) {
                    self.phoneTf.notiLabel.text = CALanguages(@"手机号码");
                    self.codeTf.notiLabel.text =CALanguages(@"短信验证码");
                    self.phoneTf.inputView.text = NSStringFormat(@"%@ %@",data[@"country_code"],data[@"mobile"]);
                    self.codeTf.country_code = data[@"country_code"];
                    self.codeTf.mobile = data[@"mobile"];
                    self.codeTf.requestUrl = CAAPI_MINE_UPDATE_ASSET_PASSWORD_SEND_MOBILE_CODE;
                    self->_isBindMobile = YES;
                }else{
                    //没有手机号 获取绑定的邮箱
                    self.phoneTf.notiLabel.text = CALanguages(@"邮箱");
                    self.phoneTf.inputView.text = NSStringFormat(@"%@",data[@"email"]);
                    self.codeTf.notiLabel.text =CALanguages(@"邮箱验证码");
                    self->_isBindMobile = NO;
                    self.codeTf.requestUrl = CAAPI_MINE_UPDATE_ASSET_PASSWORD_SEND_EMAIL_CODE;
                    self.codeTf.send_sms_key = @"email";
                    self.codeTf.mobile = data[@"email"];
                }
            }else{
                Toast(responseObject[@"message"]);
            }
            
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)initSubViews{
    
    UIImageView * imageV = [UIImageView new];
    [self.contentView addSubview:imageV];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = IMAGE_NAMED(@"mine_password");
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AutoNumber(70));
        make.height.mas_equalTo(AutoNumber(122));
        make.top.equalTo(self.contentView).offset(35);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.passwordTf = [CAInputView showLoginTypeInputView];
    self.phoneTf  = [CAInputView showLoginTypeInputView];
    self.codeTf  = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.passwordTf];
    [self.contentView addSubview:self.phoneTf];
    [self.contentView addSubview:self.codeTf];
    
    self.passwordTf.notiLabel.text =CALanguages(@"资金密码");
    self.phoneTf.notiLabel.text = CALanguages(@"手机号码");
    self.codeTf.notiLabel.text =CALanguages(@"短信验证码");
    self.passwordTf.inputView.secureTextEntry = YES;
    
    self.phoneTf.inputView.enabled = NO;
    self.phoneTf.lineView.hidden =  YES;
    
    self.codeTf.sendButton.hidden = NO;
    self.codeTf.sendButton.enabled = YES;
    [self.codeTf setSendEnable:YES];
    self.codeTf.inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    
    
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(imageV.mas_bottom).offset(15);
        
    }];
    
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self.phoneTf);
       make.top.equalTo(self.phoneTf.mas_bottom).offset(10);
    }];
    
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.codeTf);
        make.top.equalTo(self.codeTf.mas_bottom).offset(10);
    }];
    
    if (@available(iOS 12.0, *)) {
        //Xcode 10 适配
        self.codeTf.inputView.textContentType = UITextContentTypeOneTimeCode;
    }
 
    self.saveButton = [CABaseButton buttonWithTitle:@"保存"];
    [self.contentView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTf);
        make.height.equalTo(@43);
        make.top.equalTo(self.passwordTf.mas_bottom).offset(30);
    }];
    
    [self.saveButton addTarget:self action:@selector(bindSecretClick) forControlEvents:UIControlEventTouchUpInside];

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveButton.mas_bottom).offset(20);
    }];
    
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:CAInputViewSendMessageSuccess]) {
        [self.codeTf.inputView becomeFirstResponder];
    }else if ([eventName isEqualToString:@"textFieldDidChange"]) {
        if ([self.passwordTf.inputView.text length]&&[self.codeTf.inputView.text length]) {
            self.saveButton.enabled = YES;
        }else{
            self.saveButton.enabled = NO;
        }
    }
}

-(void)bindSecretClick{
    
    [SVProgressHUD show];

    NSDictionary * para = @{
        @"asset_password":NSStringFormat(@"%@",self.passwordTf.inputView.text),
        @"validation_code":NSStringFormat(@"%@",self.codeTf.inputView.text),
    };
    
     [CANetworkHelper POST:CAAPI_MINE_UPDATE_ASSET_PASSWORD parameters:para success:^(id responseObject) {

         dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
             Toast(responseObject[@"message"]);
             if ([responseObject[@"code"] integerValue]==20000) {
                 [self.navigationController popViewControllerAnimated:YES];
             }
         });
         
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}

@end
