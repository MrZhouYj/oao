//
//  CASocket.m
//  TASE-IOS
//
//   10/28.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASocket.h"
#import "zlib.h"
#import <SocketRocket.h>


@interface CASocket()
<SRWebSocketDelegate>
{
    CFAbsoluteTime appStartLaunchTime;
}
@property (nonatomic, strong) NSTimer * heartBeatTimer;
@property (nonatomic, strong) SRWebSocket * ws;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSPointerArray * delegates;
@property (nonatomic, strong) NSMutableArray * waitSendDataArray;
@property (nonatomic, assign) NSInteger reConnectTime;
@property (nonatomic, assign) BOOL isActiveClose;
//当前订阅的频道
@property (nonatomic, strong) NSMutableArray * curSubscribes;
@end

@implementation CASocket

+(instancetype)shareSocket{
    static CASocket * socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [CASocket new];
        socket.delegates = [NSPointerArray weakObjectsPointerArray];
    });
    return socket;
}

-(NSMutableArray *)curSubscribes{
    if (!_curSubscribes) {
        _curSubscribes = @[].mutableCopy;
    }
    return _curSubscribes;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.isActiveClose = NO;
        self.reConnectTime = 0;
        self.waitSendDataArray = @[].mutableCopy;
        self.queue = dispatch_queue_create("socketQueue", NULL);
    }
    return self;
}

#pragma mark 添加代理 监听数据的方法  开始
-(void)addDelegate:(id)delegate{
    [self.delegates addPointer:(__bridge void*)delegate];
}

- (void)removeDelegate:(id)delegate
{
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound)
    {
        [self.delegates removePointerAtIndex:index];
    }
    [self.delegates compact];
}

- (NSUInteger)indexOfDelegate:(id)delegate
{
    for (NSUInteger i = 0; i < self.delegates.count; i += 1) {
        if ([self.delegates pointerAtIndex:i] == (__bridge void*)delegate) {
            return i;
        }
    }
    return NSNotFound;
}
#pragma mark socket链接 重连 操作

-(void)connectServer{
    
    if (self.ws) {
        [self.ws close];
        self.ws = nil;
    }
//    wss://l10n-pro.huobiasia.vip/-/s/pro/ws //        @"subscribe" : @"test_channel"
//    wss://l10n-pro.huobi.cn
//    ws://websocket.testcadae.top/ws  ws://websocket.testcadae.top/ws
    self.isActiveClose = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:WEBSOCKET_URL]]];
    self.ws = [[SRWebSocket alloc] initWithURLRequest:request];
    self.ws.delegate = self;
    [self.ws open];
    NSLog(@"开始连接socket");
    appStartLaunchTime = CFAbsoluteTimeGetCurrent();
    
}

-(void)closeConnect{
    
    self.isActiveClose = YES;
    if (self.ws) {
        [self.ws close];
        self.ws = nil;
    }
    [self destoryHeartBeat];
    [self.curSubscribes removeAllObjects];
    [self.waitSendDataArray removeAllObjects];
}

-(void)reConnectServer{
    
    if (self.ws.readyState==SR_OPEN){
        NSLog(@"正在连接着呢");
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        return;
    }
    
    if (self.reConnectTime > 10000) {
        self.reConnectTime = 0;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        return;
    }
//    NSLog(@"开始重新连接");
    
//    if (self.ws.readyState==SR_OPEN&&self.ws.readyState==SR_CONNECTING) {
//        NSLog(@"正在连接SR_CONNECTING");
//        return;
//    }
//    [self connectServer];
    self.reConnectTime ++;
    
    [self performSelector:@selector(connectServer) withObject:nil afterDelay:2];
}



#pragma mark 发送数据 处理ping pong

-(void)initHeartBeat{
    
    if (self.heartBeatTimer) {
        return;
    }
    [self destoryHeartBeat];
    kWeakSelf(self);
    dispatch_main_async_safe(^(){
        weakself.heartBeatTimer = [NSTimer scheduledAutoReleaseTimerWithTimeInterval:5 target:self selector:@selector(sendHeartBeat) userinfo:nil repeats:YES];
        [weakself.heartBeatTimer fire];
        //NSLog(@"开始发送心跳");
    });
}
-(void)destoryHeartBeat{
    kWeakSelf(self);
    dispatch_main_async_safe(^(){
        if (weakself.heartBeatTimer) {
            [weakself.heartBeatTimer invalidate];
            weakself.heartBeatTimer = nil;
        }
    });
}

-(void)sendHeartBeat{
    kWeakSelf(self);
    dispatch_main_async_safe(^{
        
        if (weakself.ws.readyState==SR_OPEN) {
//            NSLog(@"发送了心跳信息  %ld",weakself.ws.readyState);
            [self sendDataToSever:@{@"pong":@([CommonMethod getCurrentTimestamp])}];
        }else{
            [self destoryHeartBeat];
        }
    });
}

-(void)filterNil{
    
    
}

-(void)sendDataToSever{
    
    kWeakSelf(self);
       dispatch_async(self.queue, ^{
           if (weakself.ws) {
               if (weakself.ws.readyState==SR_OPEN) {
                   if (weakself.waitSendDataArray.count>0) {
                       @try {
                           id firstData = self.waitSendDataArray[0];
                           NSDictionary * sendDictionary;
                           if ([firstData isKindOfClass:[NSDictionary class]]) {
                               sendDictionary = [NSDictionary dictionaryWithDictionary:firstData];
                           }
                           if (sendDictionary) {
                               NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendDictionary options:NSJSONWritingPrettyPrinted error:nil];
                                  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                  [weakself.ws send:jsonString];
                               if ([weakself.waitSendDataArray containsObject:sendDictionary]) {
                                   [weakself.waitSendDataArray removeObject:sendDictionary];
                               }
                               
                                  if (sendDictionary[@"subscribe"]) {
                                      
                                      [self.curSubscribes addObject:sendDictionary];
                                      NSLog(@"发送了一个订阅消息 %@ 正在订阅的是 %@",sendDictionary,self.curSubscribes);
                                  }else if (sendDictionary[@"unsubscribe"]){
                                      
                                      NSInteger index = 0;
                                      
                                      for (int i=0; i<self.curSubscribes.count; i++) {
                                          NSDictionary * d = self.curSubscribes[i];
                                          if (d&&[d[@"subscribe"] isEqualToString:sendDictionary[@"unsubscribe"]]) {
                                              index = i;
                                          }
                                      }
                                      if (self.curSubscribes.count>index) {
                                          [self.curSubscribes removeObjectAtIndex:index];
                                      }
                                  }
                           }
                           if (weakself.waitSendDataArray.count>0) {
                               [weakself sendDataToSever];
                           }
                       } @catch (NSException *exception) {
                           
                       } @finally {
                            
                       }
                       
                   }
               }else if (weakself.ws.readyState==SR_CONNECTING){
                   //NSLog(@"正在重新连接");
               }else if (weakself.ws.readyState==SR_CLOSING||weakself.ws.readyState==SR_CLOSED){
                   //NSLog(@"warning warning connecting ing ing!!!!!!!!");
                   [weakself reConnectServer];
               }else{
                   //NSLog(@"未知状态");
               }
               //不管发送成功还是失败都要把心跳数据删除
               if (self.waitSendDataArray.count) {
                   NSDictionary * pong = self.waitSendDataArray.lastObject;
                   if (pong[@"pong"]) {
                       //NSLog(@"删除了pong消息");
                       [self.waitSendDataArray removeLastObject];
                   }
               }
               
           }else{
               [weakself connectServer];
           }
       });
}

-(void)unsubCurrentReq{
    //NSLog(@"取消当前所有的订阅");
    for (NSInteger i=0; i<self.curSubscribes.count; i++) {
        NSDictionary * curSub = [self.curSubscribes objectAtIndex:i];
        if (curSub[@"subscribe"]) {
            [self.waitSendDataArray addObject:@{
                @"unsubscribe":curSub[@"subscribe"]
            }];
        }
    }
    
    [self sendDataToSever];
}

-(void)unsub:(NSDictionary *)dictionary{
    
    BOOL isNeesFresh = NO;
    for (NSInteger i=0; i<self.curSubscribes.count;i++) {
        NSDictionary * curSub = [self.curSubscribes objectAtIndex:i];
        if ([curSub[@"subscribe"] containsString:dictionary[@"subscribe"]]) {
            [self.waitSendDataArray addObject:@{
                @"unsubscribe":curSub[@"subscribe"]
            }];
            isNeesFresh = YES;
            break;
        }
    }
    if (isNeesFresh) {
        [self sendDataToSever];
    }
}

-(void)sendDataToSever:(NSDictionary*)dictionary{
    
//    NSMutableDictionary * mutDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
//    if (mutDictionary[@"subscribe"]) {
//        [mutDictionary setValue:NSStringFormat(@"%@·%@",mutDictionary[@"subscribe"],[CALanguageManager language]) forKey:@"subscribe"];
//    }
    
    //NSLog(@"%@",dictionary);
    
    if (self.ws.readyState!=SR_OPEN){
        NSLog(@"socket未连接");
        [self reConnectServer];
        return;
    }
    @try {
        
        for (NSInteger i=0; i<self.curSubscribes.count; i++) {
            
                NSDictionary * curSub = [self.curSubscribes objectAtIndex:i];
                if (curSub&&dictionary&&[curSub[@"subscribe"] isEqualToString:dictionary[@"subscribe"]]) {
        //            [self.waitSendDataArray addObject:@{
        //                @"unsubscribe":dictionary[@"subscribe"]
        //            }];
                    NSLog(@"已经订阅过了");
                    return;
                }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"奔溃了");
        NSLog(@"%@",exception.reason);
    } @finally {
        
        [self.waitSendDataArray addObject:dictionary];
        [self sendDataToSever];
    }
}

#pragma mark SRWebSocketDelegate Start

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{

    
    NSLog(@"websocket连接成功 用的时间--%fs",(CFAbsoluteTimeGetCurrent()-appStartLaunchTime));
    
    [self initHeartBeat];
    
    if (self.waitSendDataArray.count>0) {
        NSLog(@"重连成功 == %@\n",self.waitSendDataArray);
        
        [self sendDataToSever];
    }
    
    for (id delegate in self.delegates)
    {
        if (delegate && [delegate respondsToSelector:@selector(webSocketDidOpen)])
        {
            [delegate webSocketDidOpen];
        }
    }
}


-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    if (self.isActiveClose) {
        //NSLog(@"用户主动关闭链接 不进行重连");
        return;
    }
    [self destoryHeartBeat];
    
    if ([CANetworkHelper isNetwork]) {
        NSLog(@"重连呢");
        [self reConnectServer];
    }
    NSLog(@"链接失败  === %@",error);
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    if (self.ws.readyState==SR_OPEN||self.isActiveClose||self.ws.readyState==SR_CONNECTING) {
        return;
    }
     NSLog(@"链接关闭了 code==%ld reason=%@ wasClean==%d",code,reason,wasClean);
    if ([CANetworkHelper isNetwork]) {
        [self reConnectServer];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    //NSLog(@"收到后台心跳回复");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
   
    NSData * data = [self ungzipData:message];
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        //NSLog(@"数据解析失败 %@",error);
        return;
    }
//    if (jsonObject[@"ping"]) {
//        NSLog(@"%@",jsonObject);
//    }else{
//        NSLog(@"%@",jsonObject[@"channel"]);
//    }
    
//    NSLog(@"%@",jsonObject[@"channel"]);
    
    for (id delegate in self.delegates)
    {
        if (delegate && [delegate respondsToSelector:@selector(webSocket:didReceiveMessage:)])
        {
            [delegate webSocket:self didReceiveMessage:jsonObject];
        }
    }
}

#pragma mark SRWebSocketDeleagate End

-(NSData *)ungzipData:(NSData *)compressedData
{
    if ([compressedData length] == 0)
        return compressedData;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wshorten-64-to-32"
         
    unsigned full_length = [compressedData length];
    unsigned half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;

    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = [compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;

    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }

    if (inflateEnd (&strm) != Z_OK)
        return nil;
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    
     #pragma clang diagnostic pop
    return nil;
}

-(void)dealloc{
    
    if (self.heartBeatTimer) {
        [self.heartBeatTimer invalidate];
        self.heartBeatTimer = nil;
    }
}

+ (NSDictionary *)getSub:(NSDictionary *)para{
    
    NSMutableString * mutString = [NSMutableString stringWithString:para[@"channel"]];
    if (para[@"market_id"]&&[para[@"market_id"] length]) {
         [mutString appendFormat:@"·%@",para[@"market_id"]];
    }
    if (para[@"lang"]&&[para[@"lang"] length]) {
         [mutString appendFormat:@"·%@",para[@"lang"]];
    }
    if (para[@"token"]&&[para[@"token"] length]) {
         [mutString appendFormat:@"·%@",para[@"token"]];
    }
    if (para[@"period"]&&[para[@"period"] length]) {
         [mutString appendFormat:@"·%@",para[@"period"]];
    }
    
    NSDictionary * parad = @{
        @"subscribe":mutString
    };
    
    return parad;
}

@end
