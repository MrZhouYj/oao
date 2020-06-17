//
//  CAUser.h
//  CADAE-IOS
//
//  Created by 周永建 on 2019/11/14.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

FOUNDATION_EXPORT NSString * _Nullable const CAUserDidSignInSuccessNotifacation;//登录成功通知
FOUNDATION_EXPORT NSString * _Nullable const CAUserDidSignOutSuccessNotifacation;//登出成功通知
FOUNDATION_EXPORT NSString * _Nullable const CAUserDidChangedUserInfomationNotifacation;//

NS_ASSUME_NONNULL_BEGIN

@interface CAUser : CAFMDBModel

@property (nonatomic, copy) NSString * app_token;
@property (nonatomic, copy) NSString * public_key;
@property (nonatomic, copy) NSString * private_key;
@property (nonatomic, copy) NSString * nick_name;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * real_name;
@property (nonatomic, copy) NSString * identity_state;
@property (nonatomic, copy) NSString * identity_state_name;
@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * country;
@property (nonatomic, copy) NSString * id_card_number;
@property (nonatomic, copy) NSString * id_card_number_not_hide;

@property (nonatomic, copy) NSString * invitation_code;
@property (nonatomic, copy) NSString * qrcode;
@property (nonatomic, copy) NSString * test;

@property (nonatomic, assign) BOOL is_identified_success;//是否实名认证
@property (nonatomic, assign) BOOL is_read_my_identified_fail;

@property (nonatomic, assign) BOOL is_email_binded;
@property (nonatomic, assign) BOOL is_mobile_binded;
@property (nonatomic, assign) BOOL isAvaliable;//当前用户是否有效

+(instancetype)currentUser;

-(void)creatUser:(NSDictionary*)dic;

-(void)updateUserInfo:(NSDictionary*)dic;

-(void)signOutCurrentUser;

-(void)getUserDetails:(void(^)(void))successBlock;

-(void)getUserInvitationCode:(void(^)(void))successBlock;

@end

NS_ASSUME_NONNULL_END
