//
//  CAChatView.h
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseAnimationView.h"
@class CAMessageModel;
@class CAOrderInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface CAChatView : CABaseAnimationView

@property (nonatomic,weak) UIViewController  *viewController; //-> 一定是weak

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, strong) CAOrderInfoModel * orderInfoModel;
@property (nonatomic, assign) NSInteger unreadMessagesCount;

- (void)getMessage;

- (void)subscribeChat;

- (void)unSubscribeChat;

@end

NS_ASSUME_NONNULL_END
