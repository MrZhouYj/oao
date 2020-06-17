//
//  CACountryModel.m
//  CADAE-IOS
//
//  Created by 周永建 on 2019/11/12.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CACountryModel.h"

@implementation CACountryModel

+(NSArray*)getModels:(NSArray*)array{
    
    if (array.count) {
        NSMutableArray * marketsArray = @[].mutableCopy;
           for (NSDictionary * dic in array) {
               CACountryModel * model = [CACountryModel new];
               [model setValuesForKeysWithDictionary:dic];
               [marketsArray addObject:model];
           }
        [CACountryModel clearTable];
        [CACountryModel saveObjects:marketsArray];
               
        return marketsArray;
    }else{
        return [CACountryModel findAll];
    }
}


@end
