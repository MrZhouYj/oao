//
//  CABitListView.h
//  TASE-IOS
//
//   9/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAShadowView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CABitListViewDelegate <NSObject>

-(void)bitListViewDidSelectedIndex:(NSInteger)index;

@end

@interface CABitListView : CAShadowView

@property (nonatomic, weak) id<CABitListViewDelegate> delegate;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSArray * bitListDataArray;

@end

NS_ASSUME_NONNULL_END
