//
//  CASegmentIndicatorView.m
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASegmentIndicatorView.h"

static NSInteger const baseTag = 10000;

@interface CASegmentIndicatorView()
{
    UIColor * _normalColor;
    UIColor * _selColor;
}
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIView * curSelView;

@end

@implementation CASegmentIndicatorView

-(instancetype)init{
    self = [super init];
    if (self) {
        _normalColor = RGB(215, 217, 231);
        _selColor = RGB(0, 108, 219);
    }
    return self;
}

-(void)setCurIndex:(NSInteger)curIndex{
    _curIndex = curIndex;
    
    if (_curSelView.tag-baseTag!=curIndex) {
        _curSelView.backgroundColor = _normalColor;
        UIView * view = [self.contentView viewWithTag:baseTag+curIndex];
        view.backgroundColor = _selColor;
        _curSelView = view;
    }
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _contentView;
}

-(void)setAllPages:(NSInteger)allPages{
    _allPages = allPages;
    
    if (_allPages>0) {
        [self.contentView removeAllSubViews];
        UIView * lastView = nil;
        for (int i=0; i<_allPages; i++) {
            UIView * view = [UIView new];
            [self.contentView addSubview:view];
            view.tag = baseTag+i;
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                    make.left.equalTo(lastView.mas_right).offset(5);
                }else{
                    make.left.equalTo(self.contentView);
                }
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(2);
                make.top.equalTo(self.contentView).offset(5);
            }];
            if (i==0) {
                view.backgroundColor = _selColor;
                _curSelView = view;
            }else{
                view.backgroundColor = _normalColor;
            }
            lastView = view;
        }
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
}


@end
