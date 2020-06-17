//
//  CABaseAnimationView.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CABaseAnimationDirectionFromLeft = 0,    // 从左往右
    CABaseAnimationDirectionFromBottom,         // 从下往上
    CABaseAnimationDirectionFromRight,         
    CABaseAnimationDirectionFromTop,
} CABaseAnimationDirection;

@protocol CABaseAnimationViewDelegate <NSObject>

@optional;

-(void)thisViewWillAppear:(BOOL)animated;

-(void)thisViewDidAppear:(BOOL)animated;

-(void)thisViewWillDisAppear:(BOOL)animated;

-(void)thisViewDidDisAppear:(BOOL)animated;

@end

@interface CABaseAnimationView : UIView

@property (nonatomic, weak) id<CABaseAnimationViewDelegate> delegate;

@property (nonatomic, assign) CGRect originReact;

@property (nonatomic, strong) UIView * spView;

@property (nonatomic, strong) UIView * shadowView;

@property (nonatomic, assign) CABaseAnimationDirection direction;

@property (nonatomic, assign) BOOL isShowing;

-(void)showInView:(UIView*)view isAnimation:(BOOL)isAnimation direaction:(CABaseAnimationDirection)direction;

-(void)hide:(BOOL)isAnimation;

-(void)CornerTop;

@end

NS_ASSUME_NONNULL_END
