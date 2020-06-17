//
//  CABiBiIOView.h
//  TASE-IOS
//
//   9/20.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CABiBiIOViewDelegata <NSObject>

-(void)gotoLoginController;

@end

@interface CABiBiIOView : UIView

@property (nonatomic, weak) id<CABiBiIOViewDelegata> delegata;

@property (nonatomic, assign) TradingType tradeType;

@property (nonatomic, assign) BOOL isFirstSetPriceStr;

@property (nonatomic, assign) BOOL enableOperntion;

@property (nonatomic, copy) NSString * priceStr;

//"ask_currency_scale" : 4,
//"bid_currency_precision" : 32,
//"bid_currency_scale" : 4,
//"ask_currency_precision" : 32
@property (nonatomic, strong) NSDictionary * precision;

//"ask_currency_amount" : "0.6667",
//"bid_currency_amount" : "0.0"
@property (nonatomic, strong) NSDictionary * member_assets;

@property (nonatomic, strong) NSArray * ask_rate;
//6.97,¥,CNY,
@property (nonatomic, strong) NSArray * bid_rate;

@property (nonatomic, copy) NSString * ask_code;

@property (nonatomic, copy) NSString * bid_code;

@property (nonatomic, copy) NSString * market_id;

-(void)judgeLogin;

@end

NS_ASSUME_NONNULL_END
