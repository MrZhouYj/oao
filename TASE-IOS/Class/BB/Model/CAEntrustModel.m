//
//  CAEntrustModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEntrustModel.h"

@implementation CAEntrustModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   if([key isEqualToString:@"id"])
   {
       self.ID = value;
   }
}
+(NSArray*)getModels:(NSArray*)array{
    
    NSMutableArray * marketsArray = @[].mutableCopy;
    for (NSDictionary * dic in array) {
        CAEntrustModel * model = [CAEntrustModel new];
        [model dealData:dic];
        [marketsArray addObject:model];
    }
      
    return marketsArray;
    
}

-(void)dealData:(NSDictionary*)dic{
    
      NSArray * allKeys = dic.allKeys;
      NSArray * allProp = self.columeNames;
      
      for (NSString * key in allKeys) {
          if ([allProp containsObject:key]) {
              if (dic[key]) {
                  [self setValue:dic[key] forKey:key];
              }
          }else{
              if ([key isEqualToString:@"id"]) {
                  self.ID = dic[key];
              }
          }
      }
      
}

@end
