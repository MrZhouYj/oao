//
//  CAMessageModel.h
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFMDBModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CAMessageOwnerType){
    CAMessageOwnerTypeUnknown,  // 未知的消息拥有者
    CAMessageOwnerTypeSystem,   // 系统消息
    CAMessageOwnerTypeSelf,     // 自己发送的消息
    CAMessageOwnerTypeOther,    // 接收到的他人消息
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, CAMessageType){
    CAMessageTypeUnknown,       // 未知
    CAMessageTypeSystem,        // 系统
    CAMessageTypeText,          // 文字
    CAMessageTypeImage,          // 图片
};
/**
*  图片发送状态
*/
typedef NS_ENUM(NSInteger, CAImageMessageStatus){
    CAImageMessageNone,       // 未发送
    CAImageMessageSending,        // 发送中
    CAImageMessageSendSuccess,          // 发送成功
    CAImageMessageSendFail,          // 发送失败
};

@interface CAMessageModel : CAFMDBModel

@property (nonatomic, strong) NSDate *date;                         // 发送时间
@property (nonatomic, strong) NSString *sent_at;                 // 格式化的发送时间
@property (nonatomic, assign) CAMessageType messageType;            // 消息类型
@property (nonatomic, assign) CAMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) CGSize messageSize;                   // 消息大小
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSString *cellIndentify;
@property (nonatomic, strong) NSString *body;
#pragma mark - 图片消息
@property (nonatomic, assign) CAImageMessageStatus imageStatus;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIImage * originImage;
@property (nonatomic, copy) NSString * thumbnailImagePath; //缩略图路径
@property (nonatomic, copy) NSString * originImagePath; //原图路径
@property (nonatomic, copy) NSString *imageURL;// 网络图片URL

+ (instancetype)modelWithData:(NSDictionary*)data;

@end

NS_ASSUME_NONNULL_END
