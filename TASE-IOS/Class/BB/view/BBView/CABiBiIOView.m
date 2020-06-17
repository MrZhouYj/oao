//
//  CABiBiIOView.m
//  TASE-IOS
//
//   9/20.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABiBiIOView.h"
#import "CAProgressView.h"
#import "CARowView.h"
#import "CABBMenuView.h"

#define lowColor HexRGB(0xe2e2ea)
#define highColor HexRGB(0xc7c8d7)

@interface CABiBiIOView()
<UITextFieldDelegate>
{
    CABBMenuView * _buyMenuView;
    CABBMenuView * _sellMenuView;
    
    UIView * _priceInputContentView;
    UIView * _numberInputContentView;
    
    UIButton * _addButton;
    UIButton * _cutButton;
    
    UITextField * _priceTextField;
    
    UILabel * _showPriceLabel;
    
    UITextField * _numberTextField;
    UILabel * _unitLabel;
    UILabel * _showNumberLabel;
    
    UILabel * _allPriceLabel;
    
    UIButton *_loginButton;
    
    NSTimer * _timer;
    
    
    UILabel * _limitLabel;
}

@property (nonatomic, strong) UIColor *currentColor;

@property (nonatomic, strong) CAProgressView *progressView;

@property (nonatomic, assign) NSInteger bid_currency_scale;
@property (nonatomic, assign) NSInteger ask_currency_scale;
@property (nonatomic, copy) NSString * ask_currency_amount;
@property (nonatomic, copy) NSString * bid_currency_amount;

@end

@implementation CABiBiIOView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];

        self.isFirstSetPriceStr = YES;
        self.tradeType = TradingBuy;
        [self initTitleMenuView];
        [self initSubViews];
        [self judgeLogin];
        
        [self languageDidChange];
    }
    return self;
}

-(CAProgressView *)progressView{
    if (!_progressView) {
        _progressView = [CAProgressView new];
        [self addSubview:_progressView];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    
    return _progressView;
}

-(void)languageDidChange{
      [_buyMenuView setTitle:CALanguages(@"买入")];
      [_sellMenuView setTitle:CALanguages(@"卖出")];
      _limitLabel.text = CALanguages(@"限价");
      [self changeNumberBanlanceDisplay];
      [self  judgeLogin];
      [self changeBusinessVolume];
      _numberTextField.placeholder = CALanguages(@"数量") ;
      _priceTextField.placeholder =CALanguages(@"价格");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initTitleMenuView{
   
    _buyMenuView = [CABBMenuView new];
    _sellMenuView = [CABBMenuView new];
    
  
    
    _buyMenuView.sell_or_buy = @"buy";
    _sellMenuView.sell_or_buy = @"sell";
    
    _buyMenuView.select = YES;
    _sellMenuView.select = NO;
    
    [self addSubview:_buyMenuView];
    [self addSubview:_sellMenuView];
    
    [_buyMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.equalTo(@35);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [_sellMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.width.equalTo(_buyMenuView);
    }];
}

-(void)setTradeType:(TradingType)tradeType{
    if (_tradeType==tradeType) {
        return;
    }
    _tradeType = tradeType;
    
    if (_tradeType==TradingSell) {
        _sellMenuView.select = YES;
        _buyMenuView.select = NO;
        self.currentColor = [UIColor decreaseColor];
        _priceTextField.text = @"0";
        
    }else{
        _buyMenuView.select = YES;
        _sellMenuView.select = NO;
        self.currentColor = [UIColor increaseColor];
        if (self.priceStr) {
            _priceTextField.text = self.priceStr;
        }
    }
    _numberTextField.text = @"";
    self.progressView.progress = 0;
    [self changeBusinessVolume];
    [self judgeLogin];
    [self changeNumberBanlanceDisplay];
    [self priceInputTextDidChange];
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:NSStringFromClass(CABBMenuView.class)]) {
        
        if ([userInfo isEqualToString:@"sell"]) {
            
            self.tradeType = TradingSell;
        }else{
            self.tradeType = TradingBuy;
        }
        
    }else if ([eventName isEqualToString:@"CAProgressDidChangeProgress"]) {
        float progress = [userInfo floatValue];
        NSString * max;
        if (self.tradeType==TradingBuy) {
            max = [self caculateMax];
        }else if(self.tradeType==TradingSell){
            max = self.ask_currency_amount;
        }
        if (!max.floatValue) {
            return;
        }
        
        NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:max];
        NSDecimalNumber * pro = [[NSDecimalNumber alloc] initWithFloat:progress];
        NSDecimalNumber * result = [amount decimalNumberByMultiplyingBy:pro];
        _numberTextField.text = [self Rounding:result afterPoint:self.ask_currency_scale];
        
        [self changeBusinessVolume];
    }
}

