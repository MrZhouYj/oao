//
//  CAloginViewController.m
//  TASE-IOS
//
//   10/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAloginViewController.h"
#import "CARegistViewController.h"
#import "CAInputView.h"
#import "CAVerificationCode.h"
#import "CAUser.h"
#import "CAForgetPasswordViewController.h"

static NSString * loginIdentification  = @"loginIdentification";
static NSString * smsIdentification  = @"smsIdentification";

@interface CAloginViewController ()
<CAVerificationCodeDelegate>

@property (nonatomic, strong) CAVerificationCode * verificationCode;

@property (nonatomic, copy) NSString * loginType;

@property (nonatomic, strong) CAInputView * phoneInputView;

@property (nonatomic, strong) CAInputView * passWordInputView;

@property (nonatomic, strong) UIButton * forgetButton;

@property (nonatomic, strong) CABaseButton * saveButton;

@end

@implementation CAloginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.verificationCode.delegate = self;
    
    [self initSubViews];
    [self setBottomButtons];
    [self setBack];

    self.loginType =  @"password";//密码登录  验证码登录
}

-(void)setLoginType:(NSString *)loginType{
    
    _loginType = loginType;
    
    if ([_loginType isEqualToString:@"password"]) {
        
        self.phoneInputView.notiLabel.text = CALanguages(@"邮箱或手机");
        self.passWordInputView.notiLabel.text = CALanguages(@"密码");
        
        self.forgetButton.hidden = NO;
        self.phoneInputView.inputView.keyboardType = UIKeyboardTypeDefault;
        self.passWordInputView.inputView.keyboardType = UIKeyboardTypeDefault;
        self.phoneInputView.sendButton.hidden = YES;
        self.passWordInputView.inputView.secureTextEntry = YES;
        self.phoneInputView.contentType = CAInputViewContentNone;
        
    }else if ([_loginType isEqualToString:@"sms"]){
        
        self.phoneInputView.notiLabel.text = CALanguages(@"手机号码");
        self.passWordInputView.notiLabel.text =CALanguages(@"验证码");
        self.passWordInputView.inputView.secureTextEntry = NO;
        self.forgetButton.hidden = YES;
        self.phoneInputView.inputView.keyboardType = UIKeyboardTypePhonePad;
        self.passWordInputView.inputView.keyboardType = UIKeyboardTypeNamePhonePad;
        self.phoneInputView.sendButton.hidden = NO;
        self.phoneInputView.contentType = CAInputViewContentPhoneType;

    }
    
    self.phoneInputView.inputView.text = @"";
    self.passWordInputView.inputView.text = @"";
    self.saveButton.enabled = NO;
    [self.phoneInputView setNeedsLayout];
}

-(void)setBottomButtons{
    
    UIView * bottomContentView = [UIView new];
    [self.view addSubview:bottomContentView];
    
    [bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(49+SafeAreaBottomHeight));
    }];
    
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomContentView addSubview:changeButton];
    
    [changeButton setTitle:CALanguages(@"手机验证码登录") forState:UIControlStateNormal];
    [changeButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    changeButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    
    UIButton * registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomContentView addSubview:registButton];
    
    [registButton setTitle:CALanguages(@"注册") forState:UIControlStateNormal];
    [registButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    registButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    
    [@[changeButton,registButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:30 tailSpacing:30];
    
    [changeButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [registButton addTarget:self action:@selector(gotoRegistController) forControlEvents:UIControlEventTouchUpInside];
    [changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   
}

-(void)changeButtonClick:(UIButton*)btn{
    
    if ([self.loginType isEqualToString:@"sms"]) {
        self.loginType = @"password";
        [btn setTitle:CALanguages(@"手机验证码登录") forState:UIControlStateNormal];

    }else{
        self.loginType = @"sms";
        [btn setTitle:CALanguages(@"密码登录") forState:UIControlStateNormal];
    }
}

-(void)gotoRegistController{
   
    CARegistViewController * regist = [CARegistViewController new];
    
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark 初始化布局
-(void)initSubViews{
    
    UIImageView * logoImageView = [UIImageView new];
    [self.contentView addSubview:logoImageView];
    logoImageView.image = IMAGE_NAMED(@"logo_image");
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(35+kTopHeight);
        make.height.width.equalTo(@(AutoNumber(97)));
    }];
    
    UIImageView * logoTextImageView = [UIImageView new];
    [self.contentView addSubview:logoTextImageView];
    logoTextImageView.image = IMAGE_NAMED(@"logo_text");
    logoTextImageView.contentMode = UIViewContentModeScaleAspectFit;
    [logoTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(logoImageView.mas_bottom).offset(AutoNumber(26));
        make.height.equalTo(@(AutoNumber(29)));
        make.width.equalTo(@(MainWidth));
    }];

    self.phoneInputView = [CAInputView showLoginTypeInputView];
    self.passWordInputView = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.phoneInputView];
    [self.contentView addSubview:self.passWordInputView];
    self.phoneInputView.requestUrl = CAAPI_MEMBERS_SEND_SMS_TOKEN_TO_MEMBER;
    self.phoneInputView.needCheck = YES;
    
    
    
    [self.phoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(logoTextImageView.mas_bottom).offset(AutoNumber(80));
    }];
    [self.passWordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.phoneInputView.mas_bottom).offset(15);
    }];
    
    
    self.saveButton = [CABaseButton buttonWithTitle:CALanguages(@"登录")];
    [self.contentView addSubview:self.saveButton];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 22;
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@44);
        make.top.equalTo(self.passWordInputView.mas_bottom).offset(30);
    }];
    [self.saveButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton * forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:forgetButton];
    self.forgetButton = forgetButton;
    [forgetButton setTitle:CALanguages(@"忘记密码") forState:UIControlStateNormal];
    [forgetButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passWordInputView.mas_left);
        make.top.equalTo(self.saveButton.mas_bottom).offset(15);
        make.height.equalTo(@20);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveButton.mas_bottom).offset(40);
    }];
    
}

