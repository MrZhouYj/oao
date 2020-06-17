//
//  CAChoosePayTypeView.h
//  TASE-IOS
//
//   10/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const CAPayBank;
FOUNDATION_EXPORT NSString * const CAPayWechat;
FOUNDATION_EXPORT NSString * const CAPayAli;

@interface CAPayButton : UIView

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, assign) BOOL enable;

+ (instancetype)buttonWithNormalImage:(NSString*)imageNormal
                     heightLightImage:(NSString*)imageHightLight
                                title:(NSString*)title;

@end

@protocol CAChoosePayTypeViewDelegate <NSObject>

-(void)CAChoosePayTypeView_didSelected:(NSString*)payType;

@end

@interface CAChoosePayTypeView : UIView

@property (nonatomic, weak) id<CAChoosePayTypeViewDelegate> delegata;
/**是否多选*/
@property (nonatomic, assign) BOOL canMultipleSelection;
/**是否必须选择一个*/
@property (nonatomic, assign) BOOL isMustOnlyOneSelected;

@property (nonatomic, strong) NSMutableArray * payMethodsArray;

@property (nonatomic, strong) NSArray <NSString*>* supportPayMethodArray;

-(void)update;

@end

NS_ASSUME_NONNULL_END
