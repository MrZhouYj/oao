//
//  CANoticeView.h
//  TASE-IOS
//
//   9/12.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CANoticeView : UIView

@property (nonatomic, strong) NSArray * roleArray;
@property (nonatomic, assign) BOOL isRolling;

/**
 开始滚动
 */
- (void)beginRolling;

/**
 结束滚动
 */
- (void)endRolling;

@end

NS_ASSUME_NONNULL_END
