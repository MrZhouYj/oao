//
//  CAEditLegalNicknameViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/12.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEditLegalNicknameViewController.h"

@interface CAEditLegalNicknameViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UITextField * inputTextFieldView;
@property (nonatomic, strong) UIButton * actionButton;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation CAEditLegalNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"修改法币交易昵称";
    
    [self initSubViews];
}

-(void)initSubViews{
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(self.navcBar.mas_bottom).offset(40);
        make.width.height.equalTo(@20);
    }];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.iconImageView);
        make.width.equalTo(@70);
        make.height.equalTo(@28);
    }];
    [self.inputTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.actionButton.mas_left).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.iconImageView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_left);
        make.right.equalTo(self.actionButton.mas_left);
        make.top.equalTo(self.inputTextFieldView.mas_bottom).offset(5);
        make.height.equalTo(@1);
    }];
    
    [self.inputTextFieldView becomeFirstResponder];
    [self getNickName];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.lineView.backgroundColor  = HexRGB(0x006cdb);
    self.iconImageView.image = IMAGE_NAMED(@"edit_hlight");
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    self.lineView.backgroundColor  = HexRGB(0xededed);
    self.iconImageView.image = IMAGE_NAMED(@"edit_normal");
}

-(void)textFieldDidChange{
    
    NSString * value = self.inputTextFieldView.text;
    if (value.length) {
        [_actionButton setBackgroundColor:HexRGB(0x006cdb)];
        _actionButton.enabled = YES;
    }else{
        [_actionButton setBackgroundColor:HexRGB(0xededed)];
        _actionButton.enabled = NO;
    }
}

-(void)getNickName{
    
//    /mobile_api/v2/otc/edit_nick_name
    [SVProgressHUD show];
    
    [CANetworkHelper GET:CAAPI_OTC_EDIT_NICK_NAME parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue]==20000) {
            if ([responseObject[@"data"] isKindOfClass:[NSString class]]&&[responseObject[@"data"] length]) {
                self.inputTextFieldView.text = responseObject[@"data"];
            }
        }else{
            Toast(responseObject[@"message"]);
        }
        
    } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
        
    }];
}

-(void)saveAction{
    
    NSString * nikeName = self.inputTextFieldView.text;
    if (!nikeName.length) {
        return;
    }
    NSDictionary * dic = @{
        @"nick_name":nikeName
    };
    [SVProgressHUD show];
    
    [CANetworkHelper POST:CAAPI_OTC_UPDATE_NICK_NAME parameters:dic success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([ responseObject[@"code"] integerValue]==20000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CAUserDidChangedUserInfomationNotifacation object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
        
    }];
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [self.view addSubview:_lineView];
        _lineView.backgroundColor  = HexRGB(0x006cdb);
    }
    return _lineView;
}

-(UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:_actionButton];
        _actionButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _actionButton.layer.masksToBounds = YES;
        _actionButton.layer.cornerRadius = 2;
        [_actionButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [_actionButton setTitle:CALanguages(@"保存")  forState:UIControlStateNormal];
        [_actionButton setBackgroundColor:HexRGB(0xededed)];
    }
    return _actionButton;
}

-(UITextField *)inputTextFieldView{
    if (!_inputTextFieldView) {
        _inputTextFieldView = [UITextField new];
        [self.view addSubview:_inputTextFieldView];
        _inputTextFieldView.font = FONT_MEDIUM_SIZE(15);
        _inputTextFieldView.delegate = self;
        [_inputTextFieldView addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputTextFieldView;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.view addSubview:_iconImageView];
        _iconImageView.image = IMAGE_NAMED(@"edit_hlight");
    }
    return _iconImageView;
}


@end
