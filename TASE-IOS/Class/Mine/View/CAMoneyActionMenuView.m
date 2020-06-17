//
//  CAMoneyActionMenuView.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMoneyActionMenuView.h"

@implementation CAMoneyActionMenuView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.is_depositable = YES;
        self.is_transferable = YES;
        self.is_withdrawable = YES;
        
        [self initSubViews];
        
    }
    return self;
}

-(void)languageDidChange{
    
    [self removeAllSubViews];
    
//    [self initSubViews];
}

-(void)initSubViews{
    
    UIView * rechargeBtn = [self creatView:@"充币" image:@"Coin_charging" tag:1];
    UIView * withDrawBtn = [self creatView:@"提币" image:@"Withdraw_money" tag:2];
    UIView * transferBtn = [self creatView:@"转账" image:@"Transfer_within_Station" tag:3];
    
    [self addSubview:rechargeBtn];
    [self addSubview:withDrawBtn];
    [self addSubview:transferBtn];

    NSArray * subViewsArray = @[rechargeBtn,withDrawBtn,transferBtn];
    [subViewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:45 leadSpacing:0 tailSpacing:0];
    [subViewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
    }];
}

-(void)setIs_depositable:(BOOL)is_depositable{
    _is_depositable = is_depositable;
    if (!_is_depositable) {
        UIImageView * imageView = (UIImageView*)[self viewWithTag:1+2323];
        imageView.image = IMAGE_NAMED(@"Coin_charging_gray");
    }
}
-(void)setIs_withdrawable:(BOOL)is_withdrawable{
    _is_withdrawable = is_withdrawable;
    if (!_is_withdrawable) {
        UIImageView * imageView = (UIImageView*)[self viewWithTag:2+2323];
        imageView.image = IMAGE_NAMED(@"Withdraw_money_gray");
    }
}
-(void)setIs_transferable:(BOOL)is_transferable{
    _is_transferable = is_transferable;
    if (!_is_transferable) {
        UIImageView * imageView = (UIImageView*)[self viewWithTag:3+2323];
        imageView.image = IMAGE_NAMED(@"Transfer_within_Station_gray");
    }
}

-(UIView*)creatView:(NSString*)title image:(NSString*)image tag:(NSInteger)tag{

    UIView * view = [UIView new];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(image)];
    imageView.tag = tag+2323;
    [view addSubview:imageView];
    view.tag = tag;
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    
    UILabel * textLabel = [UILabel new];
    textLabel.text = CALanguages(title);
    [view addSubview:textLabel];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = FONT_REGULAR_SIZE(13);
    textLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(view);
        make.height.equalTo(view.mas_width);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.centerX.equalTo(imageView);
    }];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_click:)]];
    
    return view;
}

-(void)event_click:(UIGestureRecognizer*)tap{
    
    
    switch (tap.view.tag) {
        case 1:
            if (self.is_depositable) {
                [self routerEventWithName:@"pushViewController" userInfo:@"CARechargeViewController"];
            }
            
            break;
        case 2:
            if (self.is_withdrawable) {
                [self routerEventWithName:@"pushViewController" userInfo:@"CAWithDrawViewController"];
            }
            
            break;
        case 3:
            if (self.is_transferable) {
                 [self routerEventWithName:@"pushViewController" userInfo:@"CATransferViewController"];
            }
            break;
            
        default:
            break;
    }
}

@end
