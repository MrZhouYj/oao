//
//  CABBViewController.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class CASymbolsModel;

@interface CABBViewController : CABaseViewController

@property (nonatomic, strong) CASymbolsModel * currentSymbolModel;

-(void)didReciveSymbolModelFromOrtherController:(CASymbolsModel*)model type:(TradingType)type;

@end

NS_ASSUME_NONNULL_END
