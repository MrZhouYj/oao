//
//  CASegmentView.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CASegmentViewDelegate <NSObject>

-(void)CASegmentView_didSelectedIndex:(NSInteger)index;

@end

@interface CASegmentView : UIView

@property (nonatomic, strong) UIFont * itemFont;

@property (nonatomic, strong) UIColor * normalColor;

@property (nonatomic, strong) UIColor * selectedColor;

@property (nonatomic, weak) id<CASegmentViewDelegate> delegata;

@property (nonatomic, strong) NSArray * segmentItems;

@property (nonatomic, assign) NSInteger segmentCurrentIndex;
//显示的最多的个数 超过这个个数 就可以滑动 默认为6
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) BOOL showBottomLine;
//defult is YES 是否平均排列
@property (nonatomic, assign) BOOL isFixedSpace;

+(NSArray*)getItemsFromArray:(NSArray*)array;

@end

NS_ASSUME_NONNULL_END
