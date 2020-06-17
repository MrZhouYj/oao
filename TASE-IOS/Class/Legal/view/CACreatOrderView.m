//
//  CACreatOrderView.m
//  TASE-IOS
//
//   10/14.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CACreatOrderView.h"

static NSString * const trade_amount = @"by_amount";
static NSString * const trade_price = @"by_price";

@interface CACreatOrderView()
<CABaseAnimationViewDelegate,
UITextFieldDelegate>
{
    CGRect _originFrame;
    BOOL _isBackGround;
}

@property (nonatomic, copy) NSString * trade_type;

@property (nonatomic, assign) double  min_limite;
@property (nonatomic, assign) double  max_limite;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * currencyIconImgaeView;
@property (nonatomic, strong) UILabel * unitPriceLabel;
@property (nonatomic, strong) UILabel * unitTypeLabel;
@property (nonatomic, strong) UILabel * limitPriceLabel;
@property (nonatomic, strong) UILabel * tradeNumberLabel;
@property (nonatomic, strong) UILabel * payPriceLabel;
@property (nonatomic, strong) UIButton *allButton;

@property (nonatomic, strong) UIButton *priceChooseButton;
@property (nonatomic, strong) UIButton *numberChooseButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextField * inputTf;

@end

@implementation CACreatOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self CornerTop];

        _isBackGround = NO;
        self.order_price = @"0";
        self.order_amount = @"0";
        self.delegate = self;
        self.trade_type = trade_price;
        [self initSubViews];
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
        [self.priceChooseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        // 键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
              // 键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}
-(void)DidBecomeActive{
    _isBackGround = NO;
}
-(void)didEnterBackground{
    _isBackGround = YES;
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度

    if (_isBackGround) {
        return;
    }
    
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _originFrame = self.frame;
    CGRect originFrame = self.frame;
    originFrame.origin.y-=frame.size.height-SafeAreaBottomHeight;
    
    [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]  animations:^{
        self.frame = originFrame;
    }];
    
}



- (void)keyboardWillBeHiden:(NSNotification *)notification
{
   [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]  animations:^{
       self.frame = self->_originFrame;
   }];
}

-(void)setOriginDictionary:(NSDictionary *)originDictionary{
    _originDictionary = originDictionary;
    
    NSString * trade_type = originDictionary[@"trade_type"];
    
    self.titleLabel.text = NSStringFormat(@"%@%@",CALanguages([trade_type isEqualToString:@"buy"]?@"购买":@"卖出"),[originDictionary[@"currency_code"] uppercaseString]);
    
    NSString * price = NSStringFormat(@"%@",originDictionary[@"price"]);
    NSString * min_limit = NSStringFormat(@"%@",originDictionary[@"min_limit"]);
    NSString * max_limit = NSStringFormat(@"%@",originDictionary[@"max_limit"]);
    
    self.unitPriceLabel.text = NSStringFormat(@"%@",[price formatterDecimalString]);
    [self.currencyIconImgaeView loadImage:originDictionary[@"currency_icon"]];
    self.limitPriceLabel.text = NSStringFormat(@"%@ %@ - %@",CALanguages(@"限额"),[min_limit formatterDecimalString],[max_limit formatterDecimalString]);
    self.tradeNumberLabel.text = NSStringFormat(@"%@%.6f %@",CALanguages(@"交易数量"),self.order_amount.floatValue,[originDictionary[@"currency_code"] uppercaseString]);
    self.payPriceLabel.text = [NSStringFormat(@"%@",self.order_price) formatterDecimalString];
    self.min_limite = [originDictionary[@"min_limit"] doubleValue];
    self.max_limite = [originDictionary[@"max_limit"] doubleValue];
    
    [self.allButton setTitle:CALanguages([trade_type isEqualToString:@"buy"]?@"全部买入":@"全部卖出") forState:UIControlStateNormal];
    
}

