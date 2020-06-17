//
//  CAChatHelper.h
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAChatHelper : NSObject

+(CAMessageModel*)initImageMessage:(UIImage*)originImage imageMessageModel:(CAMessageModel*)model;

+ (CGSize)caculateImageSize:(CGSize)imageSize;

+ (NSString*)removeEmoji:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
