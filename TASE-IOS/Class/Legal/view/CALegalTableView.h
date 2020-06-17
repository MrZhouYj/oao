//
//  CALegalTableView.h
//  TASE-IOS
//
//   10/14.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAAdvertisementModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CALegalTableView : UIView

@property (nonatomic, strong) NSArray <CAAdvertisementModel*>* dataSourceArray;

@property (nonatomic, assign) BOOL isLoadingData;

-(void)setStateToIdle;

-(void)noMoreData;

-(void)endFresh;

@end

NS_ASSUME_NONNULL_END
