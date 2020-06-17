//
//  CABindPhoneViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEmailViewController.h"
#import "CAInputView.h"

@interface CAEmailViewController ()

@property (nonatomic, strong) CAInputView * emailTf;
@property (nonatomic, strong) CAInputView * codeTf;

@property (nonatomic, strong) UILabel * emailLabel;
@property (nonatomic, strong) UIButton * unBindEmailButton;
@property (nonatomic, strong) CABaseButton * saveButton;
@end

@implementation CAEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"邮箱设置";
    
    [SVProgressHUD show];
    
    [self initSubViews];
    [self getEmailFromServer];
}

-(void)getEmailFromServer{
    
    [CANetworkHelper GET:CAAPI_MINE_EDIT_BIND_EMAIL parameters:nil success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue]==20000) {
                NSString * email = responseObject[@"data"][@"binded_email"];
                if (email&&email.length&&![email containsString:@"needtobindemail"]) {
                    self.emailLabel.text = NSStringFormat(@"%@：\n%@",CALanguages(@"您已经绑定了邮箱账号"),responseObject[@"data"][@"binded_email"]);
                    self.unBindEmailButton.hidden = NO;
                }
            }
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)sendBindEmailRequest{
    
    NSDictionary * para  = @{
        @"email":NSStringFormat(@"%@",self.emailTf.inputView.text),
        @"email_code":NSStringFormat(@"%@",self.codeTf.inputView.text)
    };
    
    [SVProgressHUD show];
   
    [CANetworkHelper POST:CAAPI_MINE_BIDN_EMAIL parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] integerValue]==20000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)initSubViews{
    
    UIImageView * imageV = [UIImageView new];
    [self.contentView addSubview:imageV];
    imageV.image = IMAGE_NAMED(@"mine_email");
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AutoNumber(70));
        make.height.mas_equalTo(AutoNumber(122));
        make.top.equalTo(self.contentView).offset(35);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.emailTf = [CAInputView showLoginTypeInputView];
    self.emailTf.inputView.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTf.notiLabel.text = CALanguages(@"邮箱");
    self.emailTf.sendButton.hidden = NO;
    [self.contentView addSubview:self.emailTf];
    self.emailTf.requestUrl = CAAPI_MINE_SEND_BIND_EMAIL_CODE;
    self.emailTf.send_sms_key = @"email";
    self.emailTf.contentType = CAInputViewContentEmailType;
    
    
    self.codeTf  = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.codeTf];
    self.codeTf.notiLabel.text =CALanguages(@"验证码");
    self.codeTf.inputView.keyboardType = UIKeyboardTypeNumberPad;
    
    
    [self.emailTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(imageV.mas_bottom).offset(15);
    }];
    
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.emailTf);
        make.top.equalTo(self.emailTf.mas_bottom).offset(10);
    }];
   
    self.saveButton = [CABaseButton buttonWithTitle:@"保存"];
    [self.contentView addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(sendBindEmailRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.emailTf);
        make.height.equalTo(@43);
        make.top.equalTo(self.codeTf.mas_bottom).offset(30);
    }];
    
    self.emailLabel = [UILabel new];
    [self.contentView addSubview:self.emailLabel];
    self.emailLabel.font = FONT_MEDIUM_SIZE(14);
    self.emailLabel.textColor = HexRGB(0x8a8a92);
    self.emailLabel.numberOfLines = 0;
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.saveButton);
        make.right.equalTo(self.saveButton.mas_right).offset(-60);
        make.top.equalTo(self.saveButton.mas_bottom).offset(15);
    }];
    
    UIButton * unBindEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:unBindEmailButton];
    self.unBindEmailButton = unBindEmailButton;
    [unBindEmailButton setTitle:CALanguages(@"解绑")  forState:UIControlStateNormal];
    unBindEmailButton.titleLabel.font = FONT_MEDIUM_SIZE(13);
    [unBindEmailButton setTitleColor:HexRGB(0x0a6cdb) forState:UIControlStateNormal];
    unBindEmailButton.hidden =  YES;
    [unBindEmailButton addTarget:self action:@selector(unBindEmailClick) forControlEvents:UIControlEventTouchUpInside];
    [unBindEmailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.saveButton.mas_right);
        make.top.equalTo(self.saveButton.mas_bottom).offset(15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.emailLabel.mas_bottom).offset(20);
    }];
    
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:CAInputViewSendMessageSuccess]) {
        [self.codeTf.inputView becomeFirstResponder];
    }else if ([eventName isEqualToString:@"textFieldDidChange"]) {
        if ([self.emailTf.inputView.text length]&&[self.codeTf.inputView.text length]) {
            self.saveButton.enabled = YES;
        }else{
            self.saveButton.enabled = NO;
        }
    }
}

-(void)unBindEmailClick{
    
    [SVProgressHUD show];
    
     [CANetworkHelper POST:CAAPI_MINE_UNBIDN_EMAIL parameters:nil success:^(id responseObject) {
         [SVProgressHUD dismiss];
         if ([responseObject[@"code"] integerValue]==20000) {
             self.emailLabel.text = @"";
             self.unBindEmailButton.hidden = YES;
         }
         Toast(responseObject[@"message"]);
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}


@end
