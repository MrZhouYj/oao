//
//  CAButton.h
//  TASE-IOS
//
//   10/15.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CAButtonStyle) {
    CAButtonStyleTop, // image在上，label在下
    CAButtonStyleLeft, // image在左，label在右
    CAButtonStyleBottom, // image在下，label在上
    CAButtonStyleRight // image在右，label在左
};

@interface CAButton : UIView

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, assign) CAButtonStyle style;

@property (nonatomic, assign) BOOL isShowRedDot;


-(void)layoutWithImageSize:(CGSize)size space:(CGFloat)space style:(CAButtonStyle)style;

@end

NS_ASSUME_NONNULL_END
