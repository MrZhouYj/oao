
#import "CANetworkHelper.h"
#import "CAUser.h"
#import "UIImage+Compress.h"

NSString * const CANetworkDidConenctNotifacation = @"CANetworkDidConenctNotifacation";
NSString * const CANetworkDidLoseConenctNotifacation = @"CANetworkDidLoseConenctNotifacation";


@implementation CANetworkHelper

static BOOL _isAddDeviceInfo = YES;   // 是否已开启日志打印
static BOOL _isOpenLog;   // 是否已开启日志打印
static BOOL _isOpenAES;   // 是否已开启加密传输
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(PPNetworkStatus)networkStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(PPNetworkStatusUnknown) : nil;
                    if (_isOpenLog) NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(PPNetworkStatusNotReachable) : nil;
                    if (_isOpenLog) NSLog(@"无网络");
                    Toast(CALanguages(@"网络异常，请检查网络后重试"));
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(PPNetworkStatusReachableViaWWAN) : nil;
                    if (_isOpenLog) NSLog(@"手机自带网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(PPNetworkStatusReachableViaWiFi) : nil;
                    if (_isOpenLog) NSLog(@"WIFI");
                    break;
            }
        }];
    });
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}

+ (void)addDeviceInfoToParameter{
    _isAddDeviceInfo = YES;
}

+ (void)removeDeviceInfoToParameter{
    _isAddDeviceInfo = NO;
}

#pragma mark - ——————— 开关加密 ————————
+ (void)openAES {
    _isOpenAES = YES;
    [_sessionManager.requestSerializer setValue:@"text/encode" forHTTPHeaderField:@"Content-Type"];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

+ (void)closeAES {
    _isOpenAES = NO;
    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET请求无缓存
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                  success:(PPHttpRequestSuccess)success
                  failure:(PPHttpRequestFailed)failure {
    
     parameters = [self appendDeviceInfo:parameters];
     URL = [self appendUrl:URL];
    
//     NSLog(@"get 加密后的参数 %@",parameters);
     NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseObject]);}
         [[self allSessionTask] removeObject:task];
         success ? success(responseObject) : nil;
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (_isOpenLog) {NSLog(@"error = %@",error);}
         [[self allSessionTask] removeObject:task];
         failure ? failure(error) : nil;
         
     }];
     // 添加sessionTask到数组
     sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
     
     return sessionTask;
}
#pragma mark - GET请求无缓存
+ (NSURLSessionTask *)GETWithFullUrl:(NSString *)URL
               parameters:(id)parameters
                  success:(PPHttpRequestSuccess)success
                  failure:(PPHttpRequestFailed)failure {
    
//     parameters = [self appendDeviceInfo:parameters];
    
     NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         [[self allSessionTask] removeObject:task];
         success ? success(responseObject) : nil;
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (_isOpenLog) {NSLog(@"error = %@",error);}
         [[self allSessionTask] removeObject:task];
         failure ? failure(error) : nil;
         
     }];
     // 添加sessionTask到数组
     sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
     
     return sessionTask;
}

#pragma mark - POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(PPHttpRequestSuccess)success
                   failure:(PPHttpRequestFailed)failure {
    
   
    URL = [self appendUrl:URL];

    NSString *Url = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    parameters = [self appendDeviceInfo:parameters];
    
    __block  NSURLSessionTask *sessionTask = [_sessionManager POST:Url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
    }progress:^(NSProgress *uploadProgress){
        
    }success:^(NSURLSessionDataTask *task,id responseData){
        if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseData]);}
        success(responseData);
    }failure:^(NSURLSessionDataTask *task,NSError *error){
        failure(error);
        NSLog(@"%@",error);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}
+ (NSURLSessionTask *)MATCHERPOST:(NSString *)URL
                parameters:(id)parameters
                   success:(PPHttpRequestSuccess)success
                   failure:(PPHttpRequestFailed)failure {
    
   
    URL = [MATCHER_BASE_URL stringByAppendingString:URL];
    NSString *Url = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    parameters = [self appendDeviceInfo:parameters];
    
    __block  NSURLSessionTask *sessionTask = [_sessionManager POST:Url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
    }progress:^(NSProgress *uploadProgress){
        
    }success:^(NSURLSessionDataTask *task,id responseData){

        if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseData]);}
        success(responseData);
    }failure:^(NSURLSessionDataTask *task,NSError *error){
        failure(error);
        NSLog(@"%@",error);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}
