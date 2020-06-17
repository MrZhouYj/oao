//
//  CAInputView.h
//  TASE-IOS
//
//   10/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const CAInputViewSendMessageSuccess;

typedef enum {
    CAInputViewLogin=1,//登录页面
    CAInputViewLeftBigImageType,
    CAInputViewLeftNotiRightNotiType,
    CAInputViewOther//
}CAInputViewType;
typedef enum {
    CAInputViewContentNone=0,
    CAInputViewContentPhoneType,
    CAInputViewContentEmailType,
    CAInputViewContentTypeOther//
}CAInputViewContentType;

@interface CAInputView : UIView

@property (nonatomic, assign) CAInputViewContentType contentType;

@property (nonatomic, strong) UITextField * inputView;

@property (nonatomic, strong) UILabel * notiLabel;

@property (nonatomic, strong) UIColor * notiLabelNormalColor;

@property (nonatomic, strong) UILabel * rightNotiLabel;

@property (nonatomic, strong) UIImageView * leftBigImageView;

@property (nonatomic, strong) UIView * leftView;

@property (nonatomic, strong) UILabel * chooseCountryLabel;

@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) UIView * rightView;

@property (nonatomic, copy) NSString * sendTitle;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, assign) BOOL needCheck;

@property (nonatomic, copy) NSString* maxNumber;
@property (nonatomic, copy) NSString* minNumber;

@property (nonatomic, copy) NSString * country_code;

@property (nonatomic, copy) NSString * mobile;

@property (nonatomic, copy) NSString * send_sms_key;

/**请求发短信的 接口url*/
@property (nonatomic, copy) NSString * requestUrl;

+(instancetype)showWithType:(CAInputViewType)type;

+(instancetype)showLoginTypeInputView;

-(void)setSendEnable:(BOOL)isEnable;

-(void)startSendMessageWithGT3Result:(NSDictionary*)result;

-(void)textFieldDidChange;

@end
