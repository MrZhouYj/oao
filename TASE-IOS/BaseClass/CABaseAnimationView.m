//
//  CABaseAnimationView.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseAnimationView.h"

@interface CABaseAnimationView()
{
    BOOL _isAnimaing;
}


@end

@implementation CABaseAnimationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _originReact = self.frame;
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteBackGroundColor);
    }
    return self;
}

-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0;
        [_shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewHideClick)]];
    }
    return _shadowView;
}

-(void)setDirection:(CABaseAnimationDirection)direction{
    _direction = direction;
    
    switch (direction) {
        case CABaseAnimationDirectionFromLeft:
            self.frame = CGRectMake(-CGRectGetWidth(_originReact), CGRectGetMinY(_originReact), CGRectGetWidth(_originReact), CGRectGetHeight(_originReact));
            break;
        case CABaseAnimationDirectionFromBottom:
            self.frame = CGRectMake(CGRectGetMinX(_originReact),MainHeight + CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            
            break;
        case CABaseAnimationDirectionFromRight:
            self.frame = CGRectMake(CGRectGetWidth(_originReact)+CGRectGetMinX(_originReact), CGRectGetMinY(_originReact), CGRectGetWidth(_originReact), CGRectGetHeight(_originReact));
                       break;
        case CABaseAnimationDirectionFromTop:
            self.frame = CGRectMake(CGRectGetMinX(_originReact), -CGRectGetMinY(_originReact)-CGRectGetHeight(self.frame), CGRectGetWidth(_originReact), CGRectGetHeight(self.frame));
                       break;
            
        default:
            break;
    }
}


-(void)showInView:(UIView *)view isAnimation:(BOOL)isAnimation direaction:(CABaseAnimationDirection)direction{
    
    
    self.direction = direction;
    self.spView = view;
    [self.spView addSubview:self.shadowView];
    [self.spView addSubview:self];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(thisViewWillAppear:)]) {
        [self.delegate thisViewWillAppear:isAnimation];
    }
    
    self->_isAnimaing = isAnimation;
   
    if (isAnimation) {
        __block CGRect org = _originReact;
      
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = org;
            self.shadowView.alpha = 0.5;
        }completion:^(BOOL finished) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(thisViewDidAppear:)]) {
                [self.delegate thisViewDidAppear:isAnimation];
            }
             self->_isAnimaing = NO;
             self.isShowing = YES;
            [self thisViewDidAppear:YES];
        }];
    }else{
        self.frame = _originReact;
        self.shadowView.alpha = 0.5;
        self.isShowing = YES;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(thisViewDidAppear:)]) {
            [self.delegate thisViewDidAppear:isAnimation];
        }
    }
}

-(void)shadowViewHideClick{
    
    if (_isAnimaing) {
        return;
    }
    [self hide:YES];
}

-(void)hide:(BOOL)isAnimation{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(thisViewWillDisAppear:)]) {
        [self.delegate thisViewWillDisAppear:isAnimation];
    }
    _isAnimaing = isAnimation;
    if (isAnimation) {
        [self dismissAction];
    }else{
        self.isShowing = NO;
        self.direction = self.direction;
        self.shadowView.alpha = 0;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(thisViewDidDisAppear:)]) {
            [self.delegate thisViewDidDisAppear:isAnimation];
        }
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }
}

-(void)thisViewDidAppear:(BOOL)animated{
    
}

-(void)dismissAction{
   
    [UIView animateWithDuration:0.25 animations:^{

        self.direction = self.direction;
        self.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(thisViewDidDisAppear:)]) {
            [self.delegate thisViewDidDisAppear:YES];
        }
        self->_isAnimaing = NO;
        self.isShowing = NO;
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
    
}

-(void)CornerTop{
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = maskPath.CGPath;
    self.layer.mask = layer;
}

-(void)dealloc{
    NSLog(@"消失了");
}

@end