-(UIView*)creatTopView{
    
    
    UIView * titleView = [UIView new];
    [self addSubview:titleView];
    titleView.backgroundColor = HexRGB(0xf6f6fa);
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@82);
    }];
    
    
    
    
    UILabel * titleLabel = [UILabel new];
    [titleView addSubview:titleLabel];
    titleLabel.font =   FONT_SEMOBOLD_SIZE(20);
    titleLabel.textColor = HexRGB(0x191d26);
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(15);
        make.top.equalTo(titleView).offset(20);
    }];
    
    
    UILabel * priceNotiLabel = [UILabel new];
    [titleView addSubview:priceNotiLabel];
    priceNotiLabel.font = FONT_REGULAR_SIZE(14);
    priceNotiLabel.textColor = HexRGB(0x191d26);
    priceNotiLabel.text = CALanguages(@"单价");
    [priceNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
    
    
    UILabel * priceLabel = [UILabel new];
    [titleView addSubview:priceLabel];
    priceLabel.font = FONT_REGULAR_SIZE(14);
    priceLabel.textColor = HexRGB(0x1881d3);
    self.unitPriceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceNotiLabel.mas_right).offset(2);
        make.centerY.equalTo(priceNotiLabel);
    }];
    
    
    
    UIImageView * rightImageView = [UIImageView new];
    [titleView addSubview:rightImageView];
    self.currencyIconImgaeView = rightImageView;
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView).offset(-15);
        make.centerY.equalTo(titleView);
        make.width.height.equalTo(titleView.mas_height).multipliedBy(0.52);
    }];

    return titleView;
}
-(UIView*)creatInputContentView{
   
       UIView * inputContentView = [UIView new];
       [self addSubview:inputContentView];
       inputContentView.layer.borderColor = HexRGB(0xbbbbce).CGColor;
       inputContentView.layer.borderWidth = 0.5;
    
    
       self.inputTf = [UITextField new];
       [inputContentView addSubview:self.inputTf];
       self.inputTf.delegate = self;
        self.inputTf.font = FONT_REGULAR_SIZE(14);
       [self.inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(inputContentView).offset(10);
           make.height.equalTo(inputContentView);
       }];
       self.inputTf.keyboardType = UIKeyboardTypeDecimalPad;
       [self.inputTf addTarget:self action:@selector(inputTextDidChange) forControlEvents:UIControlEventEditingChanged];
       
       UIButton * allButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [inputContentView addSubview:allButton];
       self.allButton = allButton;
       allButton.titleLabel.font = FONT_REGULAR_SIZE(13);
       [allButton setTitleColor:HexRGB(0x1881d3) forState:UIControlStateNormal];
       allButton.frame = CGRectMake(0, 0, 60, 49);
       [allButton addTarget:self action:@selector(event_buyAllCurrencyAction) forControlEvents:UIControlEventTouchUpInside];
       [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(inputContentView);
           make.right.equalTo(inputContentView).offset(-10);
           make.width.equalTo(@60);
       }];
       
    
    
       UIView * lineView = [UIView new];
       [inputContentView addSubview:lineView];
       lineView.backgroundColor = HexRGB(0xbbbbce);
       [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(allButton.mas_left).offset(-10);
           make.centerY.equalTo(allButton);
           make.width.equalTo(@1);
           make.height.equalTo(inputContentView).multipliedBy(0.4);
       }];
       
    
    
       UILabel * unitLabel = [UILabel new];
       [inputContentView addSubview:unitLabel];
       self.unitTypeLabel = unitLabel;
       unitLabel.textColor = HexRGB(0x191d26);
       unitLabel.font = FONT_REGULAR_SIZE(14);
       unitLabel.textAlignment = NSTextAlignmentRight;
       [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(lineView).offset(-10);
          make.centerY.equalTo(lineView);
          make.width.equalTo(@40);
        }];
    
       [self.inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(inputContentView).offset(10);
           make.height.equalTo(inputContentView);
           make.right.equalTo(unitLabel.mas_left).offset(15);
       }];
    
    
    return inputContentView;
}

