//
//  CAOrderListTableViewCell.h
//  TASE-IOS
//
//   10/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAOrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) CAOrderModel * model;

+(CGFloat)getCellHeight;

@end

NS_ASSUME_NONNULL_END
