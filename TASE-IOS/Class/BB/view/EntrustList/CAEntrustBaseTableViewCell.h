//
//  CAEntrustBaseTableViewCell.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEntrustModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAEntrustBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) CAEntrustModel * model;

/**卖出 or 买入*/
@property (nonatomic, strong) UILabel * typeLabel;
/**币种*/
@property (nonatomic, strong) UILabel * currencyLabel;

-(void)initSubview;

-(void)initLabel:(NSArray*)labels isUp:(BOOL)isUp;

-(void)layout:(NSArray*)labels topView:(UILabel*)topLabel space:(CGFloat)topSpace;

@end

NS_ASSUME_NONNULL_END
