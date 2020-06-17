//
//  CABBMenuView.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBMenuView.h"

@interface CABBMenuView()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * bgImageView;

@end

@implementation CABBMenuView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.bgImageView.userInteractionEnabled = YES;
        [self.bgImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    }
    return self;
}

-(void)click{
    
    if (self.isSelect) {
        return;
    }

    [self routerEventWithName:NSStringFromClass(self.class) userInfo:self.sell_or_buy];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}


-(void)setSelect:(BOOL)select{
    _select = select;
    
    UIColor * selectColor = HexRGB(0xf8fffb);
    UIColor * normalColor = HexRGB(0x9192b1);
    
    if ([_sell_or_buy isEqualToString:@"sell"]) {
        if (select) {
            self.bgImageView.image = IMAGE_NAMED(@"sell_menu_hlight");
            self.titleLabel.textColor = selectColor;
        }else{
            self.bgImageView.image = IMAGE_NAMED(@"sell_menu_normal");
            self.titleLabel.textColor = normalColor;
        }
    }else{
        if (select) {
            self.bgImageView.image = IMAGE_NAMED(@"buy_menu_hlight");
            self.titleLabel.textColor = selectColor;
        }else{
            self.bgImageView.image = IMAGE_NAMED(@"buy_menu_normal");
            self.titleLabel.textColor = normalColor;
        }
    }
    
    [self bringSubviewToFront:self.titleLabel];
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return _bgImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        _titleLabel.font = FONT_MEDIUM_SIZE(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return _titleLabel;
}


@end
