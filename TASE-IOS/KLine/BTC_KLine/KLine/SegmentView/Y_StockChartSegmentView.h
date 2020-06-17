//
//  Y_StockChartSegmentView.h
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartView.h"

FOUNDATION_EXPORT NSString * const CAStockChartSegmentKey;

@class Y_StockChartSegmentView;

@protocol Y_StockChartSegmentViewDelegate <NSObject>

- (void)y_StockChartSegmentView:(Y_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;

@end

@interface Y_StockChartSegmentView : UIView

- (instancetype)initWithItems:(NSArray *)items;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id <Y_StockChartSegmentViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, assign) BOOL isFullScreen;

@end