-(void)initSubViews{
    
//    rowView = [CARowView new];
//    [self addSubview:rowView];
//    kWeakSelf(_buyMenuView);
    
    
    _limitLabel = [UILabel new];
    [self addSubview:_limitLabel];
    [_limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(_buyMenuView.mas_bottom).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    _limitLabel.font = FONT_MEDIUM_SIZE(13);
//    rowView.titleColor =RGB(145,146,177);
//    rowView.titleFont =FONT_MEDIUM_SIZE(13);
//    rowView.tintColor =RGB(145,146,177);
//    rowView.rowHidden = YES;
//    rowView.up = NO;
   
    _priceInputContentView = [UIView new];
    [self addSubview:_priceInputContentView];
    [_priceInputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_limitLabel.mas_bottom).offset(10);
        make.height.equalTo(@38);
    }];
    _priceInputContentView.layer.borderColor = HexRGB(0xa0a1bb).CGColor;
    _priceInputContentView.layer.borderWidth = 0.5;
    
    [self creatPriceInputContentViewSubViews];
    
    _showPriceLabel = [UILabel new];
    [self addSubview:_showPriceLabel];
    _showPriceLabel.font = FONT_MEDIUM_SIZE(12);
    _showPriceLabel.textColor = RGB(165,166,191);
     kWeakSelf(_priceInputContentView);
    [_showPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weak_priceInputContentView);
        make.top.equalTo(weak_priceInputContentView.mas_bottom).offset(5);
    }];
    
    kWeakSelf(_showPriceLabel);
    _numberInputContentView = [UIView new];
    [self addSubview:_numberInputContentView];
    _numberInputContentView.layer.borderColor = HexRGB(0xa0a1bb).CGColor;
    _numberInputContentView.layer.borderWidth = 0.5;    
    [_numberInputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weak_priceInputContentView);
        make.right.equalTo(weak_priceInputContentView);
        make.top.equalTo(weak_showPriceLabel.mas_bottom).offset(10);
        make.height.equalTo(weak_priceInputContentView);
    }];
    
    _unitLabel = [UILabel new];
    [_numberInputContentView addSubview:_unitLabel];
    _unitLabel.font = FONT_MEDIUM_SIZE(13);
    _unitLabel.textColor = RGB(145,146,177);
    kWeakSelf(_numberInputContentView);
    _unitLabel.adjustsFontSizeToFitWidth = YES;
    _unitLabel.textAlignment = NSTextAlignmentRight;
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weak_numberInputContentView).offset(-10);
        make.width.equalTo(@50);
        make.centerY.equalTo(weak_numberInputContentView);
    }];
    
    kWeakSelf(_unitLabel);
    
    _numberTextField = [UITextField new];
    [_numberInputContentView addSubview:_numberTextField];
    _numberTextField.dk_textColorPicker = DKColorPickerWithKey(TextFieldInputColor);
    _numberTextField.font = FONT_MEDIUM_SIZE(13);
    
    _numberTextField.delegate = self;
    [_numberTextField addTarget:self action:@selector(numberInputTextDidChange) forControlEvents:UIControlEventEditingChanged];
    _numberTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weak_numberInputContentView).offset(10);
        make.height.equalTo(weak_numberInputContentView);
        make.right.equalTo(weak_unitLabel.mas_left).offset(-15);
    }];
    
    
    _showNumberLabel = [UILabel new];
    [self addSubview:_showNumberLabel];
    _showNumberLabel.font = FONT_MEDIUM_SIZE(12);
    _showNumberLabel.textColor = RGB(165,166,191);
    
    [_showNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weak_numberInputContentView.mas_left);
        make.top.equalTo(weak_numberInputContentView.mas_bottom).offset(5);
    }];
    kWeakSelf(_showNumberLabel);
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(weak_showNumberLabel.mas_bottom).offset(20);
        make.height.equalTo(@40);
    }];
    
    _allPriceLabel = [UILabel new];
    [self addSubview:_allPriceLabel];
    _allPriceLabel.font = ROBOTO_FONT_MEDIUM_SIZE(13);
    _allPriceLabel.textColor = HexRGB(0x191d26);
    [_allPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weak_numberInputContentView);
        make.top.equalTo(self.progressView.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_loginButton];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
    kWeakSelf(_allPriceLabel);
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@40);
        make.top.equalTo(weak_allPriceLabel.mas_bottom).offset(10);
    }];
    [_loginButton addTarget:self action:@selector(buyOrSellAction) forControlEvents:UIControlEventTouchUpInside];
    
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 2;
    [self changeBusinessVolume];
    self.currentColor = [UIColor increaseColor];
}


