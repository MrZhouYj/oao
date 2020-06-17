//
//  CAInputView.m
//  TASE-IOS
//
//   10/25.
//  Copyright © 2019 CA. All rights reserved.
//

NSString * const CAInputViewSendMessageSuccess = @"CAInputViewSendMessageSuccess";


#import "CAInputView.h"

@interface CAInputView()
<UITextFieldDelegate>

{
    NSTimer* _timer;
    int _number;
}

@property (nonatomic, assign) CAInputViewType myType;
@property (nonatomic, assign) BOOL isUseInputTextWhileSendMessage;

@end

@implementation CAInputView

+(instancetype)showWithType:(CAInputViewType)type{
    
    CAInputView * input = [CAInputView  new];
    
    input.myType = type;
    
    return input;
}

+(instancetype)showLoginTypeInputView{
    
    CAInputView * input = [CAInputView  new];
    
    input.myType = CAInputViewLogin;
    
    return input;
}

-(void)setMyType:(CAInputViewType)myType{
    _myType = myType;
    [self creatUI];
    
}

-(instancetype)init{
    self= [super init];
    if (self) {
        self.needCheck = NO;
        self.isUseInputTextWhileSendMessage = YES;
        self.maxNumber = NSStringFormat(@"%f",MAXFLOAT);
        self.minNumber = 0;
        self.contentType = CAInputViewContentNone;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_setFirstResponder)]];
       
    }
    return self;
}

-(void)event_setFirstResponder{
    [self.inputView becomeFirstResponder];
}

-(void)setMobile:(NSString *)mobile{
    _mobile =  mobile;
    self.isUseInputTextWhileSendMessage = NO;
}


-(void)creatUI{
    
    if (self.myType==CAInputViewLeftBigImageType) {
        self.leftBigImageView = [UIImageView new];
        [self addSubview:self.leftBigImageView];
        [self.leftBigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.width.height.equalTo(self.mas_height).multipliedBy(0.8);
        }];
    }
    
    self.notiLabel = [UILabel new];
    [self addSubview:self.notiLabel];
    self.notiLabel.font = FONT_MEDIUM_SIZE(15);
    self.notiLabel.dk_textColorPicker = DKColorPickerWithKey(GrayTextColot_a3a4bd);
        
    
    [self.notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        if (_leftBigImageView) {
            make.left.equalTo(self.leftBigImageView.mas_right).offset(15);
        }else{
            make.left.equalTo(self);
        }
        make.top.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    
    self.inputView = [UITextField new];
    [self addSubview:self.inputView];
    self.inputView.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    self.inputView.font = FONT_SEMOBOLD_SIZE(15);
    self.inputView.delegate  = self;
    self.inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.inputView addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.inputView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lineView  = [UIView new];
    [self addSubview:self.lineView ];
    self.lineView .dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [self.lineView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.notiLabel);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.inputView);
    }];
    
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_bottom);
    }];
    
}


-(UILabel *)chooseCountryLabel{
    if (!_chooseCountryLabel) {
        _chooseCountryLabel = [UILabel new];
        [self.leftView addSubview:_chooseCountryLabel];
        _chooseCountryLabel.font = FONT_SEMOBOLD_SIZE(14);
        [_chooseCountryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@45);
            make.centerY.equalTo(self.leftView);
            make.height.equalTo(self.leftView);
        }];
        _chooseCountryLabel.text = @"+86";
        _chooseCountryLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        
        UIButton * button = [UIButton new];
        [self.leftView addSubview:button];
        [button setImage:IMAGE_NAMED(@"row_down") forState:UIControlStateNormal];
        button.tintColor = HexRGB(0xa3a4bd);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.enabled = NO;
        _chooseCountryLabel.userInteractionEnabled = YES;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.leftView).offset(-5);
            make.centerY.equalTo(self.leftView);
            make.width.height.equalTo(@6);
        }];
    }
    return _chooseCountryLabel;
}


-(void)layoutSubviews{
    
    if (_sendButton&&!_sendButton.isHidden) {
        CGSize size = [self.sendButton.titleLabel sizeThatFits:CGSizeMake(100, 28)];
        size.width = size.width<55?55:size.width;
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.height.equalTo(@28);
            make.width.mas_equalTo(size.width+15);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    
    if (_leftView&&!_leftView.isHidden) {
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.height.equalTo(@27);
            make.top.equalTo(self.notiLabel.mas_bottom).offset(5);
            make.width.equalTo(@60);
        }];
    }
    
    if (self.myType==CAInputViewLeftNotiRightNotiType) {
        [self.rightNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_leftView&&!_leftView.isHidden?_leftView.mas_right:self.notiLabel.mas_left);
        make.top.equalTo(self.notiLabel.mas_bottom).offset(5);
        if (_sendButton&&!_sendButton.isHidden) {
            make.right.equalTo(_sendButton.mas_left).offset(-10);
        }else if(self.myType==CAInputViewLeftNotiRightNotiType){
            make.right.equalTo(self.rightNotiLabel.mas_left).offset(-10);
        }else if(self.rightView){
            make.right.equalTo(self.rightView.mas_left).offset(-5);
        }else{
            make.right.equalTo(self).offset(-15);
        }
        make.height.equalTo(@27);
    }];
}

-(void)setRightView:(UIView *)rightView{
    _rightView = rightView;
    [self addSubview:_rightView];
    [self setNeedsLayout];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.lineView.backgroundColor  = HexRGB(0x006cdb);
    self.notiLabel.textColor = HexRGB(0x006cdb);
    
    return YES;
}

