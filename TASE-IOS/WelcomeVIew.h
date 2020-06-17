//
//  WelcomeVIew.h
//  TASE-IOS
//
//  Created by 周永建 on 2020/3/31.
//  Copyright © 2020 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeVIew : UIView

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIImageView * progressImageView;

@property (nonatomic, strong) UILabel * hanziLabel;
@property (nonatomic, strong) UILabel * enLabel;

@property (nonatomic, strong) UIButton * enterButton;


@end

NS_ASSUME_NONNULL_END