-(void)setAsk_code:(NSString *)ask_code{
    _ask_code = ask_code;
    _unitLabel.text = ask_code;
    [self judgeLogin];
}

-(void)setMember_assets:(NSDictionary *)member_assets{
    _member_assets = member_assets;
    if (_member_assets) {
        NSLog(@"%@",_member_assets);
        self.bid_currency_amount = member_assets[@"bid_currency_amount"];
        self.ask_currency_amount = member_assets[@"ask_currency_amount"];
        [self changeNumberBanlanceDisplay];
    }
}

-(void)setPrecision:(NSDictionary *)precision{
    _precision = precision;
    
    self.bid_currency_scale = [NSStringFormat(@"%@",precision[@"bid_currency_scale"]) integerValue];

    self.ask_currency_scale = [NSStringFormat(@"%@",precision[@"ask_currency_scale"]) integerValue];

}

-(void)changeNumberBanlanceDisplay{
    
    if ([CAUser currentUser].isAvaliable&&(self.bid_currency_amount.length||self.ask_currency_amount.length)) {
        _showNumberLabel.text = NSStringFormat(@"%@ %@ %@",CALanguages(@"可用"),self.tradeType==TradingBuy?self.bid_currency_amount:self.ask_currency_amount,self.tradeType==TradingBuy?self.bid_code:self.ask_code);
        if (self.tradeType==TradingBuy) {
            
            [self getBuyMaxNumber];
            
        }else{
            
             self.progressView.maxNumber = NSStringFormat(@"%@ %@",[self Rounding:[NSDecimalNumber decimalNumberWithString:self.ask_currency_amount] afterPoint:self.ask_currency_scale],self.ask_code);
        }
    }else{
        _showNumberLabel.text = NSStringFormat(@"%@--",CALanguages(@"可用"));
    }
     
}

-(void)getBuyMaxNumber{
    
    if (self.bid_currency_amount.length) {
        self.progressView.maxNumber = NSStringFormat(@"%@ %@",[self caculateMax],self.ask_code);
    }
    
}

-(NSString *)caculateMax{
    
    NSString * unitPrice = _priceTextField.text;
    if (!unitPrice.length||!self.bid_currency_amount.length) {
        return [self getDecimalLimiteZero:self.bid_currency_scale];
    }
    if (unitPrice.floatValue<=0) {
        return @"0";
    }
    NSDecimalNumber * unitPriceDecimal = [NSDecimalNumber decimalNumberWithString:unitPrice];
    NSDecimalNumber * numberDecimal = [NSDecimalNumber decimalNumberWithString:self.bid_currency_amount];
    NSDecimalNumber * result = [numberDecimal decimalNumberByDividingBy:unitPriceDecimal];
    NSString * max = [self Rounding:result afterPoint:self.ask_currency_scale];
    
    return max;
}

-(void)judgeLogin{

    CAUser * user = [CAUser currentUser];
    if (user.isAvaliable) {
        
        if (_buyMenuView.isSelect) {
            [_loginButton setTitle:NSStringFormat(@"%@ %@",CALanguages(@"买入"),[self.ask_code uppercaseString]) forState:UIControlStateNormal];
            self.tradeType = TradingBuy;
        }else{
            [_loginButton setTitle:NSStringFormat(@"%@ %@",CALanguages(@"卖出"),[self.ask_code uppercaseString]) forState:UIControlStateNormal];
            self.tradeType = TradingSell;
        }
        
    }else{
        
        self.bid_currency_amount = @"";
        self.ask_currency_amount = @"";
        [self changeNumberBanlanceDisplay];
        
       [_loginButton setTitle:CALanguages(@"登录")  forState:UIControlStateNormal];
    }
}



