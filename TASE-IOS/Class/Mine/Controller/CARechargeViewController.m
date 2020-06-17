#import "CARechargeViewController.h"
#import "CASegmentView.h"
#import "CACurrencyModel.h"

@interface CARechargeViewController ()
<CASegmentViewDelegate>

@property (nonatomic, strong) CASegmentView *segmentView;
@property (nonatomic, strong) UIView * centerWhiteView;
@property (nonatomic, strong) UIImageView * qrImageView;
@property (nonatomic, strong) UIImageView * coinImageView;
@property (nonatomic, strong) UILabel * coinNameLable;
@property (nonatomic, strong) UILabel * notiLabel;
@property (nonatomic, strong) NSMutableArray * coinTypeArray;
@property (nonatomic, strong) CACurrencyModel * currentModel;

@end

@implementation CARechargeViewController


- (void)viewDidLoad {

    [super viewDidLoad];

    self.coinTypeArray = @[].mutableCopy;
    self.navcTitle = @"充币";
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    self.backTineColor = [UIColor whiteColor];
    self.backGroungImageView.hidden = NO;
    
    [self initSubViews];
    
    [self.coinTypeArray addObjectsFromArray:[CACurrencyModel getDepositableModels]];
    
    self.currentModel = self.coinTypeArray.firstObject;
    self.segmentView.segmentItems = [CACurrencyModel getCodeBigArray:self.coinTypeArray];
    
    
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

    [SVProgressHUD show];
}

-(void)getData{
    
    
 
    NSDictionary * para = @{
        @"code":NSStringFormat(@"%@",self.currentModel.code)
    };
    
    
    [CANetworkHelper GET:CAAPI_CURRENCY_DEPOSIT_ADDRESS parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSString * deposit_address_description = responseObject[@"data"][@"deposit_address_description"];
        [self setNotiText:deposit_address_description];
        
        dispatch_async(dispatch_get_main_queue(), ^{
         if (responseObject[@"data"][@"address"]&&[responseObject[@"data"][@"address"] length]) {
             [self replaceCurrentModelWithResponse:responseObject];
         }else{
             [self setWhiteContentView];
         }
       });
        
    } failure:^(NSError *error) {
      [SVProgressHUD dismiss];
    }];
}

-(void)replaceCurrentModelWithResponse:(NSDictionary*)responseObject{
    
    NSInteger index = [self.coinTypeArray indexOfObject:self.currentModel];
    self.currentModel.address = responseObject[@"data"][@"address"];
    self.currentModel.qrcode = responseObject[@"data"][@"qrcode"];
    [self.coinTypeArray replaceObjectAtIndex:index withObject:self.currentModel];
    [self setWhiteContentView];
}

-(void)CASegmentView_didSelectedIndex:(NSInteger)index{

    self.currentModel = [self.coinTypeArray objectAtIndex:index];

    if (self.currentModel.address&&self.currentModel.address.length) {
        [self setWhiteContentView];
    }else{
        [self getData];
    }
    
}

-(void)initSubViews{

    UIImageView * signImageView = [UIImageView new];
    [self.view addSubview:signImageView];
    signImageView.image = IMAGE_NAMED(@"recharge");
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@80);
        make.top.equalTo(self.view).offset(kTopHeight+10);
    }];

    
    self.segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 33)];
    [self.view addSubview:self.segmentView];
    self.segmentView.delegata = self;
    self.segmentView.itemFont = FONT_SEMOBOLD_SIZE(16);
    self.segmentView.normalColor = [UIColor whiteColor];
    self.segmentView.selectedColor = [UIColor whiteColor];
    self.segmentView.showBottomLine = YES;
    self.segmentView.backgroundColor = [UIColor clearColor];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(signImageView.mas_bottom).offset(20);
        make.height.equalTo(@33);
    }];

    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.segmentView.mas_bottom).offset(25);
    }];

    

    UIView * coinContentView = [UIView new];
    [self.contentView addSubview:coinContentView];
    coinContentView.backgroundColor = [UIColor whiteColor];
    coinContentView.layer.cornerRadius = 21;
    coinContentView.layer.masksToBounds = YES;
    [coinContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@42);
    }];

    

    self.coinImageView = [UIImageView new];
    [coinContentView addSubview:self.coinImageView];
    self.coinImageView.layer.cornerRadius = 16;
    self.coinImageView.layer.masksToBounds = YES;
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coinContentView).offset(5);
        make.centerY.equalTo(coinContentView);
        make.width.height.equalTo(@32);
    }];

    

    self.coinNameLable = [UILabel new];
    [coinContentView addSubview:self.coinNameLable];
    self.coinNameLable.font = FONT_MEDIUM_SIZE(16);
    self.coinNameLable.textColor = HexRGB(0x191d26);
    [self.coinNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinImageView.mas_right).offset(5);
        make.centerY.equalTo(coinContentView);
    }];

    

    self.centerWhiteView = [UIView new];
    [self.contentView addSubview:self.centerWhiteView];
    self.centerWhiteView.backgroundColor = [UIColor whiteColor];
    self.centerWhiteView.layer.cornerRadius = 5;
    self.centerWhiteView.layer.masksToBounds = YES;
    [self.centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(coinContentView.mas_bottom).offset(20);
    }];

    

    self.notiLabel = [UILabel new];
    [self.contentView addSubview:self.notiLabel];
    self.notiLabel.font = FONT_MEDIUM_SIZE(13);
    self.notiLabel.textColor = HexRGB(0xf2fbff);
    self.notiLabel.numberOfLines = 0;
    [self.notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.centerWhiteView.mas_bottom).offset(15);
    }];

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.notiLabel.mas_bottom).offset(40);
    }];

}

