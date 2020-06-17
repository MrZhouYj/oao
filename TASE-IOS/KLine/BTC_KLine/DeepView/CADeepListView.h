//
//  CADeepListView.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CADeepListView : UIView

//0 买盘 1卖盘
@property (nonatomic, assign) int type;
@property (nonatomic, assign) CGFloat radio;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * num;
@property (nonatomic, copy) NSString * price;

-(void)clear;

@end

NS_ASSUME_NONNULL_END
