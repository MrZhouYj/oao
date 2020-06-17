//
//  CAChoosePayTypeView.m
//  TASE-IOS
//
//   10/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChoosePayTypeView.h"

NSString * const CAPayBank = @"bank_card_pay";
NSString * const CAPayWechat = @"wechat_pay";
NSString * const CAPayAli = @"alipay";

@interface CAPayButton()

@property (nonatomic, copy) NSString * imageNormal;
@property (nonatomic, copy) NSString * imageHightLight;
@property (nonatomic, copy) NSString * title;

@end

@implementation CAPayButton

+(instancetype)buttonWithNormalImage:(NSString *)imageNormal heightLightImage:(NSString *)imageHightLight title:(NSString *)title{
    CAPayButton * button = [CAPayButton new];
    button.imageNormal = imageNormal;
    button.imageHightLight = imageHightLight;
    button.title = title;
    [button initSubViews];
    return button;
}

-(void)initSubViews{
    
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    
    self.textLabel  = [UILabel new];
    [self addSubview:self.textLabel];
    self.textLabel.font = FONT_MEDIUM_SIZE(12);
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.centerY.equalTo(self.imageView);
    }];
    
    self.textLabel.text = CALanguages(self.title);
    
    self.enable = NO;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 0.5;
}

-(void)setEnable:(BOOL)enable{
    _enable = enable;
    if (_enable) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = HexRGB(0x006cdb);
        self.imageView.image = IMAGE_NAMED(self.imageHightLight);
        self.layer.borderColor = HexRGB(0x006cdb).CGColor;
        
    }else{
        self.backgroundColor = HexRGB(0xe9ebf3);
        self.textLabel.textColor = HexRGB(0x9ba0bd);
        self.imageView.image = IMAGE_NAMED(self.imageNormal);
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end

@interface CAChoosePayTypeView()

@property (nonatomic, strong) CAPayButton * alipayButton;

@property (nonatomic, strong) CAPayButton * weixinButton;

@property (nonatomic, strong) CAPayButton * cartButton;

@property (nonatomic, strong) NSMutableArray<CAPayButton*> * buttonsArray;

@end

@implementation CAChoosePayTypeView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.payMethodsArray = @[].mutableCopy;
        self.buttonsArray = @[].mutableCopy;
        
        self.alipayButton = [self creatButtonImage:@"ali_normal" selImage:@"ali_hlight" title:@"支付宝" tag:1];
        self.weixinButton = [self creatButtonImage:@"weixin_normal" selImage:@"weixin_hlight" title:@"微信" tag:2];
        self.cartButton = [self creatButtonImage:@"cart_normal" selImage:@"cart_hlight" title:@"银行卡" tag:3];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    __block CAPayButton * lastButton = self.buttonsArray.firstObject;
   
    [self.buttonsArray enumerateObjectsUsingBlock:^(CAPayButton*  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (idx==0) {
                make.left.equalTo(self);
            }else{
                make.left.equalTo(lastButton.mas_right).offset(8);
            }
            make.right.equalTo(button.textLabel.mas_right).offset(10);
        }];
        lastButton = button;
    }];
    
    [self.buttonsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.centerY.equalTo(self);
    }];
    
}

-(CAPayButton*)creatButtonImage:(NSString*)image selImage:(NSString*)selImage title:(NSString*)title tag:(int)tag{
    
    CAPayButton * button = [CAPayButton buttonWithNormalImage:image heightLightImage:selImage title:title];
    button.tag = tag+111;
    [self addSubview:button];
    [self.buttonsArray addObject:button];
    [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_payclick:)]];

    return button;
}

-(void)payClick:(CAPayButton*)btn{
    if (!self.canMultipleSelection&&btn.enable&&!self.isMustOnlyOneSelected) {
           [self.payMethodsArray removeAllObjects];
    }
    
    NSString * payWay = @"";
    switch (btn.tag-111) {
       case 1:
           payWay = CAPayAli;
       break;
       case 2:
           payWay = CAPayWechat;
       break;
       case 3:
           payWay = CAPayBank;
       break;
       default:
           break;
    }
    
    if (payWay.length) {
       
       if (self.payMethodsArray.count&&!self.canMultipleSelection) {
           NSString * lastPay = self.payMethodsArray.firstObject;
           if ([payWay isEqualToString:lastPay]) {
               if (self.isMustOnlyOneSelected) {
                   if (btn.enable) {
                       return;
                   }
               }
           }
       }
       
       if (self.canMultipleSelection) {
           
           if (btn.enable) {
               [self.payMethodsArray removeObject:payWay];
           }else{
               [self.payMethodsArray addObject:payWay];
           }
           
       }else{
           
           if (!btn.enable) {
               [self.payMethodsArray removeAllObjects];
               [self.payMethodsArray addObject:payWay];
           }
       }
       
       if (self.delegata && [self.delegata respondsToSelector:@selector(CAChoosePayTypeView_didSelected:)]) {
            [self.delegata CAChoosePayTypeView_didSelected:payWay];
       }
       [self update];
    }
}

-(void)event_payclick:(UITapGestureRecognizer*)tap{
    
    CAPayButton * btn = (CAPayButton*)[tap view];
    [self payClick:btn];
}

-(void)setSupportPayMethodArray:(NSArray<NSString *> *)supportPayMethodArray{
    _supportPayMethodArray = supportPayMethodArray;
    
    NSLog(@"可支持的类型有 %@",supportPayMethodArray);
    self.alipayButton.hidden = YES;
    self.weixinButton.hidden = YES;
    self.cartButton.hidden = YES;
    
    [self.buttonsArray removeAllObjects];
    
    for (NSString * pay  in supportPayMethodArray) {
        if ([pay isEqualToString:CAPayAli]) {
            self.alipayButton.hidden = NO;
            [self.buttonsArray addObject:self.alipayButton];
        }else if ([pay isEqualToString:CAPayWechat]){
            self.weixinButton.hidden = NO;
            [self.buttonsArray addObject:self.weixinButton];
        }else if ([pay isEqualToString:CAPayBank]){
            self.cartButton.hidden = NO;
            [self.buttonsArray addObject:self.cartButton];
        }
    }

    CAPayButton * button  = self.buttonsArray.firstObject;
    [self payClick:button];
    
    [self setNeedsLayout];
}

-(void)update{
    
    
    if (self.payMethodsArray) {
        
        for (CAPayButton * btn in self.buttonsArray) {
            [btn setEnable:NO];
        }
        for (NSString *payType in self.payMethodsArray) {
            if ([payType isEqualToString:CAPayAli]) {
                [self.alipayButton setEnable:YES];
            }else if ([payType isEqualToString:CAPayBank]){
                [self.cartButton setEnable:YES];
            }else if ([payType isEqualToString:CAPayWechat]){
                [self.weixinButton setEnable:YES];
            }
        }
    }
}


@end
