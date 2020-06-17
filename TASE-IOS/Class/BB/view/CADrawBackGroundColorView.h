//
//  CADrawBackGroundColorView.h
//  TASE-IOS
//
//   9/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BackgroundDireactionNone=0,
    BackgroundDireactionLeftToRight=1,
    BackgroundDireactionRightToLeft=2,
} BackgroundDireaction;


NS_ASSUME_NONNULL_BEGIN

@interface CADrawBackGroundColorView : UIView
//0 买盘 1卖盘
@property (nonatomic, assign) TradingType type;
//传入比例
@property (nonatomic, assign) CGFloat scaleDeep;

@property (nonatomic, assign) BackgroundDireaction dir;

@end

NS_ASSUME_NONNULL_END
