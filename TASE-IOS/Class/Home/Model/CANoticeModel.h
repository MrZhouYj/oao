//
//  CANoticeModel.h
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"


@interface CANoticeModel : CAFMDBModel

@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;

@end

