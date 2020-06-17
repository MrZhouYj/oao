//
//  CANavigationBar.h
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CANavigationBar : UIView

@property (nonatomic, strong) UIView * navcContentView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIButton * backButton;

@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) UIView * lineView;

@end

NS_ASSUME_NONNULL_END
