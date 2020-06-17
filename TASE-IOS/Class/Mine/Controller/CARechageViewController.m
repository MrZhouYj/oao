//
//  CAWithDrawViewController.m
//  CADAE-IOS
//
//   10/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CARechageViewController.h"
#import "CASegmentView.h"

@interface CARechageViewController ()
<CASegmentViewDelegate>

@property (nonatomic, strong) CASegmentView *segmentView;

@property (nonatomic, strong) UIView * centerWhiteView;

@property (nonatomic, strong) UILabel * coinNameLable;

@property (nonatomic, assign) BOOL hasAddress;

@end

@implementation CARechageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"充币";
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.titleColor = [UIColor whiteColor];
    self.backTineColor = [UIColor whiteColor];
    self.backGroungImageView.hidden = NO;
    
    [self initSubViews];
    [self setWhiteContentView];
    
}

-(void)CASegmentView_didSelectedIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    
    self.hasAddress = !self.hasAddress;
    [self setWhiteContentView];
}

-(void)initSubViews{
    
    UIImageView * signImageView = [UIImageView new];
    [self.view addSubview:signImageView];
    signImageView.backgroundColor = [UIColor redColor];
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@80);
        make.top.equalTo(self.view).offset(kTopHeight+10);
    }];
    
    
    
    self.segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 33)];
    [self.view addSubview:self.segmentView];
    self.segmentView.delegata = self;
    self.segmentView.itemFont = FONT_SEMOBOLD_SIZE_AUTO(16);
    self.segmentView.normalColor = [UIColor whiteColor];
    self.segmentView.selectedColor = [UIColor whiteColor];
    self.segmentView.showBottomLine = YES;
    self.segmentView.segmentItems = @[@"USDT",@"BTC",@"ETH"];
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
    
    
    
    UIImageView * coinImageView = [UIImageView new];
    [coinContentView addSubview:coinImageView];
    coinImageView.layer.cornerRadius = 16;
    coinImageView.layer.masksToBounds = YES;
    coinImageView.backgroundColor = [UIColor redColor];
    [coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coinContentView).offset(5);
        make.centerY.equalTo(coinContentView);
        make.width.height.equalTo(@32);
    }];
    
    self.coinNameLable = [UILabel new];
    [coinContentView addSubview:self.coinNameLable];
    self.coinNameLable.text = @"USDT";
    self.coinNameLable.font = FONT_MEDIUM_SIZE(16);
    self.coinNameLable.textColor = HexRGB(0x191d26);
    [self.coinNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coinImageView.mas_right).offset(5);
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
    
    UILabel * label = [UILabel new];
    [self.contentView addSubview:label];
    label.font = FONT_MEDIUM_SIZE(13);
    label.textColor = HexRGB(0xf2fbff);
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.centerWhiteView.mas_bottom).offset(15);
    }];
    NSString * text = @"请勿向上处地址充值任何非BTC资产，否则资产将不可找回\n您的充币地址不会经常改变，可以重复充值，如有改变，我们会尽量通过网站公告或邮件通知您\n请务必确认电脑及浏览器安全，防止信息被篡改或泄露";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;

    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.mas_bottom).offset(40);
    }];
}

-(void)setWhiteContentView{
    
    [self.centerWhiteView removeAllSubViews];
    
    if (self.hasAddress) {
        
        
        
        UIImageView * qrImageView = [UIImageView new];
        [self.centerWhiteView addSubview:qrImageView];
        qrImageView.backgroundColor = [UIColor redColor];
        [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.top.equalTo(self.centerWhiteView).offset(25);
            make.width.height.equalTo(@150);
        }];
        
        
        
        UILabel * notiLabel = [UILabel new];
        [self.centerWhiteView addSubview:notiLabel];
        notiLabel.text = @"充值地址";
        notiLabel.font = FONT_MEDIUM_SIZE(13);
        notiLabel.textColor = HexRGB(0x999ebc);
        [notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.top.equalTo(qrImageView.mas_bottom).offset(20);
        }];
        
        
        UILabel * addressLabel = [UILabel new];
        [self.centerWhiteView addSubview:addressLabel];
        addressLabel.text = @"0x0b453cd262326b6c27db5732fec7fd3a87a03cd3";
        addressLabel.font = FONT_MEDIUM_SIZE(13);
        addressLabel.textColor = HexRGB(0x999ebc);
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.top.equalTo(notiLabel.mas_bottom).offset(10);
        }];
        
        
        
        UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerWhiteView addSubview:copyButton];
        [copyButton setTitle:@"复制地址" forState:UIControlStateNormal];
        [copyButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
        copyButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
        [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerWhiteView);
            make.width.equalTo(self.centerWhiteView);
            make.height.equalTo(@30);
            make.top.equalTo(addressLabel.mas_bottom).offset(20);
        }];
        
        [self.centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(copyButton.mas_bottom).offset(30);
        }];
        
    }else{
        
        UIButton * copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerWhiteView addSubview:copyButton];
        [copyButton setTitle:@"点击生成地址" forState:UIControlStateNormal];
        [copyButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
        copyButton.titleLabel.font = FONT_MEDIUM_SIZE(15);
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