-(void)setNotiLabelNormalColor:(UIColor *)notiLabelNormalColor{
    _notiLabelNormalColor = notiLabelNormalColor;
    self.notiLabel.textColor = notiLabelNormalColor;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    self.lineView.backgroundColor  = HexRGB(0xededed);
    if (self.notiLabelNormalColor) {
        self.notiLabel.textColor = self.notiLabelNormalColor;
    }else{
        self.notiLabel.dk_textColorPicker = DKColorPickerWithKey(GrayTextColot_a3a4bd);
    }
    
}


-(void)textFieldDidChange{
    NSLog(@"wo");
    if (_sendButton&&!_sendButton.isHidden) {
               
         if (self.inputView.text.length) {
             
             switch (self.contentType) {
                 case CAInputViewContentEmailType:
                     [self setSendEnable:[CommonMethod validateEmail:self.inputView.text]];
                     break;
                 case CAInputViewContentPhoneType:
                     
                     [self setSendEnable:[CommonMethod validataPhone:self.inputView.text]];
                     break;
                 default:
                     break;
             }
        }else{
          [self setSendEnable:NO];
        }
    }
    
    if (_maxNumber>=0) {
        if (self.inputView.text.doubleValue>_maxNumber.doubleValue) {
            self.inputView.text = NSStringFormat(@"%@",_maxNumber);
        }else if (self.inputView.text.floatValue<_minNumber.doubleValue){
            self.inputView.text = NSStringFormat(@"%@",_minNumber);
        }
    }
    
    [self routerEventWithName:@"textFieldDidChange" userInfo:@{
        @"item":self,
        @"text":NSStringFormat(@"%@",self.inputView.text)
    }];
}

-(void)setSendEnable:(BOOL)isEnable{
    
    if (isEnable) {
        [_sendButton setBackgroundColor:HexRGB(0x006cdb)];
        [_sendButton setTitleColor:HexRGB(0xf8fbff) forState:UIControlStateNormal];
    }else{
        [_sendButton setBackgroundColor:HexRGB(0xebf3fc)];
        [_sendButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    }
    _sendButton.enabled = isEnable;
    
}

-(UIView *)leftView{
    if (!_leftView) {
        _leftView = [UIView new];
        [self addSubview:_leftView];
    }
    return _leftView;
}

-(UILabel *)rightNotiLabel{
    if (!_rightNotiLabel) {
        _rightNotiLabel = [UILabel new];
        [self addSubview:_rightNotiLabel];
    }
    return _rightNotiLabel;
}

-(void)setSendTitle:(NSString *)sendTitle{
    _sendTitle = sendTitle;

    [self.sendButton setTitle:sendTitle forState:UIControlStateNormal];
}

-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_sendButton];
        [_sendButton setTitle:CALanguages(@"发送") forState:UIControlStateNormal];
        [_sendButton.titleLabel  sizeToFit];
        [_sendButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        _sendButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 14;
        _sendButton.hidden = YES;
        [self setSendEnable:NO];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _number = 60;
        
    }
    return _sendButton;
}

-(void)sendButtonClick{
    
    if (self.needCheck) {
        [self routerEventWithName:@"CAInputView_sendMessage" userInfo:nil];
    }else{
        [self send_sms_validation_code:nil];
    }
}

-(void)send_sms_validation_code:(NSDictionary*)result{
    
    NSString * mobile = @"";
    if (!self.send_sms_key) {
        self.send_sms_key = @"mobile";
    }
    if (self.isUseInputTextWhileSendMessage) {
        mobile = self.inputView.text;
    }else{
        mobile = self.mobile;
    }
   
    if (!mobile.length) {
        NSLog(@"缺少参数");
        return;
    }
    NSDictionary * para = @{
        self.send_sms_key:mobile,
    };
    NSMutableDictionary * mutPara = [[NSMutableDictionary alloc] initWithDictionary:para];
    if (result[@"geetest_challenge"]) {
        [mutPara setValue:result[@"geetest_challenge"] forKey:@"geetest_challenge"];
    }
    if (result[@"geetest_validate"]) {
        [mutPara setValue:result[@"geetest_validate"] forKey:@"geetest_validate"];
    }
    if (result[@"geetest_seccode"]) {
        [mutPara setValue:result[@"geetest_seccode"] forKey:@"geetest_seccode"];
    }
    if (self.country_code) {
        [mutPara setValue:self.country_code forKey:@"country_code"];
    }
     
     
     [CANetworkHelper POST:self.requestUrl parameters:mutPara success:^(id responseObject) {
         [SVProgressHUD dismiss];
         if (responseObject[@"message"]) {
             Toast(responseObject[@"message"]);
         }
         
         if ([responseObject[@"code"] integerValue]==20000){
             [self performSelectorOnMainThread:@selector(startFire) withObject:nil waitUntilDone:NO];
             [self routerEventWithName:CAInputViewSendMessageSuccess userInfo:nil];
             self.sendButton.enabled = NO;
         }
         
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];
}



-(void)startSendMessageWithGT3Result:(NSDictionary *)result{
    
    [self send_sms_validation_code:result];
}

-(void)startFire{
    
     _sendButton.enabled = NO;
    
     _timer = [NSTimer scheduledAutoReleaseTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userinfo:nil repeats:YES];
     [_timer fire];
}

-(void)handleTimer{
    
    [_sendButton setTitle:[NSString stringWithFormat:@"%d",_number] forState:UIControlStateNormal];
    
    if (_number==0) {
        _sendButton.enabled = YES;
        [_sendButton setTitle:CALanguages(@"发送") forState:UIControlStateNormal];
        _number = 60;
        [_timer invalidate];
        _timer = nil;
        self.sendButton.enabled = YES;
    }
    _number--;
}

-(void)dealloc{
    
    if (_timer) {
        [_timer invalidate];
         _timer = nil;
    }
}

@end
