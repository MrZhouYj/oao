//
//  CARegistViewController.m
//  TASE-IOS
//
//   10/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CARegistViewController.h"
#import "CAInputView.h"
#import "CAVerificationCode.h"
#import "CACountryViewController.h"
#import "CAUser.h"

static NSString * registerIdentification  = @"registerIdentification";
static NSString * smsIdentification  = @"smsIdentification";


@interface CARegistViewController ()
<CAVerificationCodeDelegate,
CACountryViewControllerDelegate>

@property (nonatomic, strong) CAVerificationCode * verificationCode;

@property (nonatomic, copy) NSString * registType;

@property (nonatomic, strong) CAInputView * phoneOrEmailInputView;

@property (nonatomic, strong) CAInputView * codeInputView;

@property (nonatomic, strong) CAInputView * passWordInputView;

@property (nonatomic, strong) CAInputView * passWordAgainInputView;

@property (nonatomic, strong) CAInputView * inviteCodeInputView;

@property (nonatomic, strong) CABaseButton * saveButton;

@end

@implementation CARegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.verificationCode.delegate = self;
    [self setBottomButtons];
    [self initSubViews];
    self.registType = @"email";
}

-(void)setRegistType:(NSString*)registType{
    _registType = registType;
    
    self.phoneOrEmailInputView.sendButton.hidden = NO;
    self.codeInputView.inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    if ([_registType isEqualToString:@"email"]) {
        
        self.phoneOrEmailInputView.notiLabel.text = CALanguages(@"邮箱");
        self.phoneOrEmailInputView.inputView.keyboardType = UIKeyboardTypeEmailAddress;
        self.phoneOrEmailInputView.leftView.hidden = YES;
        self.phoneOrEmailInputView.requestUrl = CAAPI_MEMBERS_SEND_EMAIL_TOKEN_FOR_SIGN_UP;
        self.phoneOrEmailInputView.send_sms_key  = @"email";
        self.phoneOrEmailInputView.contentType = CAInputViewContentEmailType;
        
    }else if ([_registType isEqualToString:@"mobile"]){
        
        self.phoneOrEmailInputView.inputView.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneOrEmailInputView.notiLabel.text = CALanguages(@"手机");
        self.phoneOrEmailInputView.leftView.hidden = NO;
        self.phoneOrEmailInputView.requestUrl = CAAPI_MEMBERS_SEND_SMS_TOKEN_FOR_SIGN_UP;
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
    [changeButton setTitle:CALanguages(@"手机注册") forState:UIControlStateNormal];
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
        [btn setTitle:CALanguages(@"手机注册") forState:UIControlStateNormal];

    }else{
        
        self.registType = @"mobile";
        [btn setTitle:CALanguages(@"邮箱注册") forState:UIControlStateNormal];
    }
    self.saveButton.enabled = NO;
}

-(void)initSubViews{
    
    UIImageView * logoImageView = [UIImageView new];
    [self.contentView addSubview:logoImageView];
    logoImageView.image = IMAGE_NAMED(@"logo_image");
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(35+kTopHeight);
        make.height.width.equalTo(@(AutoNumber(45)));
    }];
    
    
    
    UIImageView * logoTextImageView = [UIImageView new];
    [self.contentView addSubview:logoTextImageView];
    logoTextImageView.image = IMAGE_NAMED(@"logo_text");
    logoTextImageView.contentMode = UIViewContentModeLeft;
    [logoTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(logoImageView);
        make.left.equalTo(logoImageView.mas_right).offset(16);
        make.height.equalTo(@(AutoNumber(23)));
        make.right.equalTo(self.contentView).offset(-50);
    }];
    
    
    self.phoneOrEmailInputView = [CAInputView showLoginTypeInputView];
    self.codeInputView         = [CAInputView showLoginTypeInputView];
    self.passWordInputView     = [CAInputView showLoginTypeInputView];
    self.passWordAgainInputView = [CAInputView showLoginTypeInputView];
    self.inviteCodeInputView   = [CAInputView showLoginTypeInputView];
    
    [self.contentView addSubview:self.phoneOrEmailInputView];
    [self.contentView addSubview:self.codeInputView];
    [self.contentView addSubview:self.passWordInputView];
    [self.contentView addSubview:self.passWordAgainInputView];
    [self.contentView addSubview:self.inviteCodeInputView];

    self.phoneOrEmailInputView.needCheck = YES;
    
    NSArray * inputs = @[self.phoneOrEmailInputView,self.codeInputView,self.passWordInputView,self.passWordAgainInputView,self.inviteCodeInputView];
    
    [inputs enumerateObjectsUsingBlock:^(CAInputView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            if (idx==0) {
                make.top.equalTo(logoImageView.mas_bottom).offset(AutoNumber(55));
            }else{
                CAInputView* lastInput = inputs[idx-1];
                make.top.equalTo(lastInput.mas_bottom).offset(15);
            }
        }];
    }];

    
    self.saveButton = [CABaseButton buttonWithTitle:CALanguages(@"注册")];
    [self.contentView addSubview:self.saveButton];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 22;
    [self.saveButton addTarget:self action:@selector(registButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@44);
        make.top.equalTo(self.inviteCodeInputView.mas_bottom).offset(30);
    }];
    
    self.codeInputView.notiLabel.text = CALanguages(@"验证码");
    self.passWordInputView.notiLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"密码"),CALanguages(@"8-32位字符，数字及字母"));
    self.passWordAgainInputView.notiLabel.text = CALanguages(@"请再次输入密码");
    self.inviteCodeInputView.notiLabel.text = [NSString stringWithFormat:@"%@(%@)",CALanguages(@"邀请码"),CALanguages(@"选填")];
    
    self.passWordInputView.inputView.secureTextEntry = YES;
    self.passWordAgainInputView.inputView.secureTextEntry = YES;

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveButton.mas_bottom);
    }];
    
    [self.phoneOrEmailInputView.chooseCountryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountryClick)]];
}

-(void)registButtonClick{
    
    [self.verificationCode startVerificationCode:registerIdentification];
    
}

-(void)CACountryViewController_didSelected:(CACountryModel *)model{
    NSLog(@"%@",model.code);
    self.phoneOrEmailInputView.chooseCountryLabel.text = model.code;
    
}

-(void)chooseCountryClick{
    
    CACountryViewController * chooseCountry = [CACountryViewController new];
    chooseCountry.delegate = self;
    [self.navigationController pushViewController:chooseCountry animated:YES];
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
    NSString * inviteCode = self.inviteCodeInputView.inputView.text;
    
   
    NSMutableDictionary * mutPara = @{
        @"geetest_challenge":NSStringFormat(@"%@",result[@"geetest_challenge"]),
        @"geetest_validate":NSStringFormat(@"%@",result[@"geetest_validate"]),
        @"geetest_seccode":NSStringFormat(@"%@",result[@"geetest_seccode"]),
        @"sign_up_type":self.registType,
        @"password":password,
        @"confirm_password":confirmPassword,
        @"inviter_code":inviteCode,
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

    [CANetworkHelper POST:CAAPI_MEMBERS_SIGN_UP parameters:mutPara success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        
        if ([responseObject[@"code"] integerValue]==20000) {
            //注册成功
            
            CAUser * user = [CAUser currentUser];
            [user creatUser:responseObject];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:CAUserDidSignInSuccessNotifacation object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
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
            
            BOOL isVlidate = [CommonMethod validatePassword:self.passWordInputView.inputView.text];
            NSLog(@"%d",isVlidate);
            
        }else{
            self.saveButton.enabled = NO;
        }
    }
}



@end
