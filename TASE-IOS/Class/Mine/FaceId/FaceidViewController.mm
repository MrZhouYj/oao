

#import "FaceidViewController.h"
#import <MGFaceIDZZIDCardKit/MGFaceIDZZIDCardKit.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <math.h>
#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>
#import "MegNetwork.h"

@interface FaceidViewController ()

@property (nonatomic, strong) UISegmentedControl* idcardSegC;
@property (nonatomic, strong) UIView* idcardInfoView;
@property (nonatomic, strong) UIButton* detectButton;
@property (nonatomic, strong) CAUser * user;
@property (nonatomic, copy) NSString* bizTokenStr;
@property (nonatomic, copy) NSString* currentLanguage;

@property (nonatomic, strong) MGFaceIDZZIDCardDetectItem* detectItem;

@end

@implementation FaceidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"实名认证";
    self.user = [CAUser currentUser];
    [self buildView];
    
    self.currentLanguage = [CALanguageManager userLanguage];
    
}


#pragma mark - BuildView
- (void)buildView {

    UIImageView * imageV = [UIImageView new];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"start_verify"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(80);
        make.height.equalTo(imageV.mas_width);
        make.top.equalTo(self.navcBar.navcContentView.mas_bottom).offset(80);
    }];
    
    _detectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.detectButton];
    [self.detectButton setTitleColor:HexRGB(0xf8fbff) forState:UIControlStateNormal];
    [self.detectButton setBackgroundColor:RGB(0, 108, 219)];
    [self.detectButton addTarget:self
                     action:@selector(startDetect:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.detectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(60.0f);
        make.bottom.equalTo(self.view).offset(-80.0f);
        make.height.offset(46.0f);
    }];
    _detectButton.titleLabel.font = FONT_MEDIUM_SIZE(16);
    _detectButton.layer.masksToBounds = YES;
    _detectButton.layer.cornerRadius = 2;
    [_detectButton setTitle:CALanguages(@"开始认证") forState:UIControlStateNormal];
    
}

#pragma mark - Detect
- (void)startDetect:(UIButton *)sender {
    if (self.user.real_name.length&&self.user.id_card_number.length) {
        [self getBizToken];
    }else{
        [self startIDCardDetect];
    }
}
- (void)startIDCardDetect{
    
    MGFaceIDZZIDCardErrorItem* errorItem;
    NSString* bizTokenStr;
    MGFaceIDZZIDCardManager* idcardManager = [[MGFaceIDZZIDCardManager alloc] initMGFaceIDZZIDCardManagerWithSign:[[MegNetwork singleton] getFaceIDSignStr]
                                                                                                      signVersion:[[MegNetwork singleton] getFaceIDSignVersionStr]
                                                                                                         bizToken:&bizTokenStr
                                                                                                        extraData:nil
                                                                                                            error:&errorItem];
    __weak FaceidViewController* weakSelf = self;
    [idcardManager startMGFaceIDZZIDcardDetect:self
                                      bizToken:bizTokenStr
                                     bizNumber:nil
                             screenOrientation:MGFaceIDZZIDCardScreenOrientationVertical
                                     shootPage:MGFaceIDZZIDCardShootPageDouble
                                      callback:^(MGFaceIDZZIDCardErrorItem *errorItem, MGFaceIDZZIDCardDetectItem *detectItem, NSString *bizTokenStr, NSString *bizNumberStr, NSDictionary *extraOutDataDict) {
                                          if ((errorItem.errorType == MGFaceIDZZIDCardErrorOCRSuccess || errorItem.errorType == MGFaceIDZZIDCardErrorSuccessAlmostBothSide) && detectItem) {
                                              weakSelf.detectItem = detectItem;
                                              [weakSelf dealIdCardDetectResult];
                                          } else if(errorItem.errorType == MGFaceIDZZIDCardErrorUserCancel){
                                              //用户取消  不做任何操作
                                          } else{
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  UIAlertController* alertC = [UIAlertController alertControllerWithTitle:@"OCR检测失败"
                                                                                                                  message:[NSString stringWithFormat:@"ErrorCode:%d, ErrorMessage:%@", (int)errorItem.errorType, errorItem.errorMessage]
                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                                                                         style:UIAlertActionStyleCancel
                                                                                                       handler:nil];
                                                  [alertC addAction:cancelAction];
                                                  [self presentViewController:alertC animated:YES completion:nil];
                                              });
                                          }
                                      }];
}


