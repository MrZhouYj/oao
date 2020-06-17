//
//  CAProgressView.h
//  TASE-IOS
//
//   9/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAProgressView : UIView

@property (nonatomic, strong) UIColor *displayColor;

@property (nonatomic, copy) NSString * maxNumber;

@property (nonatomic, assign) CGFloat progress;


@end

NS_ASSUME_NONNULL_END
