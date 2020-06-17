//
//  NSTimer+AutoRelease.m
//  TASE-IOS
//
//   10/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import "NSTimer+AutoRelease.h"

@implementation AutoReleaseObject

-(void)dealloc{
    
}

-(void)timerAction:(NSTimer*)timer{
    
    [self.target performSelector:self.selctor withObject:timer afterDelay:0.0];
}

@end

@implementation NSTimer (AutoRelease)

+(NSTimer*)scheduledAutoReleaseTimerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)sel userinfo:(id)userInfo repeats:(BOOL)isRepeat{
    AutoReleaseObject * object = [AutoReleaseObject alloc];
    object.selctor = sel;
    object.target = target;
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:time target:object selector:@selector(timerAction:) userInfo:userInfo repeats:isRepeat];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    return timer;
}

@end
