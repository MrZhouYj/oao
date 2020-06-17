//
//  CADeepListTableViewCell.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CADeepListTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * ask_code;
@property (nonatomic, copy) NSString * bid_code;

-(void)fresh:(NSArray*)buyArr sellArr:(NSArray*)sellArr;

@end

NS_ASSUME_NONNULL_END
