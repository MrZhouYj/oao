//
//  CASymbolsModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASymbolsModel.h"
#
NSString * const CAMaretSortKey = @"CAMaretSortKey";
NSString * const CAMaretDefaultMarketId = @"CAMaretDefaultMarketId";
NSString * const CAMaretDefaultMarketIsDefault = @"CAMaretDefaultMarketIsDefault";
NSString * const CAMaretFavourites = @"CAMaretFavourites";
NSString * const CASymbolsLocalSqlliteDidChange = @"CASymbolsLocalSqlliteDidChange";

@implementation CASymbolsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   
    
}
+(NSArray*)getModels:(NSArray*)array{
    
    
    if (array.count) {
        NSMutableArray * marketsArray = @[].mutableCopy;
        for (int i=0; i<array.count; i++) {
            CASymbolsModel * model = [CASymbolsModel new];
            [model dealData:array[i]];
            [marketsArray addObject:model];
        }
        
        [CASymbolsModel clearTable];
        [CASymbolsModel saveObjects:marketsArray];
        
        return marketsArray;
    }else{
        return [CASymbolsModel findAll];
    }
}

+ (NSArray *)getSymbolsBy:(NSString *)bid_unit{
    
    NSString * sql = NSStringFormat(@"WHERE bid_unit_name = '%@'",bid_unit);
    NSArray * localData = [CASymbolsModel findByCriteria:sql];
    
    return localData;
}



+ (CASymbolsModel *)getDefultSymbol{
    
    NSString * defaultMarketId = [CommonMethod readFromUserDefaults:CAMaretDefaultMarketId];
    if (!defaultMarketId.length) {
        defaultMarketId = @"cgusdt";
    }
    
    NSString * sql = NSStringFormat(@"WHERE market_id = '%@'",defaultMarketId);
    NSArray * localData = [CASymbolsModel findByCriteria:sql];
    if (!localData.count) {
        localData = [CASymbolsModel findAll];
    }
    if (localData.count) {
        return localData.firstObject;
    }
    
    return nil;
}

-(void)dealData:(NSDictionary*)dic{
    
    NSArray * allKeys = dic.allKeys;
    NSArray * allProp = self.columeNames;
    for (NSString * key in allKeys) {
       if ([allProp containsObject:key]) {
           if ([key isEqualToString:@"price_change_ratio"]) {
               if ([dic[key] containsString:@"--"]) {
                   [self setValue:@"0.00%" forKey:key];
               }else{
                   [self setValue:dic[key] forKey:key];
               }
           }else if ([key isEqualToString:@"ask_rate"]) {
               if ([dic[@"ask_rate"] isKindOfClass:[NSArray class]]) {
                   NSArray * ask_rate = dic[@"ask_rate"];
                   if (ask_rate.count==3) {
                       self.ask_m = NSStringFormat(@"%@",ask_rate.firstObject);
                       self.ask_c = NSStringFormat(@"%@",ask_rate.lastObject);
                       self.ask_s = NSStringFormat(@"%@",ask_rate[1]);
                   }
               }
               
           }else if (dic[key]) {
               [self setValue:dic[key] forKey:key];
           }
       }
    }
}

