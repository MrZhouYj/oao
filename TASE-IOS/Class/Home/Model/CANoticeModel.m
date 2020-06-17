//
//  CANoticeModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CANoticeModel.h"

@implementation CANoticeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   if([key isEqualToString:@"id"])
     self.ID = value;
}

+(NSArray*)getModels:(NSArray*)array{
    
    if (array.count) {
        NSMutableArray * marketsArray = @[].mutableCopy;
           for (NSDictionary * dic in array) {
               CANoticeModel * model = [CANoticeModel new];
               [model setValuesForKeysWithDictionary:dic];
               [marketsArray addObject:model];
           }
        [CANoticeModel clearTable];
        [CANoticeModel saveObjects:marketsArray];
               
        return marketsArray;
    }else{
        return [CANoticeModel findAll];
    }
}

@end
