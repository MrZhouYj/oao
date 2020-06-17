//
//  CAInviteFriendViewController.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAInviteFriendViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>

@interface CAInviteFriendViewController ()

@property (nonatomic, strong) UIView *centerWhiteView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSDictionary * data;
@property (nonatomic, strong) UILabel * inviteCodeLabel;
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) UIImageView * inviteCodeQrImageView;
@property (nonatomic, strong) CAUser * user;

@end

@implementation CAInviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"邀请码";
    self.backTineColor = [UIColor whiteColor];
    self.titleColor = [UIColor whiteColor];
    self.navcBar.backgroundColor = [UIColor clearColor];
    self.user = [CAUser currentUser];
    [self initSubViews];
     
    [SVProgressHUD show];
    [self getData];
    
}

-(void)getData{
    kWeakSelf(self);
    [self.user getUserInvitationCode:^{
        [SVProgressHUD dismiss];
        [weakself updateData];
    }];
}

-(void)initSubViews{
    
    UIImageView * inviteTextImageView = [UIImageView new];
    [self.bgImageView addSubview:inviteTextImageView];
//    inviteTextImageView.image = IMAGE_NAMED(@"invite_frient_regist_text");
    inviteTextImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView * inviteCodeImageView = [UIImageView new];
    [self.bgImageView addSubview:inviteCodeImageView];
    inviteCodeImageView.image = IMAGE_NAMED(@"invite_red_background");
    inviteCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
   
    
    self.inviteCodeLabel = [UILabel new];
    [inviteCodeImageView addSubview:self.inviteCodeLabel];
    [self.inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(inviteCodeImageView);
        make.centerY.equalTo(inviteCodeImageView);
    }];
    
    UIView *centerWhiteView = [UIView new];
    [self.bgImageView addSubview:centerWhiteView];
    self.centerWhiteView = centerWhiteView;
    centerWhiteView.backgroundColor = [UIColor whiteColor];
    centerWhiteView.layer.masksToBounds = YES;
    centerWhiteView.layer.cornerRadius= 5;
    

    [centerWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.bgImageView);
        make.width.equalTo(self.bgImageView).multipliedBy(0.72);
        make.height.mas_equalTo(AutoNumber(20)+10+AutoNumber(20)*3+AutoNumber(15)+MainWidth*0.72*0.5+AutoNumber(20)+AutoNumber(40)+AutoNumber(25));
    }];
    
    [inviteCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerWhiteView.mas_top).offset(-AutoNumber(18));
        make.centerX.equalTo(self.bgImageView);
        make.width.equalTo(self.bgImageView);
        make.height.mas_equalTo(AutoNumber(40));
    }];
    
    [inviteTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inviteCodeImageView.mas_top).offset(-AutoNumber(11));
        make.centerX.equalTo(self.bgImageView);
        make.width.equalTo(self.bgImageView);
        make.height.mas_equalTo(AutoNumber(33));
    }];
    
    
    [self initCenterWhiteView];
    
    
}

-(void)updateData{
    
    NSString * inviteNoti = CALanguages(@"我的邀请码");
    NSDictionary * dic = @{
                           NSForegroundColorAttributeName:[UIColor whiteColor],
                           NSFontAttributeName:FONT_REGULAR_SIZE(16)
                           };
    NSDictionary * dic1 = @{
                           NSForegroundColorAttributeName:RGB(47, 241, 138),
                           NSFontAttributeName:FONT_REGULAR_SIZE(13)
                           };
    NSString * invitation_code = self.user.invitation_code;
    NSString * qrcode  = self.user.qrcode;
    
    if (invitation_code.length) {
        NSMutableAttributedString * mutStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@:%@",inviteNoti,invitation_code)];
        [mutStr addAttributes:dic range:NSMakeRange(0, inviteNoti.length+1)];
        [mutStr addAttributes:dic1 range:NSMakeRange(inviteNoti.length+1, [invitation_code length])];
        self.inviteCodeLabel.attributedText = mutStr;
    }
    if (qrcode.length) {
         self.inviteCodeQrImageView.image = [CommonMethod getImageFromBase64StringContainImageType:qrcode];
    }
}


-(void)initCenterWhiteView{
    
    UILabel * top1Label = [self creatLabel:@"下面是您的专属邀请码"];
    UILabel * top2Label = [self creatLabel:@"您可以把界面微信截图分享给朋友"];
    UILabel * top3Label = [self creatLabel:@"让对方长按识别即可注册"];
    
    [top1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerWhiteView).offset(AutoNumber(20));
    }];
    
    [top2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top1Label.mas_bottom).offset(5);
    }];
    
    [top3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top2Label.mas_bottom).offset(5);
    }];
    [@[top1Label,top2Label,top3Label] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.centerWhiteView);
        make.height.equalTo(@(AutoNumber(20)));
    }];
    
    UIImageView * qrCodeImgV = [UIImageView new];
    [self.centerWhiteView addSubview:qrCodeImgV];
    qrCodeImgV.image = IMAGE_NAMED(@"qrcode");
    self.inviteCodeQrImageView = qrCodeImgV;
    [qrCodeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.centerWhiteView.mas_width).multipliedBy(0.5);
        make.top.equalTo(top3Label.mas_bottom).offset(AutoNumber(15));
        make.centerX.equalTo(self.centerWhiteView);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerWhiteView addSubview:button];
    self.saveButton = button;
    [button setTitle:CALanguages(@"点击保存图片")  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = FONT_REGULAR_SIZE(AutoNumber(15));
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = RGB(0,108,219);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = AutoNumber(40)/2.f;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerWhiteView);
        make.top.equalTo(qrCodeImgV.mas_bottom).offset(AutoNumber(20));
        make.width.equalTo(self.centerWhiteView).multipliedBy(0.65);
        make.height.equalTo(@(AutoNumber(40)));
    }];
    [button addTarget:self action:@selector(snopImageClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self initTwoPerson];
}

-(void)snopImageClick{
    
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      NSLog(@"%ld",status);
        if (status == PHAuthorizationStatusAuthorized) { //授权成功
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.saveButton.hidden = YES;
                UIGraphicsBeginImageContextWithOptions(self.bgImageView.size, NO, [UIScreen mainScreen].scale);
                [self.bgImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                self.saveButton.hidden = NO;
            });
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CALanguages(@"提示")  message:CALanguages(@"请到设置-隐私-相机/相册中打开授权设置") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:CALanguages(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }];
            [alertController addAction:comfirmAction];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:^{
                    
                }];
            });
        }
    }];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        Toast(CALanguages(@"保存成功"));
    }
}

-(void)initTwoPerson{
    
    UIImageView * imageView = [UIImageView new];
    [self.bgImageView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = IMAGE_NAMED(@"invite_two_person");
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView);
        make.centerX.equalTo(self.bgImageView);
        make.top.equalTo(self.centerWhiteView.mas_bottom).offset(-25);
        make.width.equalTo(self.bgImageView);
    }];
}

-(UILabel *)creatLabel:(NSString*)str{
    UILabel * label = [UILabel new];
    [self.centerWhiteView addSubview:label];
    label.text = CALanguages(str);
    label.font = FONT_REGULAR_SIZE(AutoNumber(15));
    label.textColor = RGB(13, 31, 61);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        [self.view addSubview:_bgImageView];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = IMAGE_NAMED(@"invite_bg");
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _bgImageView;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

@end
