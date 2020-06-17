//
//  CAPopupView.h
//  TASE-IOS
//
//   10/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPopupView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImage * titleImage;

-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
