//
//  CAOrderInfoModel.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/22.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAOrderInfoModel.h"
#import "CAChoosePayTypeView.h"

@implementation CAOrderInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   if([key isEqualToString:@"id"])
     self.ID = NSStringFormat(@"%@",value);
}

-(NSArray<NSString *> *)supportPayMethods{
    NSMutableArray * supportMutArray = @[].mutableCopy;
    NSDictionary * alipay = _payment_methods[@"alipay"];
    NSDictionary * wechat = _payment_methods[@"wechat"];
    NSDictionary * bank   = _payment_methods[@"bank"];
    
    if (alipay[@"alipay_qr_code"]&&[alipay[@"alipay_qr_code"] length]) {
        [supportMutArray addObject:CAPayAli];
    }
    if (wechat[@"wechat_qr_code"]&&[wechat[@"wechat_qr_code"] length]) {
        [supportMutArray addObject:CAPayWechat];
    }
    if (bank[@"bank_account_number"]&&[bank[@"bank_account_number"] length]) {
        [supportMutArray addObject:CAPayBank];
    }
    
    return supportMutArray.copy;
    
}

-(void)initUIState{
    //   广告主： 创建当前广告的人； 创建订单用户：发起法币交易 点击购买卖出 创建了一个订单的人
    //   1.广告主 进入订单详情
    //        1.1当前广告为买 广告主想买入币种 ad_trade_type==buy
    //            应该显示创建订单用户的支付信息 然后等待创建订单用户 放币 完成交易
    //        1.2当前广告为卖 广告主想卖出自己的币种 ad_trade_type==sell 不用显示付款信息 等待付款成功 广告主放币 完成交易
    //   2.创建订单用户 进入到订单详情
    //        2.1当前订单为买 创建订单用户是想要买入币种 trade_type = buy 应该显示广告主的支付信息  创建订单用户支付成功 等待广告主放币 完成交易
    //        2.2当前订单为卖  创建订单用户是想卖出币种 trade_type = sell 不用显示付款信息 等待广告主支付成功 创建订单用户放币 完成交易
    NSMutableArray * mutArray = @[].mutableCopy;
    BOOL isShowPayMenthod = NO;
    BOOL isBuyer = NO;
    
    if (self.order_state==CAOrderStateWaitingPay||self.order_state==CAOrderStateHasExpendTime) {//待付款状态
        
        if ((self.is_builder&&[self.ad_trade_type isEqualToString:@"buy"])||(!self.is_builder&&[self.ad_trade_type isEqualToString:@"sell"])) {
            
            isShowPayMenthod = YES;
            isBuyer = YES;
            [mutArray addObject:[self getButtonData:@"取消订单"
                      color:HexRGB(0x191d26)
            backGroundColor:HexRGB(0xeff0f6)
                     enable:YES
                 actionType:CALogalOrderActionCancle]];
            
            
            if (self.order_state!=CAOrderStateHasExpendTime) {
                [mutArray addObject:[self getButtonData:@"延长支付时间"
                          color:[UIColor whiteColor]
                backGroundColor:HexRGB(0x3744a4)
                         enable:YES
                     actionType:CALogalOrderActionExpendTime]];
            }
            
            
            [mutArray addObject:[self getButtonData:@"我已成功付款"
                      color:[UIColor whiteColor]
            backGroundColor:HexRGB(0x006cdb)
                     enable:YES
                 actionType:CALogalOrderActionHasPaied]];
        }
        
    }else if (self.order_state==CAOrderStateWaitingCoinRelease){//待放币状态
        
        if (self.is_builder && [self.ad_trade_type isEqualToString:@"sell"]){
            isShowPayMenthod = NO;
            [mutArray addObject:[self getButtonData:NSStringFormat(@"%@%@",CALanguages(@"放行"),[self.currency_code uppercaseString])
                                              color:[UIColor whiteColor]
                                    backGroundColor:HexRGB(0x006cdb)
                                             enable:YES
                                         actionType:CALogalOrderActionReleaseCoin]];
        }else{
            isShowPayMenthod = YES;
        }
    }
    
    self.is_showPaymethod = isShowPayMenthod;
    self.is_buyer = isBuyer;
    self.actionButtons = mutArray.copy;
}
//  广告创建
//Isbuilder  ad_trade_type
//true       sell  买家昵称  member
//true       buy   卖家昵称  member
//false      sell  卖家昵称  builder
//false      buy   买家昵称  builder

-(void)setShowMemberNickNameAndRealName{
    
    if (self.is_builder) {
        self.showNickName = self.member_otc_nick_name;
        self.showRealName = self.member_real_name;
        if ([self.ad_trade_type isEqualToString:@"sell"]) {
            self.notiShowNikeName = @"买家昵称";
            self.notiShowRealName = @"买家实名";
            self.notiPay = @"收款方式";
        }else{
            self.notiShowNikeName = @"卖家昵称";
            self.notiShowRealName = @"卖家实名";
            self.notiPay = @"付款方式";
        }
    }else{
        self.showNickName = self.builder_otc_nick_name;
        self.showRealName = self.builder_real_name;
        if ([self.ad_trade_type isEqualToString:@"sell"]) {
            self.notiShowNikeName = @"卖家昵称";
            self.notiShowRealName = @"卖家实名";
            self.notiPay = @"付款方式";
        }else{
            self.notiShowNikeName = @"买家昵称";
            self.notiShowRealName = @"买家实名";
            self.notiPay = @"收款方式";
        }
    }
    
//    ?@"付款方式":@"收款方式"
}

