//
//  MegNetword.h
//  TASE-IOS
//
//  Created by 周永建 on 2020/6/16.
//  Copyright © 2020 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^RequestSuccess)(NSInteger statusCode, NSDictionary* responseObject);
typedef void(^RequestFailure)(NSInteger statusCode, NSError* error);

@interface MegNetwork : NSObject

+ (MegNetwork *)singleton;

- (void)queryDemoMGFaceIDAntiSpoofingBizTokenWithUserName:(NSString *)userNameStr idcardNumber:(NSString *)idcardNumberStr liveConfig:(NSDictionary *)liveInfo success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

- (void)queryDemoMGFaceIDAntiSpoofingVerifyWithBizToken:(NSString *)bizTokenStr verify:(NSData *)megliveData success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

- (NSString *)getFaceIDSignStr;
- (NSString *)getFaceIDSignVersionStr;

@end

NS_ASSUME_NONNULL_END
