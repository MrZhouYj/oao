//
//  CAOrderModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAOrderModel : CAFMDBModel

@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * state_name;
@property (nonatomic, copy) NSString * unit_price;

@property (nonatomic, copy) NSString * otc_nick_name;
@property (nonatomic, copy) NSString * trading_currency_amount;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * mode_of_payment;

@property (nonatomic, copy) NSString * current_unit_price;
@property (nonatomic, copy) NSString * currency_amount;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * state_color;

@property (nonatomic, strong) NSArray * payment_methods;
@property (nonatomic, copy) NSString * crypto_amount;
@property (nonatomic, copy) NSString * fiat_amount;
@property (nonatomic, copy) NSString * fiat_type;
@property (nonatomic, copy) NSString * builder_id;
@property (nonatomic, copy) NSString * trade_type;
@property (nonatomic, copy) NSString * sell_or_buy;
@property (nonatomic, assign) BOOL is_canceled;


@end

NS_ASSUME_NONNULL_END
