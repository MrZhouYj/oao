//
//  BTBiInfoModel.h
//  Bitbt
//
//  Created by iOS on 2019/5/14.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTBiInfoModel : NSObject

@property (nonatomic, copy) NSString *introduction;//简介

@property (nonatomic, copy) NSString *published_at; //发行时间

@property (nonatomic, copy) NSString *full_name;

@property (nonatomic, copy) NSString *published_amount;//发行总量

@property (nonatomic, copy) NSString *tradable_amount;//流通总量

@property (nonatomic, copy) NSString *white_page_url; //白皮书

@property (nonatomic, copy) NSString *official_website;//官网

@property (nonatomic, copy) NSString *query_website;//区块查询

@property (nonatomic, assign) CGFloat desCellHeight;

@end

NS_ASSUME_NONNULL_END
