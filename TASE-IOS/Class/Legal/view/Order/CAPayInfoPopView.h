//
//  CAPayInfoPopView.h
//  TASE-IOS
//
//   10/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAPayInfoPopView : CAPopupView

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) NSDictionary *payDictionay;

@end

NS_ASSUME_NONNULL_END
