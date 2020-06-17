//
//  CASkinManager.h
//  TASE-IOS
//
//   9/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CASkinManager : NSObject

+(void)initSkin;

+(void)setSkin:(NSString*)version;

+(NSString*)getCurrentSkinType;

@end

NS_ASSUME_NONNULL_END
