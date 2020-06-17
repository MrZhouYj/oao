//
//  CAOrderTopView.h
//  TASE-IOS
//
//   10/15.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAOrderTopView : UIView

@property (nonatomic, strong) CAOrderInfoModel * orderInfoModel;

@property (nonatomic, assign) NSInteger unreadMessagesCount;

@end

NS_ASSUME_NONNULL_END
