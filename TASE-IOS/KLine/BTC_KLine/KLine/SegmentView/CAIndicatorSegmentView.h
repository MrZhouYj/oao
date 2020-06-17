//
//  CAIndicatorSegmentView.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CAIndicatorSegmentViewDelegata <NSObject>
/**
 主图指标action
 */
-(void)CAIndicatorSegmentView_didSelectedStatus:(Y_StockChartTargetLineStatus)status;
/**
  副图指标action
*/
-(void)CAIndicatorSegmentView_didSelectedAccessoryStatus:(Y_StockChartTargetLineStatus)status;

@end

@interface CAIndicatorSegmentView : UIView

@property (nonatomic, weak) id<CAIndicatorSegmentViewDelegata> delegata;

@property (nonatomic, assign) BOOL isFullScreen;

@end

NS_ASSUME_NONNULL_END
