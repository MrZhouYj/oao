//
//  CAHomeSegmentView.h
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    CAHomeSegmentIncreaseList=0,//涨幅榜
    CAHomeSegmentTurnoverList//成交额榜
}CAHomeSegmentType;

@protocol CAHomeSegmentViewDelegate <NSObject>

-(void)CAHomeSegmentViewDidSelectedIndex:(NSInteger)index;

@end

@interface CAHomeSegmentView : UIView

@property (nonatomic, weak) id<CAHomeSegmentViewDelegate> delegate;

@property (nonatomic, assign) CAHomeSegmentType curType;

@property (nonatomic, copy) NSString * symbol;

@end

NS_ASSUME_NONNULL_END
