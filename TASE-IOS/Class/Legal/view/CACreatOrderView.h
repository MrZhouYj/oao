//
//  CACreatOrderView.h
//  TASE-IOS
//
//   10/14.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseAnimationView.h"

NS_ASSUME_NONNULL_BEGIN
@class CACreatOrderView;
@protocol CACreatOrderViewDelegate <NSObject>

-(void)creatOrderClick:(NSString*)order_price order_amount:(NSString*)order_amount originDictinary:(NSDictionary*)originDictionary orderView:(CACreatOrderView*)orderView;

@end

@interface CACreatOrderView : CABaseAnimationView

@property (nonatomic, weak) id<CACreatOrderViewDelegate> dele;

@property (nonatomic, strong) NSDictionary * originDictionary;

@property (nonatomic, copy) NSString * order_price;

@property (nonatomic, copy) NSString * order_amount;

@end

NS_ASSUME_NONNULL_END
