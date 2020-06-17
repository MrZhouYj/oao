//
//  CABBBottomTimeLineView.h
//  TASE-IOS
//
//   9/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_KLineGroupModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CABBBottomTimeLineView : UIView

@property (nonatomic, strong) NSMutableArray<Y_KLineModel*> * klineDataArray;
@property (nonatomic, strong) Y_KLineGroupModel *groupModel;
@property (nonatomic, copy) NSString * code;

-(void)addKLineModel:(Y_KLineModel*)model;

-(void)addKLineModels:(NSArray<Y_KLineModel*>*)models;

-(void)hideWith:(BOOL)animated;

-(void)reDraw;

@end

NS_ASSUME_NONNULL_END
