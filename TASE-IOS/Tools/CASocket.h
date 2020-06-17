//
//  CASocket.h
//  TASE-IOS
//
//   10/28.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CASocket;
@protocol CASocketDelegate <NSObject>

@required;
-(void)webSocket:(CASocket *)webSocket didReceiveMessage:(NSDictionary*)message;
-(void)webSocketDidOpen;

@end

@interface CASocket : NSObject

+(instancetype)shareSocket;

-(void)addDelegate:(id)delegate;
/**
 页面销毁之前 必须调用这个方法
 */
- (void)removeDelegate:(id)delegate;

- (void)connectServer;

- (void)reConnectServer;

- (void)closeConnect;

- (void)sendDataToSever:(NSDictionary*)dictionary;

- (void)unsubCurrentReq;

- (void)unsub:(NSDictionary*)dictionary;

+ (NSDictionary *)getSub:(NSDictionary*)para;

@end
