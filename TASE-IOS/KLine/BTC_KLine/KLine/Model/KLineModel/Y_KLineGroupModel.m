//
//  Y-KLineGroupModel.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/28.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineGroupModel.h"
#import "Y_KLineModel.h"
@implementation Y_KLineGroupModel

-(NSMutableArray<Y_KLineModel *> *)models{
    if (!_models) {
        _models = @[].mutableCopy;
    }
    return _models;
}

+ (instancetype) objectWithArray:(NSArray *)arr {
    if (!arr.count) {
        return nil;
    }
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组");
    
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel new];
    NSMutableArray *mutableArr = @[].mutableCopy;
    __block Y_KLineModel *preModel = [[Y_KLineModel alloc]init];
    
    for (id dict in arr)
    {
        Y_KLineModel *model = [Y_KLineModel new];
        model.PreviousKlineModel = preModel;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [model initWithDict:dict];
        }else if ([dict isKindOfClass:[NSArray class]]){
            [model initWithArray:dict];
        }
        model.ParentGroupModel = groupModel;
        [mutableArr addObject:model];
        preModel = model;
//        NSLog(@"%@",model.Date);
//        NSLog(@"%@",[CommonMethod convertTimestampToString:[model.Date longLongValue]]);
    }
    
    [groupModel.models addObjectsFromArray:mutableArr];
    
    //初始化第一个Model的数据
    Y_KLineModel *firstModel = mutableArr[0];
    [firstModel initFirstModel];
    
    //初始化其他Model的数据
    [mutableArr enumerateObjectsUsingBlock:^(Y_KLineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model initData];
    }];

    return groupModel;
}

-(void)addData:(NSArray *)dic{
    
    Y_KLineModel * lastModel  = self.models.lastObject;
    Y_KLineModel * firstModel  = self.models.firstObject;
    
//    NSLog(@"%@-----%@----%@",lastModel.Date,dic.firstObject,firstModel.Date);
    if ([NSStringFormat(@"%@",lastModel.Date) isEqualToString:NSStringFormat(@"%@",dic.firstObject)]) {
       
        [lastModel initWithArray:dic];
        [lastModel initData];
        
    }else{
        
        Y_KLineModel * model = [Y_KLineModel new];
        model.PreviousKlineModel = lastModel;
        [model initWithArray:dic];
        model.ParentGroupModel = self;
        [self.models addObject:model];
        [model initData];

    }
}

@end
