//
//  CAHomeTableViewCell.h
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CASymbolsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAHomeTableViewCell : UITableViewCell

@property (nonatomic, assign) int cellStyle;
@property (nonatomic, assign) BOOL showInHome;
@property (nonatomic, strong) CASymbolsModel * model;

@end

NS_ASSUME_NONNULL_END
