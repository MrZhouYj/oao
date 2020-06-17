//
//  CAPhotoAlbumImagePicker.m
//  TASE-IOS
//
//   9/29.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPhotoAlbumImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

@interface CAPhotoAlbumImagePicker()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic,copy) CAPhotoAlbumImagePickerBlock photoBlock;   //-> 回掉
@property (nonatomic,strong) UIImagePickerController *picker; //-> 多媒体选择控制器
@property (nonatomic,weak) UIViewController  *viewController; //-> 一定是weak 避免循环引用
@property (nonatomic,assign) NSInteger sourceType;            //-> 媒体来源 （相册/相机）

@end

@implementation CAPhotoAlbumImagePicker

+(instancetype)shareImgaePicker{
    static dispatch_once_t onceToken;
    static CAPhotoAlbumImagePicker * picker = nil;
    dispatch_once(&onceToken, ^{
        picker = [CAPhotoAlbumImagePicker new];
    });
    return picker;
}

-(UIViewController *)viewController{

    return [AppDelegate shareAppDelegate].window.rootViewController;
}

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(CAPhotoAlbumImagePickerBlock)photoBlock{
    
    self.photoBlock = photoBlock;
    self.viewController = controller;
    [self creatUIImagePickerControllerWithAlertActionType:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)getPhotoByTakeAPhotoBlock:(CAPhotoAlbumImagePickerBlock)photoBlock{
    
    self.photoBlock = photoBlock;
    [self creatUIImagePickerControllerWithAlertActionType:UIImagePickerControllerSourceTypeCamera];
    
    
}
-(void)getPhotoInAlbumPhotoBlock:(CAPhotoAlbumImagePickerBlock)photoBlock{
   
    self.photoBlock = photoBlock;
    [self creatUIImagePickerControllerWithAlertActionType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}


/**
 点击事件出发的方法
 
 @param type 媒体库来源 （相册/相机）
 */
- (void)creatUIImagePickerControllerWithAlertActionType:(NSInteger)type {
    self.sourceType = type;
    // 获取不同媒体类型下的授权类型
    NSInteger cameragranted = [self AVAuthorizationStatusIsGranted];
    // 如果确定未授权 cameragranted ==0 弹框提示；如果确定已经授权 cameragranted == 1；如果第一次触发授权 cameragranted == 2，这里不处理
    if (cameragranted == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置-隐私-相机/相册中打开授权设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        [alertController addAction:comfirmAction];

        [self.viewController presentViewController:alertController animated:YES completion:nil];
        
    }else if (cameragranted == 1) {
        [self presentPickerViewController];
    }
}


// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 照机/相册 授权判断
- (NSInteger)AVAuthorizationStatusIsGranted  {
    
    __block CAPhotoAlbumImagePicker * weakSelf = self;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];  // 相机授权
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];                         // 相册授权
    NSInteger authStatus = self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? authStatusAlbm:authStatusVedio;
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限，如果用户第一次同意授权，直接执行再次调起
            if (self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) { //授权成功
                        [weakSelf presentPickerViewController];
                    }
                }];
            }else{
                [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) { //授权成功
                        [weakSelf presentPickerViewController];
                    }
                }];
            }
        }
            return 2;   //-> 不提示
        case 1: return 0; //-> 还未授权
        case 2: return 0; //-> 主动拒绝授权
        case 3: return 1; //-> 已授权
        default:return 0;
    }
}


/**
 如果第一次访问用户是否是授权，如果用户同意 直接再次执行
 */
-(void)presentPickerViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.picker = [[UIImagePickerController alloc] init];
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
        }
        self.picker.delegate = self;
    //    self.picker.allowsEditing = YES;          //-> 是否允许选取的图片可以裁剪编辑
    //    self.picker.allowsImageEditing = YES;
        self.picker.sourceType = self.sourceType; //-> 媒体来源（相册/相机）
        
        [self.viewController presentViewController:self.picker animated:YES completion:nil];
    });
    
}


#pragma mark - UIImagePickerControllerDelegate
// 点击完成按钮的选取图片的回掉
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"%@",info);
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.photoBlock ?  self.photoBlock(originalImage): nil;
        [picker dismissViewControllerAnimated:YES completion:^{
            // 这个部分代码 视情况而定
            if (@available(iOS 11.0, *)){
                [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            }
        }];
    });
    
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}

@end