-(void)dealIdCardDetectResult{
    if (!_detectItem) {
        return;
    }
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"real_name": _detectItem.userIDCardName.resultStr,
        @"number": _detectItem.userIDCardNumber.resultStr,
        @"gender": _detectItem.userIDCardGender.resultStr,
        @"address": _detectItem.userAddress.resultStr,
        @"issued_by": _detectItem.userIssuedBy.resultStr,
        @"race": _detectItem.userIDCardNationality.resultStr,
        @"birthday": _detectItem.userBirthYear.resultStr,
        @"valid_date": _detectItem.userValidDateEnd.resultStr
    };
    NSLog(@"%@",para);
    __weak FaceidViewController* weakSelf = self;
    [CANetworkHelper uploadImagesWithURL:CAAPI_MINE_UPLOAD_ID_CARD_INFORMATION parameters:para name:@[@"front",@"back"] images:@[_detectItem.idcardPortraitImage,_detectItem.idcardEmblemImage] progress:^(NSProgress *progress) {
    } success:^(id responseObject) {
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            self.user.real_name = self->_detectItem.userIDCardName.resultStr;
            self.user.id_card_number_not_hide = self->_detectItem.userIDCardNumber.resultStr;
            [weakSelf getBizToken];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - BizToken
- (void)getBizToken{
    if (!self.user.real_name.length&&!self.user.id_card_number.length) {
        
        return;
    }
    [SVProgressHUD show];
    __weak FaceidViewController* weakSelf = self;
    NSMutableDictionary* liveInfoDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [liveInfoDict setObject:@"meglive" forKey:@"liveness_type"];
    
    [[MegNetwork singleton] queryDemoMGFaceIDAntiSpoofingBizTokenWithUserName:self.user.real_name
                                                                     idcardNumber:self.user.id_card_number_not_hide
                                                                       liveConfig:liveInfoDict
                                                                          success:^(NSInteger statusCode, NSDictionary *responseObject) {
        [SVProgressHUD dismiss];
                                                                              if (statusCode == 200 && responseObject && [[responseObject allKeys] containsObject:@"biz_token"] && [responseObject objectForKey:@"biz_token"]) {
                                                                                  self.bizTokenStr = [responseObject objectForKey:@"biz_token"];
                                                                                  [weakSelf startMGFaceDetect];
                                                                                  NSLog(@"获取 BizToken 成功");
                                                                              } else {
                                                                                  NSLog(@"获取 BizToken 失败");
                                                                              }
                                                                          } failure:^(NSInteger statusCode, NSError *error) {
                                                                              [SVProgressHUD dismiss];
                                                                              NSLog(@"网络请求失败");
                                                                          }];
}

#pragma mark - Detect
- (void)startMGFaceDetect{
    
    MGFaceIDLiveDetectLanguageType type = MGFaceIDLiveDetectLanguageEn;
    if ([self.currentLanguage isEqualToString:CHINESE_Chinese]) {
        type = MGFaceIDLiveDetectLanguageCh;
    }
    
    MGFaceIDLiveDetectError* error;
    MGFaceIDLiveDetectManager* detectManager = [[MGFaceIDLiveDetectManager alloc] initMGFaceIDLiveDetectManagerWithBizToken:self.bizTokenStr
                                                                                                                   language:type
                                                                                                                networkHost:@"https://api.megvii.com"
                                                                                                                  extraData:nil
                                                                                                                      error:&error];
    if (error || !detectManager) {
        NSLog(@"%@",error.errorMessageStr);
    }
    //  可选方法-当前使用默认值
    {
        MGFaceIDLiveDetectCustomConfigItem* customConfigItem = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
        [detectManager setMGFaceIDLiveDetectCustomUIConfig:customConfigItem];
        [detectManager setMGFaceIDLiveDetectPhoneVertical:MGFaceIDLiveDetectPhoneVerticalFront];
    }
    __weak FaceidViewController* weakSelf = self;
    
    [detectManager startMGFaceIDLiveDetectWithCurrentController:self
                                                       callback:^(MGFaceIDLiveDetectError *error, NSData *deltaData, NSString *bizTokenStr, NSDictionary *extraOutDataDict) {
                                                           
        NSLog(@"errorType %ld",error.errorType);
        NSLog(@"deltaData %@",deltaData);
        if (deltaData&&error.errorType==MGFaceIDLiveDetectErrorNone) {
            [SVProgressHUD show];
                    [[MegNetwork singleton] queryDemoMGFaceIDAntiSpoofingVerifyWithBizToken:bizTokenStr verify:deltaData success:^(NSInteger statusCode, NSDictionary * _Nonnull responseObject) {
                        [SVProgressHUD dismiss];
                        Toast(responseObject[@"result_message"]);
                        NSLog(@"result_code == %@",responseObject[@"result_code"]);
                        if ([responseObject[@"result_code"] integerValue]==1000) {
            //                验证成功
                            float confidence = [responseObject[@"verification"][@"idcard"][@"confidence"] floatValue];
                            NSLog(@"confidence == %f",confidence);
                            if (confidence>75) {
                                NSLog(@"通过了");
                                NSLog(@"%ld",[responseObject[@"images"][@"image_best"] length]);
                                UIImage * image = [CommonMethod getImageFromBase64String:responseObject[@"images"][@"image_best"]];
                                [weakSelf dealMGFaceIDLiveDetectResult:image];
                            }
                            
                        }else{
            //                失败了
                            NSLog(@"不匹配 %ld----%@",statusCode,responseObject[@"result_code"]);
            //                2000 待比对照片与参考照片比对结果不是同一个人
                        }
                    } failure:^(NSInteger statusCode, NSError * _Nonnull error) {
                        [SVProgressHUD dismiss];
                    }];
        }
        
    }];
    
    
}

-(void)dealMGFaceIDLiveDetectResult:(UIImage*)image{
    
    [SVProgressHUD show];
    
    [CANetworkHelper uploadImagesWithURL:CAAPI_MINE_AFTER_SCAN_FACE parameters:nil name:@[@"man"] images:@[image] progress:^(NSProgress *progress) {
    } success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue]==20000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            Toast(responseObject[@"message"]);
        });
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
