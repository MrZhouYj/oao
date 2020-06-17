//
//  CAPayInfoPopView.m
//  TASE-IOS
//
//   10/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPayInfoPopView.h"
extern NSString * const CAPayBank;
extern NSString * const CAPayWechat;
extern NSString * const CAPayAli;

@interface CAPayInfoPopView()

@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *cartNumberLabel;

@property (nonatomic, strong) UIImageView *bigQrCodeImageView;

@end

@implementation CAPayInfoPopView


-(void)initCartSubviews{
    
    self.bankLabel = [self getLeftLabel:[self.payDictionay objectForKey:@"bank_name"]];
    self.nameLabel = [self getLeftLabel:[self.payDictionay objectForKey:@"bank_account_username"]];
    self.cartNumberLabel  = [self getLeftLabel:[self.payDictionay objectForKey:@"bank_account_number"]];
    
    UIButton * copyBackButton = [self getCopyButtonTag:1];
    UIButton * copyNameButton = [self getCopyButtonTag:2];
    UIButton * copyNumberButton = [self getCopyButtonTag:3];
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLabel.mas_left);
        make.top.equalTo(self.bankLabel.mas_bottom).offset(15);
        make.right.equalTo(self.bankLabel.mas_right);
    }];
    [self.cartNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.bankLabel.mas_left);
           make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
           make.right.equalTo(self.bankLabel.mas_right);
    }];
    
    [@[copyBackButton,copyNameButton,copyNumberButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-25);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
    [copyBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankLabel);
    }];
    [copyNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
    }];
    [copyNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cartNumberLabel);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyNumberButton.mas_bottom).offset(20);
    }];
}

-(UILabel *)getLeftLabel:(NSString*)title{
    
    UILabel * label = [UILabel new];
    [self.contentView addSubview:label];
    
    label.font = FONT_REGULAR_SIZE(15);
    label.textColor = HexRGB(0x191d26);
    label.text = title;
    
    return label;
}

-(UIButton*)getCopyButtonTag:(NSInteger)tag{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    
    [button setTitle: CALanguages(@"复制") forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    button.titleLabel.font = FONT_REGULAR_SIZE(15);
    [button addTarget:self action:@selector(copyCLick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    return button;
}

-(void)copyCLick:(UIButton*)button{
    
    NSString * string = @"";
    switch (button.tag) {
        case 1:
            string = [self.payDictionay objectForKey:@"bank_name"];
            break;
        case 2:
            string = [self.payDictionay objectForKey:@"bank_account_username"];
        break;
        case 3:
            string = [self.payDictionay objectForKey:@"bank_account_number"];
        break;
            
        default:
            break;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    Toast(CALanguages(@"复制成功"));
}

-(void)initWeiXinOrAliViews{
    
     self.bigQrCodeImageView = [UIImageView new];
    [self.contentView addSubview:self.bigQrCodeImageView];
    
    [self.bigQrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.top.equalTo(self.contentView);
    }];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:saveButton];
    
    saveButton.titleLabel.font = FONT_SEMOBOLD_SIZE(13);
    [saveButton setTitle:CALanguages(@"保存") forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = HexRGB(0x3885d9);
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 5;
    
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigQrCodeImageView.mas_left);
        make.right.equalTo(self.bigQrCodeImageView.mas_right);
        make.top.equalTo(self.bigQrCodeImageView.mas_bottom).offset(15);
        make.height.equalTo(@40);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(saveButton.mas_bottom).offset(20);
    }];
    
    [saveButton addTarget:self action:@selector(saveImageClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)saveImageClick{
    
    UIImage * image = self.bigQrCodeImageView.image;
    
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    
    [[[UIAlertView alloc] initWithTitle:CALanguages(@"保存成功")  message:nil delegate:nil cancelButtonTitle:CALanguages(@"好的") otherButtonTitles:nil, nil] show];
}

-(void)setPayType:(NSString *)payType{
    _payType = payType;
    if (payType==CAPayBank) {
        self.titleImage = IMAGE_NAMED(@"popview_carticon");
        [self initCartSubviews];
    }else if (payType==CAPayWechat){
        self.titleImage = IMAGE_NAMED(@"popview_weixinicon");
        [self initWeiXinOrAliViews];
        
        [self.bigQrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.bigQrCodeImageView.mas_width).multipliedBy(1466.0/1080.0);
        }];
        [self.bigQrCodeImageView sd_setImageWithURL:[NSURL URLWithString:self.payDictionay[@"wechat_qr_code"]]];
         
    }else if (payType==CAPayAli){
        self.titleImage = IMAGE_NAMED(@"popview_aliicon");
        [self initWeiXinOrAliViews];
        [self.bigQrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.bigQrCodeImageView.mas_width).multipliedBy(900.0/600.0);
        }];
        [self.bigQrCodeImageView sd_setImageWithURL:[NSURL URLWithString:self.payDictionay[@"alipay_qr_code"]]];
    }
}

@end