-(void)forgetPasswordClick{
    
    CAForgetPasswordViewController * forgetPassword = [CAForgetPasswordViewController new];
    if (self.phoneInputView.inputView.text) {
        forgetPassword.loginAccount = self.phoneInputView.inputView.text;
    }
    [self.navigationController pushViewController:forgetPassword animated:YES];
}

-(void)loginButtonClick{
    
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self.verificationCode startVerificationCode:loginIdentification];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:@"CAInputView_sendMessage"]) {
        [self.view endEditing:YES];
        [self.verificationCode startVerificationCode:smsIdentification];
    }else if ([eventName isEqualToString:@"textFieldDidChange"]) {
        
       
        if ([self.phoneInputView.inputView.text length]&&[self.passWordInputView.inputView.text length]) {
            
            if ([self.loginType isEqualToString:@"password"]) {
               self.saveButton.enabled = [CommonMethod checkPhoneOrEmail:self.phoneInputView.inputView.text];
            }else{
               self.saveButton.enabled = [CommonMethod validataPhone:self.phoneInputView.inputView.text];
            }
            
        }else{
            self.saveButton.enabled = NO;
        }
    }
}


#pragma mark 设置返回按钮
-(void)setBack{
    
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49-SafeAreaBottomHeight);
    }];
    
    
    UIView *backContentView = [UIView new];
    [self.view addSubview:backContentView];
    
    [backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.height.equalTo(@44);
    }];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backContentView addSubview:backButton];
    
    [backButton setTitle:CALanguages(@"取消") forState:UIControlStateNormal];
    backButton.titleLabel.font = FONT_SEMOBOLD_SIZE(14);
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backContentView).offset(20);
        make.centerY.equalTo(backContentView);
    }];
    
}

-(void)dismissSelf{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark CAVerficationCodeDelegate

-(void)CAVerficationCode_responesSuccess:(NSDictionary *)result identification:(NSString *)identification{
    
    if ([identification isEqualToString:loginIdentification]) {
        
        [self loginAction:result];
        
    }else if ([identification isEqualToString:smsIdentification]){
        
        [self.phoneInputView startSendMessageWithGT3Result:result];
    }
}

-(void)loginAction:(NSDictionary*)result{
    
    NSString * phone = self.phoneInputView.inputView.text;
    NSString * password = self.passWordInputView.inputView.text;

    
    NSDictionary * para = @{
    @"geetest_challenge":NSStringFormat(@"%@",result[@"geetest_challenge"]),
    @"geetest_validate":NSStringFormat(@"%@",result[@"geetest_validate"]),
    @"geetest_seccode":NSStringFormat(@"%@",result[@"geetest_seccode"]),
        @"type":self.loginType,
        @"email_or_mobile":phone,
        @"password_or_sms_code":password,
    };
    
    
    
    [SVProgressHUD show];
    
    [CANetworkHelper POST:CAAPI_MEMBERS_SIGN_IN parameters:para success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        
        if ([responseObject[@"code"] integerValue]==20000) {
            //登录成功
           CAUser * user = [CAUser currentUser];
           [user creatUser:responseObject];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                [[NSNotificationCenter defaultCenter] postNotificationName:CAUserDidSignInSuccessNotifacation object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
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
-(void)dealloc{
    
    
}



@end
