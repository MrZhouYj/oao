//
//  CAEnTrustTableView.h
//  TASE-IOS
//
//   10/21.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAFreshTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAEnTrustTableView : CAFreshTableView

@property (nonatomic, assign) BOOL isHistory;
@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) NSInteger total_page;
@property (nonatomic, assign) BOOL isLoadingData;
@property (nonatomic, strong) NSMutableArray * datas;

-(void)setStateToIdle;

-(void)noMoreData;

-(void)endFresh;

@end

NS_ASSUME_NONNULL_END
