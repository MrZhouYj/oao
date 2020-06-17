//
//  CAForgetPasswordViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/28.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAForgetPasswordViewController.h"

#import "CAInputView.h"
#import "CAVerificationCode.h"
#import "CACountryViewController.h"
#import "CAUser.h"

static NSString * registerIdentification  = @"registerIdentification";
static NSString * smsIdentification  = @"smsIdentification";

@interface CAForgetPasswordViewController ()
<CAVerificationCodeDelegate>

@property (nonatomic, strong) CAVerificationCode * verificationCode;

@property (nonatomic, copy) NSString * registType;

@property (nonatomic, strong) CAInputView * phoneOrEmailInputView;

@property (nonatomic, strong) CAInputView * codeInputView;

@property (nonatomic, strong) CAInputView * passWordInputView;

@property (nonatomic, strong) CAInputView * passWordAgainInputView;

@property (nonatomic, strong) CABaseButton * saveButton;

@end

@implementation CAForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.verificationCode.delegate = self;
    [self setBottomButtons];
    [self initSubViews];
    
    if (self.loginAccount&&[self.loginAccount containsString:@"@"]) {
        self.registType = @"email";
        
    }else{
        self.registType = @"mobile";
    }

    if (self.loginAccount&&self.loginAccount.length) {
        self.phoneOrEmailInputView.inputView.text = self.loginAccount;
        [self.phoneOrEmailInputView textFieldDidChange];
    }
}

-(void)setRegistType:(NSString*)registType{
    _registType = registType;
    
    self.phoneOrEmailInputView.sendButton.hidden = NO;
    self.codeInputView.inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    if ([_registType isEqualToString:@"email"]) {
        
        self.phoneOrEmailInputView.notiLabel.text = CALanguages(@"邮箱");
        self.phoneOrEmailInputView.inputView.keyboardType = UIKeyboardTypeEmailAddress;
        self.phoneOrEmailInputView.requestUrl = CAAPI_MEMBERS_FORGOT_PASSWORD_SEND_EMAIL_CODE;
        self.phoneOrEmailInputView.send_sms_key  = @"email";
        self.phoneOrEmailInputView.contentType = CAInputViewContentEmailType;
        
    }else if ([_registType isEqualToString:@"mobile"]){
        
        self.phoneOrEmailInputView.inputView.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneOrEmailInputView.notiLabel.text = CALanguages(@"手机");
        self.phoneOrEmailInputView.requestUrl = CAAPI_MEMBERS_FORGOT_PASSWORD_SEND_SMS_CODE;
        self.phoneOrEmailInputView.send_sms_key  = @"mobile";
        self.phoneOrEmailInputView.contentType = CAInputViewContentPhoneType;

    }
   
    
    self.phoneOrEmailInputView.inputView.text = @"";
    [self.phoneOrEmailInputView textFieldDidChange];
    
    [self.phoneOrEmailInputView setNeedsLayout];
}

-(void)setBottomButtons{
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49-SafeAreaBottomHeight);
    }];
    
    
    UIView * bottomContentView = [UIView new];
    [self.view addSubview:bottomContentView];
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(49+SafeAreaBottomHeight));
    }];
    
    
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomContentView addSubview:changeButton];
    [changeButton setTitle:CALanguages(@"邮箱") forState:UIControlStateNormal];
    [changeButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    changeButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomContentView);
    }];
   
}

-(void)changeButtonClick:(UIButton*)btn{
    
    if ([self.registType isEqualToString:@"mobile"]) {
        
        self.registType = @"email";
        [btn setTitle:CALanguages(@"手机") forState:UIControlStateNormal];

    }else{
        
        self.registType = @"mobile";
        [btn setTitle:CALanguages(@"邮箱") forState:UIControlStateNormal];
    }
    
     self.saveButton.enabled = NO;
}

