//
//  CANavigationBar.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CANavigationBar.h"

@implementation CANavigationBar

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initNavcView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavcView];
    }
    return self;
}

-(void)initNavcView{
    
    self.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
    
    self.navcContentView = [UIView new];
    [self addSubview:self.navcContentView];
    
    self.navcContentView.frame = CGRectMake(0, kStatusBarHeight, MainWidth, kNavBarHeight);
    
    UIView * lineView = [UIView new];
    self.lineView = lineView;
    lineView.hidden = YES;
    [self addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self.navcContentView addSubview:_titleLabel];
        _titleLabel.font = FONT_MEDIUM_SIZE(17);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(NavcTitleColor);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.navcContentView);
            make.width.equalTo(self.navcContentView).multipliedBy(0.5);
        }];
    }
    return _titleLabel;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navcContentView addSubview:_backButton];
        
        UIImage * image = [IMAGE_NAMED(@"app_back") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_backButton setImage:image forState:UIControlStateNormal];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.navcContentView);
            make.left.equalTo(self.navcContentView).offset(15);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
        }];
        
        _backButton.dk_tintColorPicker = DKColorPickerWithKey(WhiteAndBlack);
        
        [_backButton setEnlargeEdgeWithTop:5 right:10 bottom:9 left:10];
                
    }
    return _backButton;
    
}

-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navcContentView addSubview:_closeButton];
        
        UIImage * image = [IMAGE_NAMED(@"close") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [_closeButton setImage:image forState:UIControlStateNormal];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.navcContentView);
            make.left.equalTo(self.backButton.mas_right).offset(15);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        _closeButton.dk_tintColorPicker = DKColorPickerWithKey(WhiteAndBlack);
        
        [_closeButton setEnlargeEdgeWithTop:5 right:10 bottom:9 left:10];
                
    }
    return _closeButton;
    
}

@end
