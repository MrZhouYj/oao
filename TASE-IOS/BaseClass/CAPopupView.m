//
//  CAPopupView.m
//  TASE-IOS
//
//   10/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPopupView.h"
#import "AppDelegate.h"

@interface CAPopupView()

@property (nonatomic, strong) UIImageView * topImageView;

@property (nonatomic, strong) UIView * shadowView;

@end

@implementation CAPopupView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;

        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        
        [window addSubview:self.shadowView];
        [window addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(window).offset(45);
            make.right.equalTo(window).offset(-45);
            make.centerX.equalTo(window);
            make.centerY.equalTo(window);
        }];
        
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:cancleBtn];
        [cancleBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [cancleBtn setImage:IMAGE_NAMED(@"close") forState:UIControlStateNormal];
        [cancleBtn setTitleColor:HexRGB(0xbbbacc) forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(hideClick) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(15);
            make.width.height.equalTo(@15);
        }];
        
        
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.topImageView.mas_bottom);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

-(void)setTitleImage:(UIImage *)titleImage{
    _titleImage = titleImage;
    self.topImageView.image = titleImage;
}

-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        [self addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(-45);
            make.width.height.equalTo(@100);
        }];

    }
    return _topImageView;
}
-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0;
        [_shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClick)]];
    }
    return _shadowView;
}

-(void)show{
 
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shadowView.alpha = 0.5;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
-(void)hide{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.shadowView removeFromSuperview];
    }];
}

-(void)hideClick{
    
    [self hide];
}

- (void)dealloc
{
    
}

@end
