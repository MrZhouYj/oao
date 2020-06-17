//
//  CAVerificationCode.m
//  TASE-IOS
//
//   10/28.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAVerificationCode.h"



@interface CAVerificationCode()
<GT3CaptchaManagerDelegate,
GT3CaptchaManagerViewDelegate
>

@property (nonatomic, copy) NSString * identification;

@property (nonatomic, strong) GT3CaptchaManager * manager;

@end

@implementation CAVerificationCode

+(instancetype)shareVerificationCode{
    static dispatch_once_t onceToken;
    static CAVerificationCode * code;
    dispatch_once(&onceToken, ^{
        code = [CAVerificationCode new];
    });
    return code;
}

-(void)startVerificationCode:(NSString *)identification{
    
    self.identification = identification;
    
    [self.manager startGTCaptchaWithAnimated:YES];
}

- (GT3CaptchaManager *)manager {
    if (!_manager) {
        

//         api_1    获取验证参数的接口 https://cas.cadae.top/gee_test_register
//         api_2    进行二次验证的接口 后台接口去验证 app不用进行这个操作
        NSString * api_1 = @"https://cas.cadex.top/gee_test_register";
        
        _manager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_1 timeout:5.0];
        _manager.delegate = self;
        [_manager registerCaptcha:nil];
        _manager.viewDelegate = self;
        [_manager useAnimatedAcitvityIndicator:^(CALayer *layer, CGSize size, UIColor *color) {
            
        } withIndicatorType:GT3IndicatorTypeSystem];
        
        NSString * lanuge = [CALanguageManager userLanguage];
        //en 英语 zh-Hans 简体中文 ko 韩语 ru-RU 俄语 ja-JP 日语
        if ([lanuge isEqualToString:ENGLISH_english]) {
            [_manager useLanguage:GT3LANGTYPE_EN];
        }else if ([lanuge isEqualToString:CHINESE_Chinese]){
            [_manager useLanguage:GT3LANGTYPE_ZH_CN];
        }else if ([lanuge isEqualToString:JAPANESE_Japanese]){
            [_manager useLanguage:GT3LANGTYPE_JA_JP];
        }else if ([lanuge isEqualToString:RUSSIAN_Russian]){
            [_manager useLanguage:GT3LANGTYPE_RU];
        }else if ([lanuge isEqualToString:KOREAN_Korean]){
            [_manager useLanguage:GT3LANGTYPE_KO_KR];
        }
        
    }
    return _manager;
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error{
    NSLog(@"GT3Error  == %@",error);
    [SVProgressHUD dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(CAVerficationCode_responesFail_identification:)]) {
        [self.delegate CAVerficationCode_responesFail_identification:self.identification];
    }
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy captchaPolicy))decisionHandler{
    [SVProgressHUD dismiss];
    if (!error) {
        //处理你的验证结果
        NSLog(@"\ndata: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
    }
}
- (NSDictionary *)gtCaptcha:(GT3CaptchaManager *)manager didReceiveDataFromAPI1:(NSDictionary *)dictionary withError:(GT3Error *)error{
    NSLog(@"  === %@",dictionary);
    [SVProgressHUD dismiss];
//    challenge = 18225cb75a0bb66cfa7e99b7db5e4c66;
//    gt = 433133f5197e42bf5748be2230dbffd4;
//    success = 1;
    return dictionary;
}
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message{
    NSLog(@"code  == %@\n",code);
    NSLog(@"result  == %@\n",result);
    NSLog(@"message  == %@\n",message);
    [SVProgressHUD dismiss];
    if ([code isEqualToString:@"1"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(CAVerficationCode_responesSuccess:identification:)]) {
            [self.delegate CAVerficationCode_responesSuccess:result identification:self.identification];
        }
    }
}

@end
