//
//  CAChatHeaderView.h
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CAOrderInfoModel;

@protocol CAChatHeaderViewDelegate <NSObject>

-(void)CAChatHeaderView_hideChatViewClick;

@end

@interface CAChatHeaderView : UIView

@property (nonatomic, weak) id<CAChatHeaderViewDelegate> delegate;

@property (nonatomic, strong) CAOrderInfoModel * orderInfoModel;

@end

NS_ASSUME_NONNULL_END