+(id)appendDeviceInfo:(id)parameters{
    
    NSMutableDictionary * mutDictionary;
    if (parameters&&[parameters isKindOfClass:[NSDictionary class]]) {
        mutDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else{
        mutDictionary = @{}.mutableCopy;
    }
    //当前语言
    [mutDictionary setValue:[CALanguageManager language] forKey:@"lang"];
    
    if (_isAddDeviceInfo) {
           //当前系统版本号
        [mutDictionary setValue:@"ios" forKey:@"os_type"];
        [mutDictionary setValue:[UIDevice currentDevice].systemVersion forKey:@"os_version"];
        [mutDictionary setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"app_version"];
        [mutDictionary setValue:NSStringFormat(@"%@",[CommonMethod getDeviceName]) forKey:@"device_type"];

    }
       
    //获取当前时间戳
//    NSLog(@"%@",[CAUser currentUser]);
    if ([[CAUser currentUser] isAvaliable]) {
        [mutDictionary setValue:[CAUser currentUser].public_key forKey:@"public_key"];
        [mutDictionary setValue:@([CommonMethod getCurrentTimestamp]) forKey:@"nonce"];
         mutDictionary = [self appendSignature:mutDictionary];
    }

    return mutDictionary;
}

+ (NSMutableDictionary*)appendSignature:(NSMutableDictionary*)para{
    
    NSArray * sortedArray = [[para allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSString * mutString = @"";
    for (NSString * key in sortedArray) {
       mutString = [mutString stringByAppendingFormat:@"%@=%@&",key,para[key]];
    }
    mutString = [mutString stringByAppendingFormat:@"private_key=%@",[CAUser currentUser].private_key];
//    NSLog(@"拼接好的字符串 == %@\n",mutString);
    mutString = [Util md5:mutString];
//    NSLog(@"MD5后的哈希值 == %@\n",mutString);
    [para setValue:mutString forKey:@"signature"];
//    NSLog(@"签名后的参数 == %@\n",para);
    return para;
}

+ (NSString*)appendUrl:(NSString*)url{
    if (_isOpenLog) {
        NSLog(@"%@",[ CAAPI_BASE_URL stringByAppendingString:url]);
    }
    
    return [CAAPI_BASE_URL stringByAppendingString:url];
}


#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(PPHttpProgress)progress
                                success:(PPHttpRequestSuccess)success
                                failure:(PPHttpRequestFailed)failure {

    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;

        [formData appendPartWithFileData:parameters[@"file"] name:name fileName:NSStringFormat(@"%@.mp4",filePath) mimeType:@"video/mp4"];
        (failure && error) ? failure(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseObject]);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        [self checkTokenExpiredWithResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {NSLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

+ (NSData*)comprossImage:(UIImage*)image{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
//    while (imageData.length/1024.f/1024.f>=1.0) {
//        NSLog(@"imageData==%f",imageData.length/1024.0/1024.0);
//        imageData = UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.5);
//    };
    return imageData;
}

#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSArray *)names
                                   images:(NSArray<UIImage *> *)images
                                 progress:(PPHttpProgress)progress
                                  success:(PPHttpRequestSuccess)success
                                  failure:(PPHttpRequestFailed)failure {
    
    parameters = [self appendDeviceInfo:parameters];
    URL = [self appendUrl:URL];

    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            if(image){
                NSData *imageData = [image compressBelowOneMBytes];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,(long)i,@"png");
                
                [formData appendPartWithFileData:imageData
                                            name:names[i]
                                        fileName:imageFileName
                                        mimeType:NSStringFormat(@"image/png")];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {NSLog(@"responseObject = %@",[self jsonToString:responseObject]);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {NSLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(PPHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(PPHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

/**
 *  检测是否是未登录状态
 */
+ (void)checkTokenExpiredWithResponseObject:(id)responseObject
{
//    if (TokenExpired || TokenExpired2) {
//        NSString *message = TokenExpired?@"登录有效期过期,请重新登录":@"账号在其它设备登录,如非本人操作,请注意账号安全或联系客服";
//        FDAlertView *alertView = [[FDAlertView alloc] initWithTitle:nil message:message sureBtn:@"确定" cancleBtn:nil];
//        alertView.resultIndex = ^(NSInteger index) {
//            [Util clearToken];
//            KPostNotification(KNotificationLoginStateChange, @NO);
//        };
//        [alertView showAlertView];
//    }
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(data == nil) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 */
+ (void)initialize {
    _sessionManager =  [AFHTTPSessionManager manager];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    
    // 设置服务器返回结果的类型:JSON
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*",@"text/encode", nil];
    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    
    _sessionManager.securityPolicy = securityPolicy;
    // 打开状态栏的等待菊花

    [_sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    

}

+(void)setCookie:(NSString *)cookie{
    [_sessionManager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
}
+(void)clearCookie{
    
    [_sessionManager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
}

#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(PPRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==PPRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(PPResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==PPResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

@end


#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (PP)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif
