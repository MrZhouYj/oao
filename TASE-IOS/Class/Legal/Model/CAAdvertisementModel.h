//
//  CAAdvertisementModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

@interface CAAdvertisementModel : CAFMDBModel

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * builder_id;
@property (nonatomic, copy) NSString * max_limit;
@property (nonatomic, copy) NSString * trading_currency_amount;
@property (nonatomic, copy) NSString * otc_nick_name;
@property (nonatomic, copy) NSString * unit_price;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * currency_id;
@property (nonatomic, copy) NSString * code_big;
@property (nonatomic, copy) NSString * min_limit;
@property (nonatomic, copy) NSString * trade_type;
@property (nonatomic, copy) NSString * shelves_status;
@property (nonatomic, copy) NSString * shelves_color;
@property (nonatomic, strong) NSArray * payment_methods;
@property (nonatomic, copy) NSString * favorable_rate;
@property (nonatomic, assign) BOOL is_canceled;
//自定义字段
@property (nonatomic, copy) NSString * first_name;

-(NSString*)stringByLinkWithComma:(NSArray*)pays;

@end


