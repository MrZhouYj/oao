//
//  CATransferViewController.m
//  TASE-IOS
//
//   10/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CATransferViewController.h"
#import "CASegmentView.h"
#import "CACurrencyModel.h"
#import "CAInputView.h"

@interface CATransferViewController ()
<CASegmentViewDelegate>
{
    UILabel * _notiLabel;
}
@property (nonatomic, strong) UIImageView * currencyImageView;
@property (nonatomic, strong) UILabel * currencyLabel;
@property (nonatomic, strong) UILabel * feeLabel;
@property (nonatomic, strong) UILabel * arrivalLabel;
@property (nonatomic, strong) UILabel * minLabel;
@property (nonatomic, strong) CASegmentView *segmentView;
@property (nonatomic, strong) CAInputView * emailTf;
@property (nonatomic, strong) CAInputView * numberTf;
@property (nonatomic, strong) CAInputView * codeTf;
@property (nonatomic, strong) CABaseButton * saveButton;

@property (nonatomic, strong) NSMutableArray * currencies;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CATransferViewController

-(NSMutableArray *)currencies{
    if (!_currencies) {
        _currencies = [CACurrencyModel getTransferableModels].mutableCopy;
    }
    return _currencies;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navcTitle = @"站内转账";
    [self setSegmemtView];
    [self setScrollViewSubViews];
    [SVProgressHUD show];
}

-(void)getCurrencyValiable{
    
    if (self.currentIndex>=self.currencies.count) {
        return;
    }
    
    CACurrencyModel * model = self.currencies[self.currentIndex];
    if (!model.code) {
        return;
    }
     [SVProgressHUD show];
    
    [CANetworkHelper GET:CAAPI_CURRENCY_SHOW_INTERNAL_TRANSFER_PAGE parameters:@{@"code":model.code} success:^(id responseObject) {
        
        NSString *show_internal_transfer_page_description = responseObject[@"data"][@"show_internal_transfer_page_description"];
        [self setNotiLabelText:show_internal_transfer_page_description];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            if ([responseObject[@"code"] integerValue]==20000) {
                
                NSDictionary * data = responseObject[@"data"];
                
                model.balance = data[@"balance"];
                model.fee = data[@"fee"];
                model.min_amount = data[@"min_amount"];
                [self.currencyImageView loadImage:model.icon];
                self.currencyLabel.text = NSStringFormat(@"%@ %@",data[@"balance"],model.code_big);
                self.feeLabel.text = NSStringFormat(@"%@:%@ %@",CALanguages(@"手续费"),model.fee,model.code_big);
                self.numberTf.maxNumber = NSStringFormat(@"%@",model.balance);
                self.numberTf.minNumber = NSStringFormat(@"%@",model.min_amount);
                self.minLabel.text = NSStringFormat(@"%@:%@%@",CALanguages(@"最小转账数量"),model.min_amount,model.code_big);
                
                [self.currencies replaceObjectAtIndex:self.currentIndex withObject:model];
                
            }
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)internal_transfer{
    
    
    CACurrencyModel * model = self.currencies[self.currentIndex];
    if (!model.code) {
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"code":NSStringFormat(@"%@",model.code),
        @"amount":NSStringFormat(@"%@",self.numberTf.inputView.text),
        @"to_member_email":NSStringFormat(@"%@",self.emailTf.inputView.text),
        @"assets_password":NSStringFormat(@"%@",self.codeTf.inputView.text),
    };
    
    [CANetworkHelper POST:CAAPI_CURRENCY_INTERNAL_TRANSFER  parameters:para success:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue]==20000) {
                self.emailTf.inputView.text = @"";
                self.numberTf.inputView.text = @"";
                self.codeTf.inputView.text = @"";
                [self judgeCanSendAction];
            }
            Toast(responseObject[@"message"]);
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)CASegmentView_didSelectedIndex:(NSInteger)index{
    self.currentIndex = index;
    self.currencyImageView.image = nil;
    [self.view endEditing:YES];
    [self getCurrencyValiable];
}

-(void)setSegmemtView{
    
    self.segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 35)];
    [self.view addSubview:self.segmentView];
    self.segmentView.delegata = self;
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.navcBar.mas_bottom).offset(5);
        make.height.equalTo(@35);
    }];
    
    self.segmentView.segmentItems = [CASegmentView getItemsFromArray:self.currencies];
    
    
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
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentView.mas_bottom);
    }];
    
}
-(void)setScrollViewSubViews{
    
    self.emailTf = [CAInputView showWithType:CAInputViewLeftBigImageType];
    self.numberTf = [CAInputView showWithType:CAInputViewLeftBigImageType];
    self.codeTf = [CAInputView showWithType:CAInputViewLeftBigImageType];
    [self.contentView addSubview:self.emailTf];
    [self.contentView addSubview:self.numberTf];
    [self.contentView addSubview:self.codeTf];
    
    self.emailTf.notiLabel.text = CALanguages(@"被转账用户邮箱");
    self.numberTf.notiLabel.text = CALanguages(@"数量");
    self.codeTf.notiLabel.text = CALanguages(@"资金密码");
    self.codeTf.inputView.secureTextEntry = YES;
    
    self.emailTf.leftBigImageView.image = IMAGE_NAMED(@"user_mail");
    self.numberTf.leftBigImageView.image = IMAGE_NAMED(@"count");
    self.codeTf.leftBigImageView.image = IMAGE_NAMED(@"google_code");
    
    self.emailTf.inputView.keyboardType = UIKeyboardTypeEmailAddress;
    self.numberTf.inputView.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.emailTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.contentView).offset(30);
    }];
    
    [self.numberTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.emailTf.mas_bottom).offset(15);
    }];
    
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.numberTf.mas_bottom).offset(15);
    }];

    UIView * useView = [self creatEnableuserView];

     self.saveButton = [CABaseButton buttonWithTitle:@"确认转账"];
    [self.contentView addSubview:self.saveButton];
    [self.saveButton addTarget:self action:@selector(internal_transfer) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.height.equalTo(@43);
        make.top.equalTo(useView.mas_bottom).offset(15);
    }];
    
    UILabel * label = [UILabel new];
    [self.contentView addSubview:label];
    _notiLabel = label;
    label.font = FONT_REGULAR_SIZE(13);
    label.textColor = HexRGB(0x969dbf);
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);;
        make.top.equalTo(self.saveButton.mas_bottom).offset(10);
    }];
    
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_bottom);
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
            if (self.currentIndex>=self.currencies.count) {
                return;
            }
            NSString * value = info[@"text"];
            if ([value length]) {
                CACurrencyModel * model = self.currencies[self.currentIndex];
                NSDecimalNumber * fee = [NSDecimalNumber decimalNumberWithString:NSStringFormat(@"%@",model.fee)];
                NSDecimalNumber * text = [NSDecimalNumber decimalNumberWithString:value];
                self.arrivalLabel.text = NSStringFormat(@"%@:%@",CALanguages(@"实际到账"),@([[text decimalNumberBySubtracting:fee] doubleValue]));
            }else{
                self.arrivalLabel.text = NSStringFormat(@"%@:0.0",CALanguages(@"实际到账"));
            }
        }
        [self judgeCanSendAction];
    }
}