-(void)creatPriceInputContentViewSubViews{
    
    kWeakSelf(_priceInputContentView);
    
    _addButton = [self creatAddButton:@"＋" tag:1];
    [_priceInputContentView addSubview:_addButton];
    _cutButton = [self creatAddButton:@"－" tag:0];
    [_priceInputContentView addSubview:_cutButton];
    
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(weak_priceInputContentView);
        make.width.equalTo(weak_priceInputContentView.mas_height);
    }];
    kWeakSelf(_addButton);
    [_cutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.width.equalTo(weak_priceInputContentView.mas_height);
        make.right.equalTo(weak_addButton.mas_left).offset(-0.5);
    }];
    
    UIView * lineView = [UIView new];
    [_priceInputContentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weak_addButton.mas_left);
        make.width.equalTo(@0.5);
        make.height.equalTo(weak_priceInputContentView.mas_height).multipliedBy(0.4);
        make.centerY.equalTo(weak_priceInputContentView);
    }];
    
    UIView * lineView2 = [UIView new];
    [_priceInputContentView addSubview:lineView2];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    kWeakSelf(_cutButton);
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weak_cutButton.mas_left);
        make.width.equalTo(@0.5);
        make.height.equalTo(weak_priceInputContentView.mas_height);
        make.centerY.equalTo(weak_priceInputContentView);
    }];
    
    _priceTextField = [UITextField new];
    [_priceInputContentView addSubview:_priceTextField];
    _priceTextField.dk_textColorPicker = DKColorPickerWithKey(TextFieldInputColor);
    
    _priceTextField.font = FONT_MEDIUM_SIZE(13);
    _priceTextField.delegate = self;
    _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weak_priceInputContentView).offset(10);
        make.height.equalTo(weak_priceInputContentView);
        make.right.equalTo(lineView2).offset(-10);
    }];
    [_priceTextField addTarget:self action:@selector(priceInputTextDidChange) forControlEvents:UIControlEventEditingChanged];

}

-(UIButton*)creatAddButton:(NSString*)title tag:(NSInteger)tag{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setSelected:YES];
    button.tag = tag;
    [button setTitleColor:highColor forState:UIControlStateNormal];
    button.titleLabel.font =   FONT_SEMOBOLD_SIZE(21);
    
    [button addTarget:self action:@selector(changePriceAction:) forControlEvents:UIControlEventTouchUpInside];

    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.5;
    [button addGestureRecognizer:longPress];
    
    return button;
}

-(void)changePriceNumber:(UIButton*)btn{
    
}

-(UIButton*)creatMenuButton:(NSString*)title{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];

    button.titleLabel.font = FONT_MEDIUM_SIZE(15);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [button setTitleColor:HexRGB(0x191d26) forState:UIControlStateSelected];
    [button setTitleColor:HexRGB(0x9192b1) forState:UIControlStateNormal];
    
//    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)setCurrentColor:(UIColor *)currentColor{
    _currentColor = currentColor;
    
    _loginButton.backgroundColor = currentColor;
    
    self.progressView.displayColor = currentColor;
    
    if (_priceTextField.isFirstResponder) {
        _priceInputContentView.layer.borderColor = currentColor.CGColor;
    }
    if (_numberTextField.isFirstResponder) {
        _numberInputContentView.layer.borderColor = currentColor.CGColor;
    }
}

