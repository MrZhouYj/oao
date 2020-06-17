//
//  CAMineView.h
//  TASE-IOS
//
//   9/18.
//  Copyright © 2019 CA. All rights reserved.
//


#import "CABaseAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CAMineViewDelegate <NSObject>

-(void)cellDidSelected:(UIViewController*)controller;

-(void)gotoLoginController;

-(void)shareApp;
-(void)contactUsClick;
@end

@interface CAMineView : CABaseAnimationView

@property (nonatomic, weak) id<CAMineViewDelegate> delegata;

@end

NS_ASSUME_NONNULL_END