+(void)getMarketList:(CASymbolsModelGetListSuccess)block{

    [CANetworkHelper GET:CAAPI_CRYPTO_TO_CRYPTO_GET_MARKETS parameters:nil success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==20000) {
            NSArray * markets = responseObject[@"data"][@"markets"];
            NSArray * market_sort = responseObject[@"data"][@"market_sort"];
            if (markets.count) {
                [CASymbolsModel getModels:markets];
            }
            if (market_sort.count) {
                [CommonMethod writeToUserDefaults:market_sort withKey:CAMaretSortKey];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:CASymbolsLocalSqlliteDidChange object:nil];
//                });
            }
            if (block) {
                block();
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


+ (NSArray *)getCurrenciesByCoinRegion:(NSString*)coinRegion{
    
    NSString * sql = NSStringFormat(@"WHERE coin_region = '%@'",coinRegion) ;
    NSArray * localData = [CASymbolsModel findByCriteria:sql];
    NSArray * segments = [CommonMethod readFromUserDefaults:CAMaretSortKey];
    if (localData.count&&segments.count) {
        
        NSMutableArray * symbols = @[].mutableCopy;
        for (CASymbolsModel * model in localData) {
            if (![symbols containsObject:model.bid_unit]&&[segments containsObject:model.bid_unit]) {
                [symbols addObject:model.bid_unit];
            }
        }
        NSLog(@"===%@",symbols);
        [symbols sortUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
            if ([segments containsObject:obj1]&&[segments containsObject:obj2]) {
                return [segments indexOfObject:obj1]>[segments indexOfObject:obj2];
            }
            return NSOrderedSame;
        }];
        NSLog(@"===%@",symbols);
        
        return symbols;
    }
    return @[];
}

+ (NSArray *)getMainCurrencies{
    
    return [self getCurrenciesByCoinRegion:@"main"];
}

+ (NSArray *)getInnovationCurrencies{
    
    return [self getCurrenciesByCoinRegion:@"innovation"];
}

+ (NSArray *)getAllCurrencies{
    
    NSArray * segments = [CommonMethod readFromUserDefaults:CAMaretSortKey];

    if (segments.count) {
        return segments;
    }
    return @[];
}
+ (NSArray*)screenMarketsListWithCoinRegion:(NSString*)coinRegion currencyCode:(NSString*)code sortKey:(NSString*)sortKey sortType:(CASymbolsSortType)type{
    
    NSArray * localData;
    
    if ([coinRegion isEqualToString:@"favourite"]) {
        localData = [CASymbolsModel getSymbolsFav];
    }else{
        NSString * sql = NSStringFormat(@"WHERE bid_unit_name = '%@'",code);
        if (![coinRegion isEqualToString:@"all"]) {
           sql = [sql stringByAppendingFormat:@" AND coin_region = '%@'",coinRegion];
        }
        localData = [CASymbolsModel findByCriteria:sql];
    }
    if (localData.count&&type!=CASymbolsSortTypeNone) {
       localData = [localData sortedArrayUsingComparator:^NSComparisonResult(CASymbolsModel*  _Nonnull obj1, CASymbolsModel*  _Nonnull obj2) {
           NSString * obj1s = [obj1 valueForKey:sortKey];
           NSString * obj2s = [obj2 valueForKey:sortKey];
           
        if([CommonMethod isAllEnglish:obj1s]){
               return type==CASymbolsSortTypeAsc?[obj1s compare:obj2s]:[obj2s compare:obj1s];
           }else {
               return type==CASymbolsSortTypeAsc?(obj1s.floatValue > obj2s.floatValue):(obj2s.floatValue > obj1s.floatValue);
           }
           return NSOrderedSame;
        }];
    }
    return localData;
}

+(void)getAllFavouriteMarkets:(CASymbolsModelGetListSuccess)block{
    
    [CANetworkHelper GET:CAAPI_CRYPTO_TO_CRYPTO_SHOW_ALL_FAVOURITE_MARKETS_DETAILS parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==20000) {
            NSArray * data = responseObject[@"data"];
            if (data.count) {
                NSMutableArray * market_ids = @[].mutableCopy;
                for (NSDictionary * dic in data) {
                    [market_ids addObject:dic[@"market_id"]];
                }
                [CommonMethod writeToUserDefaults:market_ids withKey:CAMaretFavourites];
            }else{
                [CommonMethod removeFromUserDefaults:CAMaretFavourites];
            }
            if (block) {
                block();
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

+(NSArray *)getSymbolsFav{
   
    NSArray * localFav = [CommonMethod readFromUserDefaults:CAMaretFavourites];
    if (localFav&&localFav.count) {
        NSMutableArray * mut = @[].mutableCopy;
        for (NSString * market_id in localFav) {
            NSString * sql = NSStringFormat(@"WHERE market_id = '%@'",market_id);
            CASymbolsModel * model = [CASymbolsModel findFirstByCriteria:sql];
            if (model) {
                [mut addObject:model];
            }
        }
        return mut.copy;
    }
    
    return @[];
}

+ (NSArray *)getHomeSymbols{
    
    NSString * sql = @"LIMIT 6";
    NSArray * local = [CASymbolsModel findByCriteria:sql];
    if (local) {
        return local;
    }
    return @[];
}

+(NSArray *)getSymbolsSortByPriceChangeRatio{
    NSArray * localData = [CASymbolsModel findAll];
    localData = [localData sortedArrayUsingComparator:^NSComparisonResult(CASymbolsModel*  _Nonnull obj1, CASymbolsModel*  _Nonnull obj2) {
    
          return obj1.price_change_ratio.floatValue<obj2.price_change_ratio.floatValue;
    }];
    return localData;
}

+(NSArray *)getSymbolsSortByPrice{
    NSArray * localData = [CASymbolsModel findAll];
    localData = [localData sortedArrayUsingComparator:^NSComparisonResult(CASymbolsModel*  _Nonnull obj1, CASymbolsModel*  _Nonnull obj2) {
    
        NSString * turnover1 = obj1.turnover;
        NSString * turnover2 = obj2.turnover;

        return [turnover1 doubleValue]<[turnover2 doubleValue];
    }];
    return localData;
}

+ (void)add_to_favorates:(NSString *)market_id finshed:(ActionResult)block{
    
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"market_id":NSStringFormat(@"%@",market_id)
    };
    [CANetworkHelper POST:CAAPI_CRYPTO_TO_CRYPTO_ADD_TO_FAVAORATES parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            
            NSArray * localFav = [CommonMethod readFromUserDefaults:CAMaretFavourites];
            if (localFav&&localFav.count) {
                NSMutableArray * mut = localFav.mutableCopy;
                [mut addObject:market_id];
                [CommonMethod writeToUserDefaults:mut withKey:CAMaretFavourites];
            }else{
                [CommonMethod writeToUserDefaults:@[market_id] withKey:CAMaretFavourites];
            }
            
            if (block) {
                block(YES);
            }
        }else{
            if (block) {
                block(NO);
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (block) {
            block(NO);
        }
    }];
}

+ (void)remove_from_favorates:(NSString *)market_id finshed:(ActionResult)block{
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"market_id":NSStringFormat(@"%@",market_id)
    };
    [CANetworkHelper POST:CAAPI_CRYPTO_TO_CRYPTO_REMOVE_FROM_FAVAORATES parameters:para success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            
            NSArray * localFav = [CommonMethod readFromUserDefaults:CAMaretFavourites];
            if (localFav&&localFav.count) {
                if ([localFav containsObject:market_id]) {
                    NSMutableArray * mut = localFav.mutableCopy;
                    [mut removeObject:market_id];
                    [CommonMethod writeToUserDefaults:mut withKey:CAMaretFavourites];
                }
            }
            
            if (block) {
                block(YES);
            }
        }else{
            if (block) {
                block(NO);
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (block) {
            block(NO);
        }
    }];
}

+ (NSString*)formatNumber:(NSString*)num{
    
    CGFloat floatNum = num.floatValue;
    NSString * outPut = @"";
    
    if (floatNum>1E9) {
        floatNum = floatNum/1E9;
        outPut = NSStringFormat(@"%.2fB",floatNum);
    }else if (floatNum>1E6){
        floatNum = floatNum/1E6;
        outPut = NSStringFormat(@"%.2fM",floatNum);
    }else if (floatNum>1E3){
        floatNum = floatNum/1E3;
        outPut = NSStringFormat(@"%.2fK",floatNum);
    }else{
        outPut = NSStringFormat(@"%.2f",floatNum);
    }
    return outPut;
}

@end