-(void)judgeCanSendAction{
    
    NSString * email = self.emailTf.inputView.text;
    NSString * amount = self.numberTf.inputView.text;
    NSString * secret = self.codeTf.inputView.text;
    
    if ([email length]&&[amount length]&&[secret length]) {
        self.saveButton.enabled = YES;

    }else{
        self.saveButton.enabled = NO;
    }
    
}

-(UIView*)creatEnableuserView{
    
    UIView * view = [UIView new];
    [self.contentView addSubview:view];
    
    
    UIImageView * leftImageView = [UIImageView new];
    [view addSubview:leftImageView];
    self.currencyImageView = leftImageView;
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(25);
        make.top.equalTo(view);
        make.width.height.equalTo(@40);
    }];
    
    UILabel * notiLabel = [UILabel new];
    [view addSubview:notiLabel];
    notiLabel.text = CALanguages(@"可用");
    notiLabel.textColor = HexRGB(0x191d26);
    notiLabel.font = FONT_REGULAR_SIZE(15);
    [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(leftImageView.mas_right).offset(10);
       make.centerY.equalTo(leftImageView);
    }];
    
    
    UILabel * useLabel = [UILabel new];
    [view addSubview:useLabel];
    self.currencyLabel = useLabel;
    useLabel.textColor = HexRGB(0x191d26);
    useLabel.font = FONT_REGULAR_SIZE(15);
    [useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(leftImageView);
    }];
    
    
    UILabel * minLabel = [UILabel new];
    [view addSubview:minLabel];
    self.minLabel = minLabel;
    minLabel.textColor = HexRGB(0x191d26);
    minLabel.font = FONT_REGULAR_SIZE(14);
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(useLabel);
       make.top.equalTo(useLabel.mas_bottom).offset(8);
    }];
    
    UILabel * feeLabelNotilabel = [UILabel new];
    [view addSubview:feeLabelNotilabel];
    self.feeLabel = feeLabelNotilabel;
    feeLabelNotilabel.textColor = HexRGB(0x191d26);
    feeLabelNotilabel.font = FONT_REGULAR_SIZE(14);
    [feeLabelNotilabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(useLabel);
       make.top.equalTo(minLabel.mas_bottom).offset(8);
    }];
    
    self.arrivalLabel = [UILabel new];
    [view addSubview:self.arrivalLabel];
    self.arrivalLabel.textColor = HexRGB(0x191d26);
    self.arrivalLabel.font = FONT_REGULAR_SIZE(14);
    [self.arrivalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(useLabel);
       make.top.equalTo(feeLabelNotilabel.mas_bottom).offset(8);
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.codeTf.mas_bottom).offset(20);
        make.bottom.equalTo(self.arrivalLabel.mas_bottom).offset(5);
    }];
    
    return view;
         
}

@end