-(CALogalOrderState)order_state{
    
    if (self.is_canceled||self.is_timeout) {
        _order_state = CAOrderStateCanceled;
    }else{
        if ([self.progress isEqualToString:@"buyer_do_not_pay"]) {
            if (self.is_overtime) {
                _order_state = CAOrderStateHasExpendTime;
            }else{
                _order_state = CAOrderStateWaitingPay;
            }
        }else if ([self.progress isEqualToString:@"buyer_has_paid"]){
            _order_state  = CAOrderStateWaitingCoinRelease;
        }else if ([self.progress isEqualToString:@"seller_has_released"]){
            _order_state = CAOrderStateFinshed;
        }else{
            _order_state = CAOrderStateUnkonwn;
        }
    }
    return _order_state;
}

-(NSDictionary *)getButtonData:(NSString*)title color:(UIColor*)color backGroundColor:(UIColor*)backGroundColor enable:(BOOL)enable actionType:(CALogalOrderAction)actionType{
    
    return @{
         @"title":CALanguages(title),
         @"titleColor":color,
         @"backGroundColor":backGroundColor,
         @"enable":@(enable),
         @"actionType":@(actionType)
    };
}

//-(NSArray *)actionButtons{
//
//    NSMutableArray * mutArray = @[].mutableCopy;
//
//    if (self.order_state==CAOrderStateWaitingPay||self.order_state==CAOrderStateHasExpendTime) {
//
//        if (self.is_showPaymethod) {
//
//            [mutArray addObject:[self getButtonData:@"取消订单"
//                      color:HexRGB(0x191d26)
//            backGroundColor:HexRGB(0xeff0f6)
//                     enable:YES
//                 actionType:CALogalOrderActionCancle]];
//
//
//            if (self.order_state!=CAOrderStateHasExpendTime) {
//                [mutArray addObject:[self getButtonData:@"延长支付时间"
//                          color:[UIColor whiteColor]
//                backGroundColor:HexRGB(0x3744a4)
//                         enable:YES
//                     actionType:CALogalOrderActionExpendTime]];
//            }
//
//
//            [mutArray addObject:[self getButtonData:@"我已成功付款"
//                      color:[UIColor whiteColor]
//            backGroundColor:HexRGB(0x006cdb)
//                     enable:YES
//                 actionType:CALogalOrderActionHasPaied]];
//        }
//    }else if (self.order_state==CAOrderStateWaitingCoinRelease){
//        if (self.is_showPaymethod) {
//
//            [mutArray addObject:[self getButtonData:@"申诉"
//                      color:HexRGB(0x191d26)
//            backGroundColor:HexRGB(0xeff0f6)
//                     enable:YES
//                 actionType:CALogalOrderActionAppeal]];
//
//            [mutArray addObject:[self getButtonData:NSStringFormat(@"放行%@",[self.currency_code uppercaseString])
//                      color:[UIColor whiteColor]
//            backGroundColor:HexRGB(0x006cdb)
//                     enable:YES
//                 actionType:CALogalOrderActionReleaseCoin]];
//        }else{
//
//            [mutArray addObject:[self getButtonData:@"取消"
//                      color:HexRGB(0x191d26)
//            backGroundColor:HexRGB(0xeff0f6)
//                     enable:YES
//                 actionType:CALogalOrderActionAppeal]];
//
//
//            [mutArray addObject:[self getButtonData:@"申诉"
//                      color:HexRGB(0x191d26)
//            backGroundColor:HexRGB(0xeff0f6)
//                     enable:YES
//                 actionType:CALogalOrderActionAppeal]];
//        }
//    }
//
//    return mutArray.copy;
//}
//改为接口返回 已废弃
//-(NSString *)order_state_name{
//    
//    _order_state_name = @"";
//
//    switch (self.order_state) {
//        case CAOrderStateWaitingPay:
//        case CAOrderStateHasExpendTime:
//            _order_state_name = @"待付款";
//            break;
//        case CAOrderStateCanceled:
//        case CAOrderStateOverTime:
//            _order_state_name = @"已取消";
//            break;
//        case CAOrderStateWaitingCoinRelease:
//            _order_state_name = @"待放币";
//            break;
//        case CAOrderStateFinshed:
//            _order_state_name = @"已完成";
//             break;
//            
//        default:
//            break;
//    }
//    
//    return _order_state_name;
//}

-(void)initWithDictionary:(NSDictionary *)dic{
 
    NSArray * allKeys = dic.allKeys;
    NSArray * allProp = self.columeNames;
    
    for (NSString * key in allKeys) {
        if ([allProp containsObject:key]) {
            if (dic[key]) {
                [self setValue:dic[key] forKey:key];
            }
        }else if ([key isEqualToString:@"id"]){
            [self setID:dic[key]];
        }
    }
    
    [self initUIState];
    [self setShowMemberNickNameAndRealName];
    
    self.hasContent = YES;
    
}

@end
