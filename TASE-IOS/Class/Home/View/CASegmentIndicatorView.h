//
//  CASegmentIndicatorView.h
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface CASegmentIndicatorView : UIView


/**
 一共几页
 */
@property (nonatomic, assign) NSInteger allPages;
/**
 当前页数
 */
@property (nonatomic, assign) NSInteger curIndex;

@end

NS_ASSUME_NONNULL_END
