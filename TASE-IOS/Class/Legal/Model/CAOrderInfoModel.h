//
//  CAOrderInfoModel.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/22.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CALogalOrderActionCancle,//取消订单
    CALogalOrderActionHasPaied,//我已成功付款
    CALogalOrderActionExpendTime,//延长付款时间
    CALogalOrderActionAppeal,//申诉
    CALogalOrderActionReleaseCoin,//放币
} CALogalOrderAction;

typedef enum : NSUInteger {
    CAOrderStateUnkonwn,//未知状态 
    CAOrderStateWaitingPay,//用户刚下单 待支付
    CAOrderStateHasExpendTime,//用户点击了延长支付时间 此时还是待支付
    CAOrderStateOverTime,//用户没有按时支付 并且没有点击延长支付时间 导致订单变为 已超时
    CAOrderStateCanceled,//用户手动取消
    CAOrderStateWaitingCoinRelease,//用户已支付  变为 待放币
    CAOrderStateFinshed,//订单已完成
} CALogalOrderState;
//已取消 待支付 待放币 已完成 申诉中
@interface CAOrderInfoModel : CAFMDBModel

@property (nonatomic, copy  ) NSString * member_otc_nick_name;
@property (nonatomic, strong) NSDictionary *  payment_methods;
@property (nonatomic, copy  ) NSString * trading_remark;
@property (nonatomic, assign) BOOL is_timeout;
@property (nonatomic, assign) BOOL is_overtime;
@property (nonatomic, assign) BOOL is_builder;
@property (nonatomic, assign) BOOL is_canceled;
//用来区分是否显示支付信息 和 区分显示的订单操作按钮
@property (nonatomic, assign) BOOL is_showPaymethod;
//\用来区分是支付的人 和 放币的人
@property (nonatomic, assign) BOOL is_buyer;
@property (nonatomic, assign) BOOL hasContent;

@property (nonatomic, copy) NSString * sn;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * currency_code;
@property (nonatomic, copy) NSString * fiat_type;
@property (nonatomic, copy) NSString * fiat_amount;
@property (nonatomic, copy) NSString * ad_trade_type;
@property (nonatomic, copy) NSString * currency_id;
@property (nonatomic, copy) NSString * member_mobile;
@property (nonatomic, copy) NSString * builder_mobile;
@property (nonatomic, copy) NSString * currency_icon;
@property (nonatomic, copy) NSString * current_server_time;
@property (nonatomic, copy) NSString * builder_calling_code;
@property (nonatomic, copy) NSString * progress;
@property (nonatomic, copy) NSString * currency_amount;
@property (nonatomic, copy) NSString * builder_otc_nick_name;
@property (nonatomic, copy) NSString * trade_type;
@property (nonatomic, copy) NSString * current_unit_price;
@property (nonatomic, copy) NSString * member_calling_code;
@property (nonatomic, copy) NSString * created_at;
@property (nonatomic, copy) NSString * expired_at;
@property (nonatomic, copy) NSString * trading_terms;
@property (nonatomic, copy) NSString * dispute_status;
@property (nonatomic, copy) NSString * builder_real_name;
@property (nonatomic, copy) NSString * member_real_name;
@property (nonatomic, copy) NSString * payment;

@property (nonatomic, assign) CALogalOrderState order_state;
//@property (nonatomic, copy) NSString * order_state_name;
@property (nonatomic, copy) NSString * state_name;

@property (nonatomic, strong) NSArray * actionButtons;
@property (nonatomic, strong) NSArray <NSString*>* supportPayMethods;

@property (nonatomic, copy) NSString * showNickName;
@property (nonatomic, copy) NSString * showRealName;
@property (nonatomic, copy) NSString * notiShowNikeName;
@property (nonatomic, copy) NSString * notiShowRealName;

@property (nonatomic, copy) NSString * notiPay;



-(void)initWithDictionary:(NSDictionary*)dic;


@end

NS_ASSUME_NONNULL_END
