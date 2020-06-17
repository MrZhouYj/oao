//
//  CAUpdatePasswordViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/28.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAUpdatePasswordViewController.h"
#import "CAInputView.h"

@interface CAUpdatePasswordViewController ()

@property (nonatomic, strong) CAInputView * passWordOldInputView;
@property (nonatomic, strong) CAInputView * passWordNewInputView;
@property (nonatomic, strong) CABaseButton * saveButton;

@end

@implementation CAUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

-(void)initSubViews{
    
    self.bigNavcTitle = @"修改登录密码";
    UILabel * notiLabel = [UILabel new];
    [self.view addSubview:notiLabel];
    notiLabel.font = FONT_MEDIUM_SIZE(13);
    notiLabel.dk_textColorPicker = DKColorPickerWithKey(GrayTextColot_a3a4bd);
    notiLabel.text = CALanguages(@"8-32位字符，数字及字母");
    [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.top.equalTo(self.bigTitleLabel.mas_bottom);
    }];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(notiLabel.mas_bottom);
        make.bottom.equalTo(self.view).offset(-49-SafeAreaBottomHeight);
    }];
    
    
    
    self.passWordOldInputView = [CAInputView showLoginTypeInputView];
    self.passWordNewInputView = [CAInputView showLoginTypeInputView];
    
    [self.contentView addSubview:self.passWordOldInputView];
    [self.contentView addSubview:self.passWordNewInputView];
  
    NSArray * inputs = @[self.passWordOldInputView,self.passWordNewInputView];
    
    self.passWordNewInputView.inputView.secureTextEntry = YES;
    self.passWordOldInputView.inputView.secureTextEntry = YES;
    
    [inputs enumerateObjectsUsingBlock:^(CAInputView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            if (idx==0) {
                make.top.equalTo(self.contentView).offset(AutoNumber(55));
            }else{
                CAInputView* lastInput = inputs[idx-1];
                make.top.equalTo(lastInput.mas_bottom).offset(15);
            }
        }];
    }];

    
    self.saveButton = [CABaseButton buttonWithTitle:@"确认修改"];
    [self.contentView addSubview:self.saveButton];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 22;
    [self.saveButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@44);
        make.top.equalTo(self.passWordNewInputView.mas_bottom).offset(30);
    }];
    
    self.passWordOldInputView.notiLabel.text =  CALanguages(@"请输入旧密码");
    self.passWordNewInputView.notiLabel.text = CALanguages(@"请输入新密码");
   
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveButton.mas_bottom);
    }];
    
}
-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:@"textFieldDidChange"]) {
        if ([self.passWordOldInputView.inputView.text length]&&[self.passWordNewInputView.inputView.text length]) {
            self.saveButton.enabled = YES;
        }else{
            self.saveButton.enabled = NO;
        }
    }
}

-(void)sendButtonClick{
    
    [self.view endEditing:YES];
 
    NSDictionary * para = @{
        @"original_password": NSStringFormat(@"%@",self.passWordOldInputView.inputView.text),
        @"new_password": NSStringFormat(@"%@",self.passWordNewInputView.inputView.text)
    };
    
    [SVProgressHUD show];
    [CANetworkHelper POST:CAAPI_MEMBERS_UPDATE_PASSWORD parameters:para success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue] == 20000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
       
       
}

@end
