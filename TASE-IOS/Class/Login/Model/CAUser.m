//
//  CAUser.m
//  CADAE-IOS
//
//  Created by 周永建 on 2019/11/14.
//  Copyright © 2019 CA. All rights reserved.
//

NSString * const CAUserDidSignInSuccessNotifacation = @"CAUserDidSignInSuccessNotifacation";//登录成功通知
NSString * const CAUserDidSignOutSuccessNotifacation = @"CAUserDidSignOutSuccessNotifacation";//登出成功通知
NSString * const CAUserDidChangedUserInfomationNotifacation = @"CAUserDidChangedUserInfomationNotifacation";//用户信息修改了

#import "CAUser.h"
#import <objc/runtime.h>

@implementation CAUser

+(instancetype)currentUser{
    static CAUser * user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        user = [CAUser new];
        [user copyLoaclSqlLite];
    });
    return user;
}

- (id)copyWithZone:(NSZone *)zone {
    CAUser *model = [[self class] allocWithZone:zone];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([CAUser class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [model setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    
    return model;
}

-(void)copyLoaclSqlLite{
    NSArray * users = [CAUser findAll];
    //数据库暂时就存一条
    if (users.count) {
        CAUser * user = users.firstObject;
        self.public_key = user.public_key;
        self.private_key = user.private_key;
        self.qrcode = user.qrcode;
        self.invitation_code = user.invitation_code;
    }
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initPropertys];
    }
    return self;
}

-(void)initPropertys{
    
    self.public_key = @"";
    self.private_key = @"";
    self.nick_name = @"";
    self.uid = @"";
    self.real_name = @"";
    self.identity_state = @"";
    self.identity_state_name = @"";
    self.app_token = @"";
    self.qrcode = @"";
    self.invitation_code = @"";
}

-(void)setNilValueForKey:(NSString *)key{
    if ([key isEqualToString:@"public_key"]) {
        self.public_key = @"";
    }
}

-(void)setPublic_key:(NSString *)public_key{
    _public_key = public_key;
    if (_public_key&&_public_key.length) {
        self.isAvaliable = YES;
    }else{
        self.isAvaliable = NO;
    }
}

-(void)creatUser:(NSDictionary *)dic{
    
    [CAUser clearTable];
    [self dealData:dic];
    [self save];
    [self getUserDetails:^{}];
    [self getUserInvitationCode:^{
        
    }];
}

-(void)dealData:(NSDictionary*)dic{
    
    NSArray * allKeys = dic.allKeys;
    NSArray * allProp = self.columeNames;
  
    for (NSString * key in allKeys) {
       if ([allProp containsObject:key]) {
           if (dic[key]) {
               [self setValue:dic[key] forKey:key];
           }
       }
    }
}

-(void)getUserDetails:(void (^)(void))successBlock{
    
    if (!self.isAvaliable) {
        return;
    }
    
    
    [CANetworkHelper GET: CAAPI_MINE_PERSONAL_CENTER  parameters:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseObject[@"code"] integerValue]==20000) {
                
                [self updateUserInfo:responseObject[@"data"]];
                if (successBlock) {
                    successBlock();
                }
            }
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(BOOL)is_identified_success{
    
    if ([self.identity_state isEqualToString:@"authentication_successful"]) {
        return YES;
    }
    return NO;
}

-(void)updateUserInfo:(NSDictionary *)dic{
  
    [self dealData:dic];
  
    [self update];
}

-(void)signOutCurrentUser{
    
    [self initPropertys];
    
    [CAUser clearTable];
}

-(void)getUserInvitationCode:(void (^)(void))successBlock{
    
    if (!self.isAvaliable) {
        return;
    }
//    if (self.qrcode.length&&self.invitation_code.length) {
//        successBlock();
//        return;
//    }
    [CANetworkHelper GET:CAAPI_MINE_INVITATION_CODE parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==20000) {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                self.qrcode = data[@"qrcode"];
                self.invitation_code = data[@"invitation_code"];
                [self update];
            }
        }
        if (successBlock) {
            successBlock();
        }
    } failure:^(NSError *error) {
        successBlock();
    }];
}

@end
