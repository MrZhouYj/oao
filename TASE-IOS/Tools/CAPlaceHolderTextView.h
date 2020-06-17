//
//  CAPlaceHolderTextView.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPlaceHolderTextView : UITextView

@property (nonatomic, strong) UIColor *placeholdColor;
@property (nonatomic, copy) NSString * placeholder;

@end

NS_ASSUME_NONNULL_END
