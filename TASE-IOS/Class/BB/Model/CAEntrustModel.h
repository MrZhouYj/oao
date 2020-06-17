//
//  CAEntrustModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAEntrustModel : CAFMDBModel

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * origin_volume;
@property (nonatomic, copy) NSString * sell_or_buy;
@property (nonatomic, copy) NSString * bid;
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * ask;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * market_id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * actual_volume;


@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * total_cost;
@property (nonatomic, copy) NSString * average_price;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * ask_or_bid;
@property (nonatomic, copy) NSString * ask_code;
@property (nonatomic, copy) NSString * bid_code;

-(void)dealData:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
