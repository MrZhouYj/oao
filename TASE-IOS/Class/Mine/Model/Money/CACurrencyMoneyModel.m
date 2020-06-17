//
//  CACurrencyMoneyModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CACurrencyMoneyModel.h"

@implementation CACurrencyMoneyModel

+(NSArray*)getModels:(NSArray*)array{
    
    NSMutableArray * marketsArray = @[].mutableCopy;
    for (NSDictionary * dic in array) {
        CACurrencyMoneyModel * model = [CACurrencyMoneyModel new];
        [model setValuesForKeysWithDictionary:dic];
        [marketsArray addObject:model];
    }
    return marketsArray;
    
}

-(NSString *)currency_code_big{
    return [self.currency_code uppercaseString];
}

@end
