//
//  CABBMenuView.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CABBMenuView : UIView

@property (nonatomic, copy) NSString * title;
//sell buy
@property (nonatomic, copy) NSString * sell_or_buy;

@property (nonatomic, assign,getter=isSelect) BOOL select;

@end

NS_ASSUME_NONNULL_END
