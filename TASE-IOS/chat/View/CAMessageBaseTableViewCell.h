//
//  CAMessageBaseTableViewCell.h
//  TASE-IOS
//
 
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAMessageBaseTableViewCell : UITableViewCell

@property(nonatomic,strong) CAMessageModel * messageModel;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIImageView *messageBackgroundImageView;

@end

NS_ASSUME_NONNULL_END