-(void)setPriceStr:(NSString *)priceStr{
    BOOL needAnimation = YES;
    if (!_priceStr.length) {
        needAnimation = NO;
    }
    _priceStr = priceStr;
    _priceTextField.text = NSStringFormat(@"%@",_priceStr);
    [self priceInputTextDidChange];
    [_priceTextField.layer removeAllAnimations];
    
    if (needAnimation) {
        CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue = [NSNumber numberWithFloat:1];
        aniScale.toValue = [NSNumber numberWithFloat:1.2];
        aniScale.duration = 0.1;
        aniScale.removedOnCompletion = NO;
        aniScale.repeatCount = 1;
        [_priceTextField.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField==_priceTextField) {
        _priceInputContentView.layer.borderColor = self.currentColor.CGColor;
    }else if (textField==_numberTextField) {
        _numberInputContentView.layer.borderColor = self.currentColor.CGColor;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField==_priceTextField) {
        _priceInputContentView.layer.borderColor = HexRGB(0xa0a1bb).CGColor;
    }else if (textField==_numberTextField) {
        _numberInputContentView.layer.borderColor = HexRGB(0xa0a1bb).CGColor;
    }
}


-(void)priceInputTextDidChange{
    
    //获取当前汇率 计算成需要显示的金额
    if (self.bid_rate.count<3) {
        return;
    }
    NSString * price = _priceTextField.text;
    if (price.floatValue<=0) {
        _cutButton.enabled = NO;
        [_cutButton setTitleColor:lowColor forState:UIControlStateNormal];
    }else{
        _cutButton.enabled = YES;
        [_cutButton setTitleColor:highColor forState:UIControlStateNormal];
    }
    NSString * showPrice = NSStringFormat(@"≈%.2f %@",price.floatValue*[self.bid_rate[0] floatValue],self.bid_rate[2]);
    _showPriceLabel.text = showPrice;
    if (self.tradeType==TradingBuy) {
        _priceStr = price;
        [self getBuyMaxNumber];
    }else{
        
    }
    if (_numberTextField.text.length) {
        [self changeBusinessVolume];
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {
        return YES;
    }
    NSString * textString = textField.text;
    NSRange pointRange = [textString rangeOfString:@"."];
    
    if (pointRange.location != NSNotFound) {
        
        //最多输入一个小数点
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        
        NSInteger pointAfterMaxLength = 0;
        if (textField==_priceTextField) {
            pointAfterMaxLength = [self.precision[@"ask_currency_scale"] intValue];//ask 最多小数点后的位数
        }else{
            pointAfterMaxLength = [self.precision[@"bid_currency_scale"] intValue];// bid zui多的小数点位数
        }
        
        NSString * pointAfterString = [textString substringFromIndex:pointRange.location];
        if (pointAfterString.length>pointAfterMaxLength) {
            return NO;
        }
        
    }else{
        NSInteger pointAfterMaxLength = 0;
        if (textField==_priceTextField) {
            pointAfterMaxLength = [self.precision[@"ask_currency_precision"] intValue];//ask 最多小数点后的位数
        }else{
            pointAfterMaxLength = [self.precision[@"bid_currency_precision"] intValue];// bid zui多的小数点位数
        }
        if (textString.length>pointAfterMaxLength) {
            return NO;
        }
    }
    
    return YES;
}


-(void)numberInputTextDidChange{
    NSString * number = _numberTextField.text;
    if (!number.length) {
         number = @"0";
    }
    NSString * max;
    if (self.tradeType==TradingBuy) {
        if (![self.bid_currency_amount floatValue]) {
            return;
        }
        max = [self caculateMax];
    }else{
        if (![self.ask_currency_amount floatValue]) {
            return;
        }
        max = self.ask_currency_amount;
    }
    
    NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:max];
    NSDecimalNumber * numberDecimal = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber * result = [numberDecimal decimalNumberByDividingBy:amount];
    self.progressView.progress = result.doubleValue;
     if (_priceTextField.text.length) {
        [self changeBusinessVolume];
    }
}
#pragma mark 改变成交额的显示
- (void)changeBusinessVolume{
    
    NSString * priceShow = @"--";
    
    NSString * price = _priceTextField.text;
    NSString * number = _numberTextField.text;
    if (price.length&&number.length) {
        
        NSDecimalNumber * priceDecimal = [NSDecimalNumber decimalNumberWithString:price];
        NSDecimalNumber * numberDecimal = [NSDecimalNumber decimalNumberWithString:number];
        NSDecimalNumber * result = [priceDecimal decimalNumberByMultiplyingBy:numberDecimal];
        NSString * price = [self Rounding:result afterPoint:self.bid_currency_scale];
        priceShow = NSStringFormat(@"%@%@",price,self.bid_code);
        [self judgeIsEnable];
    }
    
    _allPriceLabel.text = NSStringFormat(@"%@ %@",CALanguages(@"交易额"),priceShow);
}

-(void)longPressAction:(UIGestureRecognizer*)tap{
    
    [[tap view] tag];
    if (tap.state==UIGestureRecognizerStateBegan) {
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledAutoReleaseTimerWithTimeInterval:0.05 target:self selector:@selector(changePriceGesture:) userinfo:@([[tap view] tag]) repeats:YES];
        [_timer fire];
        
    }else if (tap.state==UIGestureRecognizerStateEnded){
        
       if (_timer) {
           [_timer invalidate];
           _timer = nil;
       }
    }
}

