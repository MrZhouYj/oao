//
//  CALegalTopMenuView.h
//  TASE-IOS
//
//   9/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CALegalTopMenuViewDelegata <NSObject>

-(void)CALegalTopMenuView_didSelectedIndex:(NSString*)trade_type;

@end

@interface CALegalTopMenuView : UIView

@property (nonatomic, weak) id<CALegalTopMenuViewDelegata>delegata;

@end

NS_ASSUME_NONNULL_END
