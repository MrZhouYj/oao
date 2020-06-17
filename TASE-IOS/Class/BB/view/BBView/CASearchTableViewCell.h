//
//  CASearchTableViewCell.h
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CACountryModel.h"
#import "CASymbolsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CASearchTableViewCell : UITableViewCell

@property (nonatomic, strong) CASymbolsModel * model;

@property (nonatomic, strong) CACountryModel * countryModel;

@end

NS_ASSUME_NONNULL_END
