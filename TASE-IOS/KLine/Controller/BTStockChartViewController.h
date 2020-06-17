//
//  YStockChartViewController.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//  K线

#import <UIKit/UIKit.h>

@class CASymbolsModel;
@class CACurrencyModel;

typedef void(^buySellCoinbackBlock)(CASymbolsModel* model,TradingType type);

@interface BTStockChartViewController : CABaseViewController

@property (nonatomic, strong) CACurrencyModel *currencyModel;

@property (nonatomic, copy) buySellCoinbackBlock backBlock;

@property (nonatomic, strong) CASymbolsModel * currentSymbolModel;

@end
