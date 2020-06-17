//
//  CADealTableViewCell.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CADealTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * dealData;

-(void)setTitleStyle;

@end

NS_ASSUME_NONNULL_END
