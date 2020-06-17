//
//  CAOrderModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAOrderModel.h"

@implementation CAOrderModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   if([key isEqualToString:@"id"])
   {
       self.ID = value;
   }
}

-(NSString *)trade_type{
    if ([_trade_type isEqualToString:@"sell"]) {
        return CALanguages(@"卖出");
    }else{
        return CALanguages(@"购买");
    }
}

-(NSString *)sell_or_buy{
    if ([_sell_or_buy isEqualToString:@"sell"]) {
        return CALanguages(@"卖出");
    }else{
        return CALanguages(@"购买");
    }
}


-(void)setNilValueForKey:(NSString *)key{
    if ([key isEqualToString:@"is_canceled"]){
        self.is_canceled = false;
    }
}

+(NSArray*)getModels:(NSArray*)array{
    
    NSMutableArray * marketsArray = @[].mutableCopy;
    for (NSDictionary * dic in array) {
        CAOrderModel * model = [CAOrderModel new];
        [model setValuesForKeysWithDictionary:dic];
        [marketsArray addObject:model];
    }
      
    return marketsArray;
    
}

@end