-(void)event_buyAllCurrencyAction{
    
    NSDecimalNumber * unit_price = [NSDecimalNumber decimalNumberWithString:NSStringFormat(@"%@",self.originDictionary[@"price"])];
    
    NSDecimalNumber * max_price = [NSDecimalNumber decimalNumberWithString:NSStringFormat(@"%@",self.originDictionary[@"max_limit"])];
    
    NSDecimalNumber * max_amout = [max_price decimalNumberByDividingBy:unit_price];
   
    if ([self.trade_type isEqualToString:trade_price]) {
        self.inputTf.text = NSStringFormat(@"%.2f",max_price.doubleValue);
    }else if ([self.trade_type isEqualToString:trade_amount]){
        self.inputTf.text = NSStringFormat(@"%.2f",max_amout.doubleValue);
    }
    
    self.order_amount = NSStringFormat(@"%@",@(max_amout.floatValue));
    self.order_price = NSStringFormat(@"%@",@(max_price.floatValue));
    NSString * currency_code = NSStringFormat(@"%@",self.originDictionary[@"currency_code"]);
    self.tradeNumberLabel.text = NSStringFormat(@"交易数量%.6f %@",max_amout.floatValue,[currency_code uppercaseString]);
    self.payPriceLabel.text = [NSStringFormat(@"%@",self.order_price) formatterDecimalString];
           
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
        if ([self.trade_type isEqualToString:trade_amount]) {
            pointAfterMaxLength = 8;//数量 小数点后 最多输入8位
        }else{
            pointAfterMaxLength = 2;//价格 小数点后 最多输入2位
        }
        
        NSString * pointAfterString = [textString substringFromIndex:pointRange.location];
        if (pointAfterString.length>pointAfterMaxLength) {
            return NO;
        }
        
    }else{
        NSInteger pointAfterMaxLength = 8;
        if (textString.length>pointAfterMaxLength) {
            return NO;
        }
    }
    
    return YES;
}

-(void)inputTextDidChange{
    
    NSString * textString = self.inputTf.text;
    NSString* unit_price_ori = self.originDictionary[@"price"];
    if (!unit_price_ori.length) {
       return;
    }
    
    if (!textString.length||[textString isEqualToString: @"."]) {
        textString = @"0";
    }
    
    NSDecimalNumber * inputValue = [NSDecimalNumber decimalNumberWithString:textString];
    NSDecimalNumber * unit_price = [NSDecimalNumber decimalNumberWithString:unit_price_ori];
    
    double max_price = [self.originDictionary[@"max_limit"] doubleValue];
    if (max_price<=0) {
        return;
    }
    double price = 0.0;
    double amount = 0.0;
    if ([self.trade_type isEqualToString:trade_amount]) {
        //把输入框的数量换成相应的价格
        price = [inputValue decimalNumberByMultiplyingBy:unit_price].doubleValue;
        amount = textString.doubleValue;
    }else{
        //输入价格
        if (textString.doubleValue>max_price) {
            textString = [textString substringToIndex:textString.length-1];
            inputValue = [NSDecimalNumber decimalNumberWithString:textString];
        }
        //把输入框的价格 换成相应的数量
        amount = [inputValue decimalNumberByDividingBy:unit_price].doubleValue;
        price = textString.doubleValue;
    }
    if (textString.length&&textString.floatValue>0) {
        self.inputTf.text = textString;
    }
    
    self.order_amount = NSStringFormat(@"%@",@(amount));
    self.order_price = NSStringFormat(@"%@",@(price));
    
    self.tradeNumberLabel.text = NSStringFormat(@"交易数量%.6f %@",amount,[self.originDictionary[@"currency_code"] uppercaseString]);
    self.payPriceLabel.text = [NSStringFormat(@"%@",self.order_price) formatterDecimalString];
    
}

