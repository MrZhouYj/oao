//
//  MegNetword.m
//  TASE-IOS
//
//  Created by 周永建 on 2020/6/16.
//  Copyright © 2020 CA. All rights reserved.
//

#import "MegNetwork.h"

#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <math.h>
#import <AFNetworking/AFNetworking.h>

#define kMGFaceIDNetworkHost @"https://api.megvii.com"
#define kMGFaceIDNetworkTimeout 30

@implementation MegNetwork

static MegNetwork* sing = nil;
static AFHTTPSessionManager* sessionManager = nil;
+ (MegNetwork *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sing = [[MegNetwork alloc] init];
        sessionManager = [[AFHTTPSessionManager manager] init];
    });
    return sing;
}


- (void)queryDemoMGFaceIDAntiSpoofingBizTokenWithUserName:(NSString *)userNameStr idcardNumber:(NSString *)idcardNumberStr liveConfig:(NSDictionary *)liveInfo success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock {
    
    [sessionManager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"idcard_name" : userNameStr,
                                                                                    @"idcard_number" : idcardNumberStr,
                                                                                    @"sign" : [self getFaceIDSignStr],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr],
                                                                                    @"comparison_type" : @"1" ,
                                                                                    }];
    [params addEntriesFromDictionary:liveInfo];
    NSLog(@"%@",params);
    [sessionManager POST:[NSString stringWithFormat:@"%@/faceid/v3/sdk/get_biz_token", kMGFaceIDNetworkHost]
              parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
}

- (void)queryDemoMGFaceIDAntiSpoofingVerifyWithBizToken:(NSString *)bizTokenStr verify:(NSData *)megliveData success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock {
    [sessionManager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"sign" : [self getFaceIDSignStr],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr],
                                                                                    @"biz_token" : bizTokenStr,
                                                                                    }];
    [sessionManager POST:[NSString stringWithFormat:@"%@/faceid/v3/sdk/verify", kMGFaceIDNetworkHost]
              parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:megliveData name:@"meglive_data" fileName:@"meglive_data" mimeType:@"text/html"];
}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
}



- (NSString *)getFaceIDSignStr {
    int valid_durtion = 1000;
    long int current_time = [[NSDate date] timeIntervalSince1970];
    long int expire_time = current_time + valid_durtion;
    long random = labs(arc4random() % 100000000000);
    NSString* str = [NSString stringWithFormat:@"a=%@&b=%ld&c=%ld&d=%ld", kApiKey, expire_time, current_time, random];
    const char *cKey  = [kApiSecret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [str cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSData* sign_raw_data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [[NSMutableData alloc] initWithData:HMAC];
    [data appendData:sign_raw_data];
    NSString* signStr = [data base64EncodedStringWithOptions:0];
    return signStr;
}

- (NSString *)getFaceIDSignVersionStr {
    return @"hmac_sha1";
}

@end
