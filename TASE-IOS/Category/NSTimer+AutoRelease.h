//
//  NSTimer+AutoRelease.h
//  TASE-IOS
//
//   10/26.
//  Copyright © 2019 CA. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoReleaseObject : NSObject

@property (nonatomic, weak) id target;

@property (nonatomic) SEL selctor;

@end

@interface NSTimer (AutoRelease)

+(NSTimer*)scheduledAutoReleaseTimerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)sel userinfo:(nullable id)userInfo repeats:(BOOL)isRepeat;

@end

NS_ASSUME_NONNULL_END
