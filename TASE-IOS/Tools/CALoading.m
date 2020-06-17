//
//  CALoading.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CALoading.h"
//#import <Lottie/Lottie.h>

@interface CALoading()

//@property (nonatomic, strong) LOTAnimationView * loading;

@end

@implementation CALoading

+(instancetype)shareLoading{
    static dispatch_once_t onceToken;
    static CALoading * loading = nil;
    dispatch_once(&onceToken, ^{
        loading = [CALoading new];
    });
    return loading;
}

//-(LOTAnimationView *)loading{
//    if (!_loading) {
//        _loading = [LOTAnimationView animationNamed:@"nd_middle_bg"];
//        _loading.loopAnimation = YES;
//        [[UIApplication sharedApplication].delegate.window addSubview:_loading];
//        [_loading mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.equalTo([UIApplication sharedApplication].delegate.window);
//            make.width.height.equalTo(@60);
//        }];
//    }
//    return _loading;
//}

-(void)startLoading{
//    [self.loading play];
}
-(void)stopLoading{
//    [self.loading stop];
}

+(void)startLoading{

    [[CALoading shareLoading] startLoading];
}
+(void)stopLoading{
    
    [[CALoading shareLoading] stopLoading];
}

@end
