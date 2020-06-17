//
//  CABBTradingListView.h
//  TASE-IOS
//
//   9/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CABBDeepListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CABBTradingListView : UIView

-(void)freshWithData:(NSArray*)dataArray showNumber:(NSInteger)showNumber tradingType:(TradingType)type;

@end

NS_ASSUME_NONNULL_END
