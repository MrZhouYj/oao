//
//  CAFriendsModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAFriendsModel : CAFMDBModel

@property (nonatomic, copy) NSString * nick_name;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * inviter_code;

@end

NS_ASSUME_NONNULL_END
