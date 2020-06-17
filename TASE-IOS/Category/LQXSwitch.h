//
//  LQXSwitch.h
//  Interest inducing
//
//  Created by 刘祺旭 on 15/4/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQXSwitch : UIControl
@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;
@property (nonatomic, assign) NSInteger switchKnobSize;
@property (nonatomic, strong) UIColor * onTextColor;
@property (nonatomic, strong) UIColor * offTextColor;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;

@property (nonatomic, copy) void(^changeBlock)(BOOL);

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (id)initWithFrame:(CGRect)frame onColor:(UIColor *)onColor offColor:(UIColor *)offColor font:(UIFont *)font ballSize:(NSInteger )ballSize;

@end
