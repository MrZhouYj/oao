//
//  CABannerModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABannerModel.h"

@implementation CABannerModel

+(NSArray*)getModels:(NSArray*)array{
    
    if (array.count) {
        NSMutableArray * marketsArray = @[].mutableCopy;
           for (NSDictionary * dic in array) {
               CABannerModel * model = [CABannerModel new];
               [model setValuesForKeysWithDictionary:dic];
               [marketsArray addObject:model];
           }
        
        [CABannerModel clearTable];
        [CABannerModel saveObjects:marketsArray];
        NSLog(@"marketsArray%@",marketsArray);
        return marketsArray;
    }else{
        return [CABannerModel findAll];
    }
}


@end
