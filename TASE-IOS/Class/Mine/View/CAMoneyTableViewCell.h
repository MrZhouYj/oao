//
//  CAMoneyTableViewCell.h
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CACurrencyMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAMoneyTableViewCell : UITableViewCell

@property (nonatomic, strong) CACurrencyMoneyModel * model;

@end

NS_ASSUME_NONNULL_END
