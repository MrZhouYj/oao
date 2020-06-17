//
//  CABBSearshView.h
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseAnimationView.h"

NS_ASSUME_NONNULL_BEGIN
@class CASymbolsModel;
@protocol CABBSearshViewDelegate <NSObject>

- (void)CABBSearshView_didsectedMarket:(CASymbolsModel*)model;

@end

@interface CABBSearshView : CABaseAnimationView

@property (nonatomic, weak) id<CABBSearshViewDelegate> delegata;

@property (nonatomic, strong) NSDictionary * content;

-(void)reloadData;

-(void)didChange;

@end

NS_ASSUME_NONNULL_END
