//
//  CASymbolsModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

typedef enum : NSUInteger {
    CASymbolsSortTypeAsc,
    CASymbolsSortTypeDesc,
    CASymbolsSortTypeNone,
} CASymbolsSortType;

FOUNDATION_EXPORT NSString * _Nullable const CAMaretSortKey;
FOUNDATION_EXPORT NSString * _Nullable const CAMaretDefaultMarketId;
FOUNDATION_EXPORT NSString * _Nullable const CAMaretDefaultMarketIsDefault;
FOUNDATION_EXPORT NSString * _Nullable const CAMaretFavourites;
FOUNDATION_EXPORT NSString * _Nullable const CASymbolsLocalSqlliteDidChange;

typedef void(^CASymbolsModelGetListSuccess)(void);
typedef void(^ActionResult)(BOOL);

NS_ASSUME_NONNULL_BEGIN

@interface CASymbolsModel : CAFMDBModel

@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * ask_unit;
@property (nonatomic, copy) NSString * bid_unit;
@property (nonatomic, copy) NSString * bid_unit_name;
@property (nonatomic, copy) NSString * is_stock;
@property (nonatomic, copy) NSString * turnover;
@property (nonatomic, copy) NSString * market_id;
@property (nonatomic, copy) NSString * last_price;
@property (nonatomic, copy) NSString * price_change_ratio;
@property (nonatomic, assign) BOOL is_addfavorite;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, copy) NSString * coin_region;

@property (nonatomic, copy) NSString * ask_m;//5.75,
@property (nonatomic, copy) NSString * ask_s;//¥,
@property (nonatomic, copy) NSString * ask_c;//CNY,

@property (nonatomic, strong) NSArray * ask_rate;
//主区叫 main 创新区叫innovation. 目前coin_region字段只有这两种可能
+ (CASymbolsModel*)getDefultSymbol;

+ (NSArray<CASymbolsModel*>*)getSymbolsBy:(NSString*)bid_unit;
//获取所有交易对
+ (void)getMarketList:(CASymbolsModelGetListSuccess)block;
//行情 主板 显示的币种
+ (NSArray*)getMainCurrencies;
//行情 创新版 显示的币种
+ (NSArray*)getInnovationCurrencies;
//行情 全部 显示的币种
+ (NSArray*)getAllCurrencies;

//行情筛选
+ (NSArray*)screenMarketsListWithCoinRegion:(NSString*)coinRegion currencyCode:(NSString*)code sortKey:(NSString*)sortKey sortType:(CASymbolsSortType)type;

//获取添加到自选的交易对
+ (void)getAllFavouriteMarkets:(CASymbolsModelGetListSuccess)block;
//获取添加到自选的交易对 本地
+ (NSArray*)getSymbolsFav;
//获取首页交易对 6个
+ (NSArray*)getHomeSymbols;

//获取首页涨幅榜
//获取首页成交额榜
+ (NSArray *)getSymbolsSortByPriceChangeRatio;
+ (NSArray *)getSymbolsSortByPrice;

+ (void)add_to_favorates:(NSString*)market_id finshed:(ActionResult)block;
+ (void)remove_from_favorates:(NSString*)market_id finshed:(ActionResult)block;

+ (NSString*)formatNumber:(NSString*)num;

@end

NS_ASSUME_NONNULL_END
