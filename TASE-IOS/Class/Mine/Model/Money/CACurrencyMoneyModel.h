//
//  CACurrencyMoneyModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CACurrencyMoneyModel : CAFMDBModel

@property (nonatomic, copy) NSString * locked;
@property (nonatomic, copy) NSString * currency_code;
@property (nonatomic, copy) NSString * currency_code_big;
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * fiat;

@end

NS_ASSUME_NONNULL_END
