//
//  CAWithDrawViewController.m
//  TASE-IOS
//
//   10/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAWithDrawViewController.h"
#import "CASegmentView.h"
#import "CACurrencyModel.h"
#import "CAInputView.h"

@interface CAWithDrawViewController ()
<CASegmentViewDelegate>
{
    UILabel * _notiLabel;
}
@property (nonatomic, strong) CASegmentView *segmentView;

@property (nonatomic, strong) CAInputView * addressTf;
@property (nonatomic, strong) CAInputView * numberTf;
@property (nonatomic, strong) CAInputView * secretTf;

@property (nonatomic, strong) UILabel * enableLabel;
@property (nonatomic, strong) UILabel * minLabel;
@property (nonatomic, strong) UILabel * processLabel;
@property (nonatomic, strong) UILabel * actualArrivalLabel;
@property (nonatomic, strong) CABaseButton * saveButton;
@property (nonatomic, strong) NSMutableArray * currencies;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CAWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"提币";
    
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    self.backTineColor = [UIColor whiteColor];
    self.backGroungImageView.hidden = NO;
    [SVProgressHUD show];
    [self initSubViews];
    
}

-(void)getCurrencyValiable{
    
    if (self.currentIndex>=self.currencies.count) {
        return;
    }
    CACurrencyModel * model = self.currencies[self.currentIndex];
    if (!model.code) {
        return;
    }
    
    [CANetworkHelper GET:CAAPI_CURRENCY_SHOW_WITHDRAW_PAGE parameters:@{@"code":model.code} success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString * show_withdraw_page_description = responseObject[@"data"][@"show_withdraw_page_description"];
        [self setNotiLabelText:show_withdraw_page_description];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([responseObject[@"code"] integerValue]==20000) {
                NSDictionary * data = responseObject[@"data"];

                model.balance =  [NSNumber numberWithDouble:[data[@"balance"] doubleValue]];
                model.fee = [NSNumber numberWithDouble:[data[@"fee"] doubleValue]];
                self.enableLabel.text = NSStringFormat(@"%@%@",data[@"balance"],model.code_big);
                self.minLabel.text = NSStringFormat(@"%@%@",data[@"minimum_withdraw_amount"],model.code_big);
                self.processLabel.text = NSStringFormat(@"%@%@",data[@"fee"],model.code_big);
                self.actualArrivalLabel.text = @"0.0";
                self.numberTf.inputView.text = @"";
                self.numberTf.maxNumber = data[@"balance"];
                self.numberTf.minNumber = data[@"minimum_withdraw_amount"];
                [self.currencies replaceObjectAtIndex:self.currentIndex withObject:model];

            }
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


-(void)CASegmentView_didSelectedIndex:(NSInteger)index{
    
    self.currentIndex = index;
    [self.view endEditing:YES];
    [self getCurrencyValiable];
}
-(NSMutableArray *)currencies{
    if (!_currencies) {
        _currencies = [CACurrencyModel getWithdrawableModels].mutableCopy;
    }
    return _currencies;
}

-(void)initSubViews{
    
    UIImageView * signImageView = [UIImageView new];
    [self.view addSubview:signImageView];
    signImageView.image = IMAGE_NAMED(@"withdraw");
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@80);
        make.top.equalTo(self.view).offset(kTopHeight+10);
    }];
    
    self.segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 33)];
    [self.view addSubview:self.segmentView];
    self.segmentView.delegata = self;
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(signImageView.mas_bottom).offset(20);
        make.height.equalTo(@33);
    }];
    
    self.segmentView.itemFont = FONT_SEMOBOLD_SIZE(16);
    self.segmentView.normalColor = [UIColor whiteColor];
    self.segmentView.selectedColor = [UIColor whiteColor];
    self.segmentView.showBottomLine = YES;
    self.segmentView.segmentItems = [CASegmentView getItemsFromArray:self.currencies];
    self.segmentView.backgroundColor = [UIColor clearColor];
  
    
    if (self.fromCode.length) {
        NSInteger index = [self.segmentView.segmentItems indexOfObject:self.fromCode];
        if (index!=NSNotFound) {
            
            self.segmentView.segmentCurrentIndex = index;
        }else{
            self.segmentView.segmentCurrentIndex = 0;
        }
    }else{
        self.segmentView.segmentCurrentIndex = 0;
    }
    
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.segmentView.mas_bottom).offset(25);
    }];
    
    
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    
    self.addressTf = [CAInputView showLoginTypeInputView];
    self.numberTf = [CAInputView showLoginTypeInputView];
    self.secretTf = [CAInputView showLoginTypeInputView];
    [self.contentView addSubview:self.addressTf];
    [self.contentView addSubview:self.numberTf];
    [self.contentView addSubview:self.secretTf];
    self.addressTf.notiLabel.text = CALanguages(@"提币地址");
    self.numberTf.notiLabel.text = CALanguages(@"数量");
    self.secretTf.notiLabel.text = CALanguages(@"资金密码");
    self.secretTf.inputView.secureTextEntry = YES;
    self.addressTf.notiLabelNormalColor = HexRGB(0x191d26);
    self.numberTf.notiLabelNormalColor = HexRGB(0x191d26);
    self.secretTf.notiLabelNormalColor = HexRGB(0x191d26);
    self.addressTf.notiLabel.font = FONT_REGULAR_SIZE(15);
    self.numberTf.notiLabel.font = FONT_REGULAR_SIZE(15);
    self.secretTf.notiLabel.font = FONT_REGULAR_SIZE(15);
    self.addressTf.inputView.font = FONT_REGULAR_SIZE(15);
    self.numberTf.inputView.font = FONT_REGULAR_SIZE(15);
    self.secretTf.inputView.font = FONT_REGULAR_SIZE(15);
    
    self.addressTf.inputView.placeholder = CALanguages(@"输入或长按粘贴地址");
    
    self.numberTf.inputView.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.addressTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.numberTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.addressTf.mas_bottom).offset(15);
    }];
    [self.secretTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.numberTf);
        make.top.equalTo(self.numberTf.mas_bottom).offset(15);
    }];
    
    
    UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addressTf.rightView = copyButton;
    [copyButton setTitle:CALanguages(@"粘贴")  forState:UIControlStateNormal];
    copyButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [copyButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressTf).offset(0);
        make.centerY.equalTo(self.addressTf.inputView);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    UIButton * allButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.numberTf.rightView = allButton;
    [allButton setTitle:CALanguages(@"全部") forState:UIControlStateNormal];
    allButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [allButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberTf).offset(0);
        make.centerY.equalTo(self.numberTf.inputView);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    
    self.enableLabel = [self addLabel:@"可用" topView:self.secretTf];
    self.minLabel = [self addLabel:@"最小提币数量" topView:self.enableLabel];
    self.processLabel = [self addLabel:@"手续费" topView:self.minLabel];
    self.actualArrivalLabel = [self addLabel:@"实际到账" topView:self.processLabel];
    
    
    self.saveButton = [CABaseButton buttonWithTitle:@"提交"];
    [self.contentView addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(withDrawAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 22;
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@44);
        make.top.equalTo(self.actualArrivalLabel.mas_bottom).offset(40);
    }];
    
    UILabel * label = [UILabel new];
    _notiLabel = label;
    [self.contentView addSubview:label];
    label.font = FONT_REGULAR_SIZE(13);
    label.textColor = HexRGB(0x969dbf);
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.saveButton.mas_bottom).offset(10);
    }];
    
    

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_bottom).offset(40);
    }];
}

