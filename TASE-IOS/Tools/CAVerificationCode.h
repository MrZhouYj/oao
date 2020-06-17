//
//  CAVerificationCode.h
//  TASE-IOS
//
//   10/28.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CAVerificationCodeDelegate <NSObject>

-(void)CAVerficationCode_responesSuccess:(NSDictionary*)result identification:(NSString*)identification;

-(void)CAVerficationCode_responesFail_identification:(NSString*)identification;

@end

@interface CAVerificationCode : NSObject

@property (nonatomic, weak) id<CAVerificationCodeDelegate> delegate;

+(instancetype)shareVerificationCode;

-(void)startVerificationCode:(NSString*)identification;

@end

NS_ASSUME_NONNULL_END
