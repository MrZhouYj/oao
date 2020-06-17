//
//  CABBtradingHeaderRightView.h
//  TASE-IOS
//
//   9/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CABBTradingListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CABBtradingHeaderRightView : UIView

@property (nonatomic, strong) NSArray *asksArray;
@property (nonatomic, strong) NSArray *bidsArray;

- (void)updateCenterData:(NSArray*)bid_rate last_price:(NSString*)last_price;

- (void)updateUI;

@end

NS_ASSUME_NONNULL_END