-(void)updateInputViewPlaceHolder:(NSString*)placeHodle{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:CALanguages(placeHodle) attributes:
    @{NSForegroundColorAttributeName:HexRGB(0xa3a3b6),
      NSFontAttributeName:self.inputTf.font
         }];
     self.inputTf.attributedPlaceholder = attrString;
}

-(void)initSubViews{
    
    UIView * titleView = [self creatTopView];
    
    self.priceChooseButton = [self creatButton:@"按价格购买"];
    self.numberChooseButton = [self creatButton:@"按数量购买"];
   
    
    [self.priceChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(titleView.mas_bottom).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self.numberChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceChooseButton.mas_right).offset(20);
        make.centerY.equalTo(self.priceChooseButton);
        make.width.height.equalTo(self.priceChooseButton);
    }];
    
    UIView * inputContentView = [self creatInputContentView];
    [inputContentView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self).offset(15);
       make.top.equalTo(self.priceChooseButton.mas_bottom).offset(15);
       make.right.equalTo(self).offset(-15);
       make.height.equalTo(@49);
    }];
    
    UILabel * limitPriceLabel = [UILabel new];
    [self addSubview:limitPriceLabel];
    limitPriceLabel.font = FONT_REGULAR_SIZE(14);
    limitPriceLabel.textColor = HexRGB(0xa3a3b6);
    self.limitPriceLabel = limitPriceLabel;
    [limitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputContentView.mas_left);
        make.top.equalTo(inputContentView.mas_bottom).offset(5);
    }];
    
    UILabel * tradeNumberLabel = [UILabel new];
    [self addSubview:tradeNumberLabel];
    self.tradeNumberLabel = tradeNumberLabel;
    tradeNumberLabel.font = FONT_REGULAR_SIZE(12);
    tradeNumberLabel.textColor = HexRGB(0xa3a3b6);
    tradeNumberLabel.textAlignment = NSTextAlignmentRight;
    [tradeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputContentView);
        make.top.equalTo(limitPriceLabel.mas_bottom).offset(10);
    }];
    
    UILabel * payPriceNotiLabel = [UILabel new];
    [self addSubview:payPriceNotiLabel];
    
    payPriceNotiLabel.font = FONT_REGULAR_SIZE(14);
    payPriceNotiLabel.textColor = HexRGB(0xa3a3b6);
    payPriceNotiLabel.text =CALanguages(@"实付款");
    [payPriceNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputContentView.mas_left);
        make.top.equalTo(tradeNumberLabel.mas_bottom).offset(5);
    }];
    
    UILabel * payPriceLabel = [UILabel new];
    [self addSubview:payPriceLabel];
    payPriceLabel.font =   FONT_SEMOBOLD_SIZE(20);
    payPriceLabel.textColor = HexRGB(0x1881d3);
    self.payPriceLabel = payPriceLabel;
    payPriceLabel.textAlignment = NSTextAlignmentRight;
    [payPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputContentView.mas_right);
        make.left.equalTo(payPriceNotiLabel.mas_right).offset(20);
        make.centerY.equalTo(payPriceNotiLabel);
    }];
    
    UIButton * cancleButton = [self creatBottomCancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputContentView);
        make.width.mas_equalTo((MainWidth-45)/2.f);
        make.top.equalTo(payPriceNotiLabel.mas_bottom).offset(15);
        make.height.equalTo(@45);
    }];
    
    UIButton * creatOrderButton = [self creatBuyButton];
    [creatOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputContentView);
        make.width.equalTo(cancleButton);
        make.centerY.equalTo(cancleButton);
        make.height.equalTo(cancleButton);
    }];
}
-(UIButton*)creatBuyButton{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setTitle:CALanguages(@"下单")  forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    button.titleLabel.font = FONT_REGULAR_SIZE(15);
    [button addTarget:self action:@selector(event_creatOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:IMAGE_NAMED(@"button_background") forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGE_NAMED(@"button_background_highlight") forState:UIControlStateHighlighted];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.adjustsImageWhenHighlighted = NO;
    
    return  button;
}
-(UIButton*)creatBottomCancleButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    UILabel * label = [UILabel new];
    [button addSubview:label];
    label.font = FONT_REGULAR_SIZE(15);
    label.textColor = [UIColor whiteColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    button.adjustsImageWhenHighlighted = NO;
    self.timeLabel = label;
    self.timeLabel.text = CALanguages(@"取消");
//    NSStringFormat(@"%ld秒后自动取消",(long)_time);
    label.textAlignment = NSTextAlignmentCenter;
    [button setBackgroundImage:IMAGE_NAMED(@"cancle_background_icon") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(event_cancleClick) forControlEvents:UIControlEventTouchUpInside];
    return  button;
}
-(void)event_cancleClick{
    
    [self hide:YES];
}
-(void)event_creatOrderClick{
    
    //判断输入的金额是否满足条件
    CAPreventRepeatClickTime(0.5);
    
    if ([self.trade_type isEqualToString:trade_amount]) {
        if (self.order_price.doubleValue>self.max_limite) {
            Toast(CALanguages(@"您输入的币量大于最大币量"));
            return;
        }
        if (self.order_price.doubleValue<self.min_limite) {
            Toast(CALanguages(@"您输入的币量小于最小币量"));
            return;
        }
    }else{
        if (self.order_price.doubleValue>self.max_limite) {
            Toast(CALanguages(@"您输入的金额大于最大金额"));
            return;
        }
        if (self.order_price.doubleValue<self.min_limite) {
            Toast(CALanguages(@"您输入的金额小于最小金额"));
            return;
        }
    }
   
    
    if (self.dele&&[self.dele respondsToSelector:@selector(creatOrderClick:order_amount:originDictinary:orderView:)]) {
        [self.dele creatOrderClick:self.order_price order_amount:self.order_amount originDictinary:self.originDictionary orderView:self];
    }
}

-(void)event_buyTypeClick:(UIButton*)btn{
    
    if (btn.isSelected) {
        return;
    }
    
    [btn setSelected:YES];
    
    if (self.inputTf.text.length) {
        NSDecimalNumber * inputValue = [NSDecimalNumber decimalNumberWithString:self.inputTf.text];
        NSDecimalNumber * unit_price = [NSDecimalNumber decimalNumberWithString:self.originDictionary[@"price"]];
        if (btn==self.priceChooseButton) {
            //把输入框的数量换成相应的价格
            double price = [inputValue decimalNumberByMultiplyingBy:unit_price].doubleValue;
            self.inputTf.text = NSStringFormat(@"%@",@(price));
        }else{
            //把输入框的价格 换成相应的数量
            double amount = [inputValue decimalNumberByDividingBy:unit_price].doubleValue;
            self.inputTf.text = NSStringFormat(@"%@",@(amount));
        }
    }
    
    
    if (btn==self.priceChooseButton) {
        [self.numberChooseButton setSelected:NO];
        self.trade_type = trade_price;
        [self updateInputViewPlaceHolder:@"请输入购买金额"];
        self.unitTypeLabel.text = @"CNY";
        
    }else{
        
        [self.priceChooseButton setSelected:NO];
        self.trade_type = trade_amount;
        [self updateInputViewPlaceHolder:@"请输入购买数量"];
        self.unitTypeLabel.text = [self.originDictionary[@"currency_code"] uppercaseString];
        
    }
}

-(UIButton*)creatButton:(NSString*)title{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setTitle:CALanguages(title) forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0xa3a3b6) forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x006cdb) forState:UIControlStateSelected];
    button.titleLabel.font =   FONT_SEMOBOLD_SIZE(17);
    [button addTarget:self action:@selector(event_buyTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return  button;
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
