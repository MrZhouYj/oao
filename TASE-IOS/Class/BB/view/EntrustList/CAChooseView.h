//
//  CAChooseView.h
//  TASE-IOS
//
//   10/21.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CAChooseViewDelegate <NSObject>

-(void)CAChooseView_didSelectIndex:(NSInteger)index;

@end

@interface CAChooseView : UIView

@property (nonatomic, weak) id<CAChooseViewDelegate> delegata;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
