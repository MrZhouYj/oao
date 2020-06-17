//
//  CAFMDBDatabase.h
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fmdb/FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAFMDBDatabase : NSObject

@property(nonatomic,strong,readonly)FMDatabaseQueue *dbQueue;
+ (instancetype)shareFMDBDatabase;
//创建文件夹，拼接数据库路径（此时数据库还没创建）
+ (NSString *)dbPath;

@end

NS_ASSUME_NONNULL_END
