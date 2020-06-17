//
//  CAMineTableViewCell.h
//  TASE-IOS
//
//   9/17.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAMineTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * imageV;

@property (nonatomic, strong) UILabel * textLab;

@property (nonatomic, strong) NSDictionary * data;

@end

NS_ASSUME_NONNULL_END
