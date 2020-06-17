//
//  CACountryModel.h
//  CADAE-IOS
//
//  Created by 周永建 on 2019/11/12.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CACountryModel : CAFMDBModel

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;


@end

NS_ASSUME_NONNULL_END
