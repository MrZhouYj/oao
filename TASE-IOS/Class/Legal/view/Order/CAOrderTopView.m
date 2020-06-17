//
//  CAOrderTopView.m
//  TASE-IOS
//
//   10/15.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAOrderTopView.h"
#import "CAShadowView.h"
#import "CAButton.h"

@interface CAOrderTopView()
{
    NSTimer* _timer;
    NSInteger _time;
    
    CAButton * _contactButton;
    CAButton * _phoneButton;
    CAButton * _appealButton;
    
    NSString * _contactPhone;
    BOOL _isShowPhoneButton;
    UIImageView * _stateImageView;
    
}

@property (nonatomic, strong) UIImageView * stateImageView;
@property (nonatomic, strong) UILabel * payTimeLabel;
@property (nonatomic, strong) UILabel * stateLabel;

@end

@implementation CAOrderTopView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self initTopSubViews];

    }
    return self;
}

-(void)beginTime{
    
    if (!_timer&&_time>0) {
        _timer = [NSTimer scheduledAutoReleaseTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userinfo:nil repeats:YES];
        [_timer fire];
    }
}

-(void)handleTimer{
    
    int minunte = (int)_time/60;
    int second = (int)_time%60;
    
    NSString * timeString = NSStringFormat(@"%02d:%02d",minunte,second);
    
    NSMutableString * textString = nil;
    
    if (self.orderInfoModel.is_buyer) {
        textString = CALanguages(@"请在 (%@) 内付款给卖家").mutableCopy;
    }else{
        textString = CALanguages(@"预计在 (%@) 内收到买家付款").mutableCopy;
    }
    
    NSString * showString = [textString stringByReplacingOccurrencesOfString:@"(%@)" withString:timeString];

    self.payTimeLabel.text = showString;
    
    if (_time==0) {
        
        [_timer invalidate];
        _timer = nil;
    }
    _time--;
}

-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)initTopSubViews{
 
    UILabel * payTimeLabel = [UILabel new];
    [self addSubview:payTimeLabel];
    self.payTimeLabel = payTimeLabel;
    payTimeLabel.font = FONT_REGULAR_SIZE(12);
    payTimeLabel.textColor = HexRGB(0xd7c1f8);
    
    
    _contactButton = [self creatButton:@"联系对方"
                                           image:@"order_contact"
                                       imageSize:CGSizeMake(25, 22)
                                           space:10];
    _phoneButton = [self creatButton:@"电话"
                                         image:@"order_phone"
                                     imageSize:CGSizeMake(22, 22)
                                         space:10];
    _appealButton = [self creatButton:@"申诉"
                                        image:@"appeal"
                                    imageSize:CGSizeMake(22, 22)
                                        space:10];
    
    _contactButton.tag = 1;
    _phoneButton.tag = 2;
    _appealButton.tag = 3;
    [self addSubview:_contactButton];
    [self addSubview:_phoneButton];
    [self addSubview:_appealButton];
    
    _stateImageView = [UIImageView new];
    [self addSubview:_stateImageView];
    _stateImageView.image = IMAGE_NAMED(@"order_paytime");
    [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(15);
        make.width.height.equalTo(@25);
    }];
    
    UILabel * stateLabel = [UILabel new];
    [self addSubview:stateLabel];
    self.stateLabel = stateLabel;
    stateLabel.font =  FONT_SEMOBOLD_SIZE(26);
    stateLabel.textColor = HexRGB(0xf7f9ff);
    stateLabel.adjustsFontSizeToFitWidth = YES;
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stateImageView.mas_right).offset(10);
        make.centerY.equalTo(_stateImageView);
    }];
    
    [payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stateLabel.mas_bottom).offset(5);
        make.left.equalTo(self).offset(20);
        make.height.equalTo(@20);
    }];
    
}

-(void)setUnreadMessagesCount:(NSInteger)unreadMessagesCount{
    _unreadMessagesCount = unreadMessagesCount;
    
    _contactButton.isShowRedDot = unreadMessagesCount;
}

-(CAButton*)creatButton:(NSString*)title image:(NSString*)image imageSize:(CGSize)size space:(CGFloat)space{
    

    CAButton * contactButton = [CAButton new];
    
    contactButton.imageView.image = IMAGE_NAMED(image);
    contactButton.titleLabel.font = FONT_REGULAR_SIZE(12);
    contactButton.titleLabel.textColor = [UIColor whiteColor];
    contactButton.titleLabel.text = CALanguages(title);
    [contactButton layoutWithImageSize:size space:space style:CAButtonStyleTop];
    [contactButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactClick:)]];
    
    return contactButton;
}

-(void)contactClick:(UITapGestureRecognizer*)tap{
    
    NSLog(@"tap:%ld",[[tap view] tag]);
    
    if ([[tap view] tag]==1) {
        
        [self routerEventWithName:@"showChatView" userInfo:nil];
        
    }else if ([[tap view] tag]==2){
        
        if (_contactPhone) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_contactPhone]]];
        }
        
    }else if ([[tap view] tag]==3){
        
        [self routerEventWithName:@"showAppealView" userInfo:nil];
    }
}
 
-(void)layoutSubviews{
    
     [_contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.mas_right).offset(-5);
         make.centerY.equalTo(self);
         make.width.equalTo(@65);
         make.height.equalTo(@55);
     }];
    
    
    if (_isShowPhoneButton) {
        _phoneButton.hidden = NO;
        [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_contactButton.mas_left).offset(-5);
            make.centerY.equalTo(_contactButton);
            make.height.equalTo(_contactButton);
            make.width.equalTo(@50);
        }];
    }else{
        _phoneButton.hidden = YES;
    }
    
     [_appealButton mas_remakeConstraints:^(MASConstraintMaker *make) {
         if (_phoneButton.isHidden) {
             make.right.equalTo(_contactButton.mas_left).offset(-5);
         }else{
             make.right.equalTo(_phoneButton.mas_left).offset(-5);
         }
         make.height.equalTo(_contactButton);
         make.width.equalTo(@50);
         make.centerY.equalTo(_contactButton);
     }];
}


-(void)setOrderInfoModel:(CAOrderInfoModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    _isShowPhoneButton = NO;
    NSString * phone = @"";
    if (!self.orderInfoModel.is_builder) {
        phone = NSStringFormat(@"%@%@",self.orderInfoModel.builder_calling_code,self.orderInfoModel.builder_mobile);
        if (orderInfoModel.builder_mobile.length) {
            _isShowPhoneButton = YES;
        }
    }else{
        phone = NSStringFormat(@"%@%@",self.orderInfoModel.member_calling_code,self.orderInfoModel.member_mobile);
        if (orderInfoModel.member_mobile.length) {
            _isShowPhoneButton = YES;
        }
    }
    
    _contactPhone = NSStringFormat(@"%@",phone);
    
    if (orderInfoModel.order_state==CAOrderStateWaitingPay||self.orderInfoModel.order_state==CAOrderStateHasExpendTime){
        _time = (NSInteger)(orderInfoModel.expired_at.longLongValue-orderInfoModel.current_server_time.longLongValue);
        [self beginTime];
    }else{
        self.payTimeLabel.text = @"";
        
        if (_time) {
        
            [_timer invalidate];
            _timer = nil;
        }
    }
  
    self.stateLabel.text = orderInfoModel.state_name;

    [self layoutIfNeeded];
}

@end
