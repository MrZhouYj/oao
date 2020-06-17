//
//  CAPayMethodsListTableViewCell.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPayMethodsListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, copy) NSString * key;

@end

NS_ASSUME_NONNULL_END