-(void)initSubViews{
    
    UILabel * titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    
    titleLabel.text = CALanguages(@"忘记密码") ;
    titleLabel.font = FONT_SEMOBOLD_SIZE(25);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10+kTopHeight);
    }];
    
    self.phoneOrEmailInputView = [CAInputView showLoginTypeInputView];
    self.codeInputView         = [CAInputView showLoginTypeInputView];
    self.passWordInputView     = [CAInputView showLoginTypeInputView];
    self.passWordAgainInputView = [CAInputView showLoginTypeInputView];
    
    [self.contentView addSubview:self.phoneOrEmailInputView];
    [self.contentView addSubview:self.codeInputView];
    [self.contentView addSubview:self.passWordInputView];
    [self.contentView addSubview:self.passWordAgainInputView];

    self.phoneOrEmailInputView.needCheck = YES;
    
    NSArray * inputs = @[self.phoneOrEmailInputView,self.codeInputView,self.passWordInputView,self.passWordAgainInputView];
    
    [inputs enumerateObjectsUsingBlock:^(CAInputView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            if (idx==0) {
                make.top.equalTo(titleLabel.mas_bottom).offset(AutoNumber(55));
            }else{
                CAInputView* lastInput = inputs[idx-1];
                make.top.equalTo(lastInput.mas_bottom).offset(15);
            }
        }];
    }];

    self.passWordInputView.inputView.secureTextEntry = YES;
    self.passWordAgainInputView.inputView.secureTextEntry = YES;
    
    
    self.saveButton = [CABaseButton buttonWithTitle:@"确认修改"];
    [self.contentView addSubview:self.saveButton];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 22;
    [self.saveButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@44);
        make.top.equalTo(self.passWordAgainInputView.mas_bottom).offset(30);
    }];
    
    self.codeInputView.notiLabel.text = CALanguages(@"验证码");
    self.passWordInputView.notiLabel.text =  NSStringFormat(@"%@(%@)",CALanguages(@"密码"),CALanguages(@"8-32位字符，数字及字母"));
    self.passWordAgainInputView.notiLabel.text = CALanguages(@"请再次输入密码");
   
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveButton.mas_bottom);
    }];

}


-(void)registButtonClick{

    [self.verificationCode startVerificationCode:registerIdentification];
    
}

#pragma mark CAVerficationCodeDelegate

-(void)CAVerficationCode_responesSuccess:(NSDictionary *)result identification:(NSString *)identification{
    
    if ([identification isEqualToString:registerIdentification]) {
        
        [self registAction:result];
        
    }else if ([identification isEqualToString:smsIdentification]){
        
        [self.phoneOrEmailInputView startSendMessageWithGT3Result:result];
    }
    
}

-(void)registAction:(NSDictionary*)result{
    
    NSString * phone = self.phoneOrEmailInputView.inputView.text;
    NSString * code = self.codeInputView.inputView.text;
    NSString * password = self.passWordInputView.inputView.text;
    NSString * confirmPassword = self.passWordAgainInputView.inputView.text;
    
   
    NSMutableDictionary * mutPara = @{
        @"geetest_challenge":NSStringFormat(@"%@",result[@"geetest_challenge"]),
        @"geetest_validate":NSStringFormat(@"%@",result[@"geetest_validate"]),
        @"geetest_seccode":NSStringFormat(@"%@",result[@"geetest_seccode"]),
        @"type":self.registType,
        @"password":password,
        @"confirm_password":confirmPassword,
    }.mutableCopy;
    
     if ([self.registType isEqualToString:@"email"]) {
         [mutPara addEntriesFromDictionary:@{
             @"email":phone,
             @"email_token":code,
         }];
     }else{
         [mutPara addEntriesFromDictionary:@{
             @"mobile":phone,
             @"sms_token":code,
         }];
     }
    [SVProgressHUD show];

    [CANetworkHelper POST:CAAPI_MEMBERS_GORGOT_PASWORD parameters:mutPara success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        
        if ([responseObject[@"code"] integerValue]==20000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)CAVerficationCode_responesFail_identification:(NSString *)identification{

}

-(CAVerificationCode *)verificationCode{
    if (!_verificationCode) {
        _verificationCode = [CAVerificationCode new];
    }
    return _verificationCode;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:@"CAInputView_sendMessage"]) {
        [self.view endEditing:YES];
        [self.verificationCode startVerificationCode:smsIdentification];
    }else if ([eventName isEqualToString:@"textFieldDidChange"]) {
        if (
            [self.phoneOrEmailInputView.inputView.text length]&&
            [self.codeInputView.inputView.text length]&&
            [self.passWordInputView.inputView.text length]&&
            [self.passWordAgainInputView.inputView.text length]) {
            if ([self.registType isEqualToString:@"email"]) {
                self.saveButton.enabled = [CommonMethod validateEmail:self.phoneOrEmailInputView.inputView.text];
            }else{
                self.saveButton.enabled = [CommonMethod validataPhone:self.phoneOrEmailInputView.inputView.text];
            }
            
        }else{
            self.saveButton.enabled = NO;
        }
    }
}


@end
