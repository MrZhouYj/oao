//
//  Y-StockChartView.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartConstant.h"

/**
 *  Y_StockChartView代理
 */
@class Y_KLineView;
@protocol Y_StockChartViewDelegate <NSObject>

- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType;

@end
/**
 *  Y_StockChartView数据源
 */
@protocol Y_StockChartViewDataSource <NSObject>

-(id) stockDatasWithIndex:(Y_KLineType)klineType;

@end


@interface Y_StockChartView : UIView

/**
 *  K线图View
 */
@property (nonatomic, strong) Y_KLineView *kLineView;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) BOOL isMoreTimeDataUpdate;

@property (nonatomic, strong) NSArray *itemModels;

@property (nonatomic, strong) NSArray *moreItemModels;

@property (nonatomic, strong) NSArray *indicatorItemModels;

@property (nonatomic, weak) id<Y_StockChartViewDelegate> delegate;

/**
 *  数据源
 */
@property (nonatomic, weak) id<Y_StockChartViewDataSource> dataSource;

/**
 *  当前选中的索引
 */
@property (nonatomic, assign) Y_KLineType currentKlineType;
@property (nonatomic, assign) Y_KLineType lastKlineType;


@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineStatus;
/**
副图类型
*/
@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineAccessoryViewStatus;


-(void) reloadData;

-(void) initSegmentData;

//指标点击
- (void)fullScreenTargetClickWithIndex:(NSInteger)index;

- (void)hideMoreViewAndIndicatorView;

@end

/************************ItemModel类************************/
@interface Y_StockChartViewItemModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) Y_StockChartCenterViewType centerViewType;

@property (nonatomic, assign) Y_KLineType klineType;

+ (instancetype)itemModelWithTitle:(NSString *)title
                         klineType:(Y_KLineType)klineType
                              type:(Y_StockChartCenterViewType)type;

@end