-(void)changePriceGesture:(NSTimer*)timer{
    
    [self changePriceTextField:[[timer userInfo] boolValue]];
    
}
-(void)changePriceAction:(UIButton*)button{
    
    [self changePriceTextField:button.tag];
}

-(void)changePriceTextField:(BOOL)isAdd{

    NSString * price = _priceTextField.text;
    if (!price.length) {
        price = @"0";
    }
    NSString * changeNumber = [self getDecimal:self.bid_currency_scale];
    
    NSDecimalNumber * priceDecimalNumber = [NSDecimalNumber decimalNumberWithString:price];
    NSDecimalNumber * changeDecimalNumber = [NSDecimalNumber decimalNumberWithString:changeNumber];
     
    NSDecimalNumber * result;
    
    if (isAdd) {
        result = [priceDecimalNumber decimalNumberByAdding:changeDecimalNumber];
    }else{
        result = [priceDecimalNumber decimalNumberBySubtracting:changeDecimalNumber];
        if (result.doubleValue<=0) {
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
        }
    }

    _priceTextField.text = [self Rounding:result afterPoint:self.bid_currency_scale];
    
    [self priceInputTextDidChange];
}

-(NSString*)getDecimal:(NSInteger)length{
    
    if (length==0) {
        return @"1";
    }
    
    NSString * number = @"0.";
    for (int i=0; i<length-1; i++) {
        number = [number stringByAppendingString:@"0"];
    }
    number = [number stringByAppendingString:@"1"];
    return number;
}

-(NSString*)getDecimalLimiteZero:(NSInteger)length{
    NSString * number = @"0.";
    for (int i=0; i<length; i++) {
        number = [number stringByAppendingString:@"0"];
    }
    return number;
}


- (NSString*)Rounding:(NSDecimalNumber*)number afterPoint:(NSInteger)position
{
     NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode: NSRoundPlain scale: position raiseOnExactness: NO raiseOnOverflow: NO raiseOnUnderflow:YES raiseOnDivideByZero: NO];
     NSDecimalNumber *resultNumber = [number decimalNumberByRoundingAccordingToBehavior:handler];
     return [NSString stringWithFormat:@"%@",resultNumber];
}

-(BOOL)judgeIsEnable{
    
    NSString * price = _priceTextField.text;
    NSString * number = _numberTextField.text;
    
    if (self.tradeType==TradingSell) {
        if (number.floatValue>self.ask_currency_amount.floatValue) {
            Toast(CALanguages(@"可用量不足"));
            return NO;
        }
    }else{
       
        if (price.floatValue*number.floatValue>self.bid_currency_amount.floatValue) {
            Toast(CALanguages(@"可用量不足"));
            return NO;
        }
    }
    
    return YES;
}


-(void)buyOrSellAction{
    
    if (![CAUser currentUser].isAvaliable) {
        //跳去登录
        NSLog(@"登录");
        [self.delegata gotoLoginController];
        return;
    }
    
    NSString * price = _priceTextField.text;
    NSString * number = _numberTextField.text;
    if (!price.length||!price.floatValue) {
        Toast(CALanguages(@"请输入价格"));
        return;
    }
    if (!number.length||!number.floatValue) {
        Toast(CALanguages(@"请输入数量"));
        return;
    }
    
    if (![self judgeIsEnable]) {
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"price":NSStringFormat(@"%@",price),
        @"volume":NSStringFormat(@"%@",number),
        @"market_id":NSStringFormat(@"%@",self.market_id),
        @"ask_or_bid":NSStringFormat(@"%@",self.tradeType==TradingBuy?@"bid":@"ask")
    };

    [self endEditing:YES];
    [CANetworkHelper MATCHERPOST:[NSString stringWithFormat:@"%@%@",self.market_id,CAAPI_CRYPTO_TO_CRYPTO_CREATE_ORDER] parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue]==20000) {
         
            self->_numberTextField.text = @"";
            self.progressView.progress = 0;
            [self changeBusinessVolume];
            
        }
        Toast(responseObject[@"message"]);
       
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
