//
//  CAOrderinfoCell.h
//  TASE-IOS
//
//  Created by ZEMac on 2020/2/4.
//  Copyright © 2020 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CAOrderInfoCellClick)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CAOrderinfoCell : UITableViewCell

@property (nonatomic, copy) NSString * leftTitle;

@property (nonatomic, copy , nullable) NSString *rightContentText;

@property (nonatomic, strong ,nullable) UIImage * rightContentImage;

@property (nonatomic, assign) BOOL showArrow;

@property (nonatomic, assign) BOOL enableCopy;

@property (nonatomic, copy) CAOrderInfoCellClick block;

@end

NS_ASSUME_NONNULL_END