-(void)setNotiLabelText:(NSString*)text{
    if (!text.length) {
        text = @"";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    _notiLabel.attributedText = attributedString;
}

-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:@"textFieldDidChange"]) {
        NSDictionary * info = userInfo;
        if (info[@"item"]==self.numberTf) {
            [self numberTfDidChangeText];
        }
        [self judgeCanSendAction];
    }
}

-(void)numberTfDidChangeText{
     if (self.currencies.count<self.currentIndex) {
        return;
     }
     NSString * value = self.numberTf.inputView.text;
     CACurrencyModel * model = self.currencies[self.currentIndex];
     NSNumber * fee = model.fee;
    
     if ([value length]&&fee.floatValue>0&&value.floatValue>0&&((value.floatValue-fee.floatValue)>0)) {
         
         NSDecimalNumber * feeDecimal = [NSDecimalNumber decimalNumberWithString:NSStringFormat(@"%@",fee)];
         NSDecimalNumber * text = [NSDecimalNumber decimalNumberWithString:value];
         self.actualArrivalLabel.text = NSStringFormat(@"%@",@([[text decimalNumberBySubtracting:feeDecimal] doubleValue]));
     }else{
         self.actualArrivalLabel.text = @"0.0";
     }
}

-(void)judgeCanSendAction{
    
    NSString * email = self.addressTf.inputView.text;
    NSString * amount = self.numberTf.inputView.text;
    NSString * secret = self.secretTf.inputView.text;
    
    if ([email length]&&[amount length]&&[secret length]) {
        self.saveButton.enabled = YES;
    }else{
        self.saveButton.enabled = NO;
    }
    
}


-(void)withDrawAction{
    
    
    CACurrencyModel * model = self.currencies[self.currentIndex];
    if (!model.code) {
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"code":NSStringFormat(@"%@",model.code),
        @"amount":NSStringFormat(@"%@",self.numberTf.inputView.text),
        @"address":NSStringFormat(@"%@",self.addressTf.inputView.text),
        @"assets_password":NSStringFormat(@"%@",self.secretTf.inputView.text),
    };
    [CANetworkHelper POST:CAAPI_CURRENCY_WITHDRAW  parameters:para success:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue]==20000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            Toast(responseObject[@"message"]);
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)allClick{
    CACurrencyModel * model = self.currencies[self.currentIndex];
    self.numberTf.inputView.text = NSStringFormat(@"%@",model.balance);
    [self numberTfDidChangeText];
}

-(void)copyClick{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    self.addressTf.inputView.text = NSStringFormat(@"%@",pasteboard.string?pasteboard.string:@"");
}

-(UILabel*)addLabel:(NSString*)leftTitle topView:(UIView*)topView{
    
    UILabel * leftLabel = [UILabel new];
    [self.contentView addSubview:leftLabel];
    
    leftLabel.font = FONT_REGULAR_SIZE(15);
    leftLabel.textColor = HexRGB(0x191d26);
    leftLabel.text = CALanguages(leftTitle);
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(topView.mas_bottom).offset(25);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    UILabel * rightLabel = [UILabel new];
    [self.contentView addSubview:rightLabel];
    
    rightLabel.font = FONT_REGULAR_SIZE(15);
    rightLabel.textColor = HexRGB(0x191d26);
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(leftLabel);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    [rightLabel setAdjustsFontSizeToFitWidth:YES];
    rightLabel.textAlignment = NSTextAlignmentRight;
    
    return rightLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
