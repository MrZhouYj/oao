
//
//  CAOrderBottomView.m
//  TASE-IOS
//
//   10/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAOrderBottomView.h"


@interface CAOrderBottomView()

@property (nonatomic, strong) UIView * buttonsView;

@end

@implementation CAOrderBottomView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)setOrderInfoModel:(CAOrderInfoModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    [self.buttonsView removeAllSubViews];
    
    for (NSDictionary * dic in orderInfoModel.actionButtons) {
        [self creatButton:dic[@"title"] titleColor:dic[@"titleColor"] backgroundColor:dic[@"backGroundColor"] enable:[dic[@"enable"] boolValue] tag:[dic[@"actionType"] integerValue]];
    }
    
    [self setNeedsLayout];
}



-(void)creatButton:(NSString*)title
             titleColor:(UIColor*)textColor
        backgroundColor:(UIColor*)color
                 enable:(BOOL)enable
                    tag:(CALogalOrderAction)tag{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonsView addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    button.enabled = enable;
    button.titleLabel.font = FONT_REGULAR_SIZE(13);
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(event_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)event_btnClick:(UIButton*)btn{
    
    CALogalOrderAction action = btn.tag;
    [self routerEventWithName:@"order_action" userInfo:@(action)];
    
}

-(void)layoutSubviews{
    
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@49);
    }];
    
    if (self.buttonsView.subviews.count) {
        
        if (self.buttonsView.subviews.count==3) {
            [self.buttonsView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
            withFixedSpacing:10
                 leadSpacing:15
                 tailSpacing:15];
        }
        else if(self.buttonsView.subviews.count==2){
            
            [self.buttonsView.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.buttonsView).offset(15);
                make.width.equalTo(self.buttonsView.mas_width).multipliedBy(0.3);
            }];
            [self.buttonsView.subviews.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.buttonsView).offset(-15);
                make.left.equalTo(self.buttonsView.subviews.firstObject.mas_right).offset(10);
            }];
        }
        else{
            
            [self.buttonsView.subviews.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.buttonsView);
                make.width.equalTo(self.buttonsView.mas_width).multipliedBy(0.6);
            }];
            
        }
        
        [self.buttonsView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@38);
            make.top.equalTo(self.buttonsView).offset(10);
        }];
    }
}


-(UIView *)buttonsView{
    if (!_buttonsView) {
        _buttonsView = [UIView new];
        [self addSubview:_buttonsView];
        _buttonsView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonsView;
}

@end
