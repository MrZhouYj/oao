//
//  CARowView.h
//  TASE-IOS
//
//   9/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CARowView;

typedef enum {
    CARowViewLayoutCenter =0,
    CARowViewLayoutBetween
}CARowViewLayout;

@protocol CARowViewDelegata <NSObject>

-(void)CARowView_didChangeRowState:(int)state rowView:(CARowView*)rowView;

@end

@interface CARowView : UIView

@property (nonatomic, weak) id<CARowViewDelegata> delegata;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) UIColor * imageTineColor;

@property (nonatomic, copy, nullable) NSString * title;

@property (nonatomic, copy) NSString * upTitle;

@property (nonatomic, copy) NSString * downTitle;

@property (nonatomic, strong) UIColor * titleColor;

@property (nonatomic, strong) UIFont * titleFont;

@property (nonatomic, strong) UIColor * placeHolderColor;

@property (nonatomic, strong) UIColor * borderNormalColor;

@property (nonatomic, strong) UIColor * backGroundNormalColor;

@property (nonatomic, strong) UIColor * backGroundSelectColor;

@property (nonatomic, strong) UIColor * borderSelectColor;

@property (nonatomic, strong) UIColor * selectColor;

@property (nonatomic, copy) NSString * placeHolder;

@property (nonatomic, assign) CARowViewLayout  layOut;

@property (nonatomic, assign, getter=isUp) BOOL up;

@property (nonatomic, assign) BOOL rowHidden;

@end

NS_ASSUME_NONNULL_END
