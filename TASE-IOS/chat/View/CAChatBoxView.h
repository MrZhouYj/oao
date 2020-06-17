//
//  CAChatBoxView.h
//  TASE-IOS
//
 
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CAChatBoxView;

typedef NS_ENUM(NSInteger, CAChatBoxViewState){
    CAChatBoxViewKeyBoard,
    CAChatBoxViewMore,
    CAChatBoxViewNone,//正常状态
};

@protocol CAChatBoxDelegate <NSObject>

@optional;
/**
 *  发送文本消息
 */
- (void)chatBox:(CAChatBoxView *)chatBox sendTextMessage:(NSString *)textMessage;
/**
 *  发送图片消息
 */
- (void)chatBox:(CAChatBoxView *)chatBox sendImageMessage:(UIImage *)imageMessage;

- (void)chatBox:(CAChatBoxView *)chatBox changeChatBoxHeight:(CGFloat)height;

@end

@interface CAChatBoxView : UIView

@property (nonatomic, assign) id<CAChatBoxDelegate>delegate;

@property (nonatomic,weak) UIViewController  *viewController; 

@property (nonatomic, assign) CGFloat curHeight;

@property (nonatomic, assign) CAChatBoxViewState state;

@end

NS_ASSUME_NONNULL_END
