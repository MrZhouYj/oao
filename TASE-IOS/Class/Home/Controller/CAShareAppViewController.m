//
//  CAShareAppViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/30.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAShareAppViewController.h"
#import <CoreImage/CoreImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>

@interface CAShareAppViewController ()
{
    CGSize _imageSize;
}
@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * qrcodeImageView;

@property (nonatomic, strong) UIButton * saveButton;

@end

@implementation CAShareAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

-(void)initSubViews{
    
    UIImage *shareBgImage = IMAGE_NAMED(@"shareApp");
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    self.imageView.image = shareBgImage;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    CGFloat scale = shareBgImage.size.width/shareBgImage.size.height;
    _imageSize = CGSizeMake(MainWidth, MainWidth/scale);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.mas_equalTo(_imageSize.width);
        make.height.mas_equalTo(_imageSize.height);
    }];
    self.imageView.centerX = self.view.centerX;
    self.imageView.centerY = self.view.centerY;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 4;
    

    
    self.qrcodeImageView = [UIImageView new];
    [self.imageView addSubview:self.qrcodeImageView];
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageView).offset(-5);
        make.bottom.equalTo(self.imageView).offset(-5);
        make.width.height.equalTo(@70);
    }];
    self.qrcodeImageView.contentMode = UIViewContentModeScaleToFill;
    self.qrcodeImageView.backgroundColor = [UIColor whiteColor];
    
    self.saveButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@44);
        make.top.equalTo(self.imageView.mas_bottom).offset(-10);
    }];
    
    self.saveButton.backgroundColor = HexRGB(0x2c2745);
    self.saveButton.layer.cornerRadius = 5;
    self.saveButton.layer.masksToBounds = YES;
    [self.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitle:CALanguages(@"保存")  forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    UIImage * qrimage = [CommonMethod getImageFromBase64StringContainImageType:[CAUser currentUser].qrcode];
//    UIImage * qrimage = [self generateQRCodeWithString:@"https://trading.cadae.top" Size:70];
    self.qrcodeImageView.image = qrimage;
}

//生成二维码
- (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size
{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据<字符串长度893>
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    //获取二维码过滤器生成二维码
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFromCIImage:image WithSize:size];
    return img;
}
//二维码清晰
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image WithSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
-(void)saveClick{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) { //授权成功
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIGraphicsBeginImageContextWithOptions(self->_imageSize, NO, [UIScreen mainScreen].scale);
                [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            });
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CALanguages(@"提示") message:CALanguages(@"请到设置-隐私-相机/相册中打开授权设置") preferredStyle:UIAlertControllerStyleAlert];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {

    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"消失");
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