-(void)setCurrentModel:(CACurrencyModel *)currentModel{
    _currentModel = currentModel;
    
    self.coinImageView.image = nil;
    [self.coinImageView loadImage:currentModel.icon];
    self.coinNameLable.text = currentModel.code_big;
    
}

-(void)setNotiText:(NSString*)text{
    
    if (!text.length) {
        text = @"";
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.notiLabel.attributedText = attributedString;
}


-(void)setWhiteContentView{

    [self.centerWhiteView removeAllSubViews];
    
    if (self.currentModel.address&&self.currentModel.address.length) {

        self.qrImageView = [UIImageView new];
        [self.centerWhiteView addSubview:self.qrImageView];
        self.qrImageView.backgroundColor = [UIColor redColor];
        [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.top.equalTo(self.centerWhiteView).offset(25);
            make.width.height.equalTo(@150);

        }];
        
        self.qrImageView.image = [CommonMethod getImageFromBase64StringContainImageType:self.currentModel.qrcode];
        

        UILabel * notiLabel = [UILabel new];
        [self.centerWhiteView addSubview:notiLabel];
        notiLabel.text = CALanguages(@"充币地址");
        notiLabel.font = FONT_MEDIUM_SIZE(13);
        notiLabel.textColor = HexRGB(0x999ebc);
        [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.top.equalTo(self.qrImageView.mas_bottom).offset(20);
        }];

        

        

        UILabel * addressLabel = [UILabel new];
        [self.centerWhiteView addSubview:addressLabel];
        addressLabel.text = self.currentModel.address;
        addressLabel.font = FONT_MEDIUM_SIZE(13);
        addressLabel.textColor = HexRGB(0x999ebc);
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.top.equalTo(notiLabel.mas_bottom).offset(10);
        }];

        
        UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerWhiteView addSubview:copyButton];
        [copyButton setTitle:CALanguages(@"复制地址") forState:UIControlStateNormal];
        [copyButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
        copyButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
        [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.width.equalTo(self.centerWhiteView);
            make.height.equalTo(@30);
            make.top.equalTo(addressLabel.mas_bottom).offset(20);
        }];
        [copyButton addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(copyButton.mas_bottom).offset(30);
        }];

    }else{

        

        UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerWhiteView addSubview:copyButton];
        [copyButton setTitle:CALanguages(@"点击生成地址")  forState:UIControlStateNormal];
        [copyButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
        copyButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
        [copyButton addTarget:self action:@selector(creatAddress) forControlEvents:UIControlEventTouchUpInside];
        [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.width.equalTo(self.centerWhiteView);
            make.height.equalTo(@60);
            make.top.equalTo(self.centerWhiteView).offset(10);
        }];

        

        [self.centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(copyButton.mas_bottom).offset(10);
        }];
    }
}

-(void)creatAddress{

    [SVProgressHUD show];
    
    [CANetworkHelper POST: CAAPI_CURRENCY_GRNERATE_DEPOSIT_ADDRESS  parameters:@{@"code":self.currentModel.code} success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue]==20000) {
            [self replaceCurrentModelWithResponse:responseObject];
        }else{
            Toast(responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)copyClick{
    
    [CommonMethod copyString:self.currentModel.address];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

@end

