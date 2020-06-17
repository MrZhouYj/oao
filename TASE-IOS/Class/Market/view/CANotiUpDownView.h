//
//  CANotiUpDownView.h
//  TASE-IOS
//
//   9/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CASymbolsModel.h"

typedef enum : NSUInteger {
    AlignmentLeft,
    AlignmentCenter,
    AlignmentRight,
} Alignment;

NS_ASSUME_NONNULL_BEGIN
@class CANotiUpDownView;
@protocol CANotiUpDownViewDelegate <NSObject>

-(void)notiUpDownViewDidChange:(CANotiUpDownView*)view rowState:(CASymbolsSortType)type;

@end

@interface CANotiUpDownView : UIView

@property (nonatomic, weak) id<CANotiUpDownViewDelegate> delegate;

@property (nonatomic, assign) Alignment alignment;

@property (nonatomic, assign) CASymbolsSortType type;

@property (nonatomic, copy) NSString* name;

@property (nonatomic, copy) NSString* key;

@property (nonatomic, weak) void(^block)(BOOL);

@end

NS_ASSUME_NONNULL_END
