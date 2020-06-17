//
//  CAAddPayViewController.h
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAAddPayViewController : CABaseViewController

// 0 支付宝 1 微信 2 银行卡
@property (nonatomic, copy) NSString * payType;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
