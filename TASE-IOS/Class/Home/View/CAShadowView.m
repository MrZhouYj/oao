//
//  CAShadowView.m
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAShadowView.h"

@implementation CAShadowView

-(instancetype)init{
    self = [super init];
    if (self) {

        [self isYY];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
  
    }
    return self;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _contentView;
}

@end
