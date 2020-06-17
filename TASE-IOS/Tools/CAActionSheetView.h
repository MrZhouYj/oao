//
//  CAActionSheetView.h
//  TASE-IOS
//
//   10/22.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseAnimationView.h"

NS_ASSUME_NONNULL_BEGIN


@interface CAActionCell : UIView

@property (nonatomic, copy) NSString * text;

@property (nonatomic, assign) BOOL isHightLight;

@end

@interface CAActionSheetView : CABaseAnimationView

+(instancetype)showActionSheet:(NSArray*)data selectIndex:(NSInteger)index click:(void (^)(NSInteger))block;

@end



NS_ASSUME_NONNULL_END
