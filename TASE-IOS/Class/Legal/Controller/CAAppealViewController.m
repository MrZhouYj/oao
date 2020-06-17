//
//  CAAppealViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAppealViewController.h"
#import "CAPlaceHolderTextView.h"
#import "AJPhotoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "KNPhotoBrowser.h"

#define maxPhotosCount 3

@interface CAAppealViewController ()
<AJPhotoPickerProtocol,
UIImagePickerControllerDelegate,
UITextViewDelegate,
UINavigationControllerDelegate>
{
    UIButton * sendBtn;
}
@property (nonatomic, strong) UITextField * phoneTextField;

@property (nonatomic, strong) CAPlaceHolderTextView * textView;

@property (nonatomic, strong) UIView * photosContainView;

@property (nonatomic, strong) NSMutableArray * photos;

@end

@implementation CAAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

-(void)cancleClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initSubViews{
    
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navcBar.navcContentView addSubview: cancleBtn];
    [cancleBtn setTitleColor:HexRGB(0x191d26) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = FONT_MEDIUM_SIZE(15);
    [cancleBtn setTitle:CALanguages(@"取消")  forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navcBar.navcContentView).offset(15);
        make.centerY.equalTo(self.navcBar.navcContentView);
    }];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.navcBar.navcContentView addSubview: sendBtn];
    [sendBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    
    sendBtn.titleLabel.font = FONT_MEDIUM_SIZE(15);
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 2;
    sendBtn.enabled = NO;
    [sendBtn setTitle:CALanguages(@"提交") forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navcBar.navcContentView).offset(-15);
        make.centerY.equalTo(self.navcBar.navcContentView);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    
    UIView * orderNumBgView = [UIView new];
    [self.view addSubview:orderNumBgView];
    orderNumBgView.backgroundColor = HexRGB(0xebf3fc);
    [orderNumBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navcBar.navcContentView.mas_bottom).offset(10);
        make.height.equalTo(@40);
    }];
    
    UILabel * orderLabel = [UILabel new];
    [orderNumBgView addSubview:orderLabel];
    orderLabel.font = FONT_MEDIUM_SIZE(14);
    orderLabel.textColor = HexRGB(0x3657ff);
    orderLabel.text = NSStringFormat(@"%@:%@",CALanguages(@"订单号"),self.infoModel.sn);
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderNumBgView).offset(15);
        make.centerY.equalTo(orderNumBgView);
    }];
    
    self.phoneTextField = [UITextField new];
    [self.view addSubview:self.phoneTextField];
    self.phoneTextField.placeholder = CALanguages(@"请输入联系电话");
    self.phoneTextField.font = FONT_MEDIUM_SIZE(15);
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(orderNumBgView.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    UIView * lineView = [UIView new];
    [self.view addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneTextField);
        make.height.equalTo(@1);
        make.top.equalTo(self.phoneTextField.mas_bottom);
    }];
    
    self.textView = [CAPlaceHolderTextView new];
    [self.view addSubview: self.textView];
    self.textView.delegate  = self;
    self.textView.placeholdColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = FONT_MEDIUM_SIZE(15);
    self.textView.placeholder = CALanguages(@"请填写申诉原因");
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@100);
    }];
    

    
    self.photosContainView = [UIView new];
    [self.view addSubview:self.photosContainView];
    [self.photosContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.height.equalTo(self.view.mas_width);
    }];
    
    [self judgeCanSend];
    [self setUpPhotosContainView];
}

-(void)textFieldDidChange{
    [self judgeCanSend];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    [self judgeCanSend];
}

-(void)judgeCanSend{
    NSString * phone = self.phoneTextField.text;
    NSString * appeal = self.textView.text;
  
    if (phone.length&&appeal.length) {
        sendBtn.enabled = YES;
        [sendBtn setBackgroundColor:HexRGB(0x006cdb)];
    }else{
        sendBtn.enabled = NO;
        [sendBtn setBackgroundColor:HexRGB(0xe9ebf3)];
    }
}

- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    
    for (ALAsset * asset in assets) {
        
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        if (tempImg) {
            [self.photos addObject:tempImg];
        }
    }

    [self setUpPhotosContainView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpPhotosContainView{
    
    [self.photosContainView removeAllSubViews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat size = (MainWidth-50)/3.f;
    for (int i = 0 ; i < self.photos.count;) {
        
        UIImage *tempImg = self.photos[i];
        
        UIView * containView = [UIView new];
        containView.frame = CGRectMake(x, y, size, size);
        [self.photosContainView addSubview:containView];

        UIImageView *imageView = [UIImageView new];
        [containView addSubview:imageView];
        imageView.image = tempImg;
        imageView.clipsToBounds = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = HexRGB(0xefefef).CGColor;
//        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)]];
        
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [deleteBtn setImage:[IMAGE_NAMED(@"delete_photos") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [containView addSubview:deleteBtn];
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.cornerRadius = 8;
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(containView);
            make.width.height.equalTo(@16);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(containView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
       
        i++;
        x = i%3?(x+size+5):0;
        y = i/3*(size+5);
    }
    
    if (self.photos.count<maxPhotosCount) {
        
        UIImageView *imageView = [UIImageView new];
        [self.photosContainView addSubview:imageView];
        imageView.image = IMAGE_NAMED(@"addPhotos");
        imageView.userInteractionEnabled = YES;
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = HexRGB(0xefefef).CGColor;
        imageView.frame = CGRectMake(x, y, size, size);
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotosAction)]];
        
    }
}

-(void)showBigImage:(UITapGestureRecognizer*)tap{
    
    KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
//    photoBrower.itemsArr = itemsArr;
    photoBrower.isNeedPageControl = true;
    photoBrower.isNeedPanGesture  = true;
//    photoBrower.currentIndex = [tempArr indexOfObject:curModel];
    [photoBrower present];
}

-(void)addPhotosAction{
    
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = maxPhotosCount-self.photos.count;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)deletePhoto:(UIButton*)btn{
    
    NSInteger tag = btn.tag;
    if (self.photos.count>tag) {
        [self.photos removeObjectAtIndex:tag];
    }
    [self setUpPhotosContainView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (originalImage) {
        [self.photos addObject:originalImage];
        [self setUpPhotosContainView];
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    
    __block AJPhotoPickerViewController * weakPicker = picker;
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
        
        [weakPicker dismissViewControllerAnimated:NO completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImagePickerController *cameraUI = [UIImagePickerController new];
            cameraUI.allowsEditing = NO;
            cameraUI.delegate = self;
            cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraUI.cameraFlashMode=UIImagePickerControllerCameraFlashModeAuto;
            [self presentViewController: cameraUI animated: YES completion:nil];
        });
        
    }];
}

- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}


-(NSMutableArray *)photos{
    if (!_photos) {
        _photos = @[].mutableCopy;
    }
    return _photos;
}


-(void)sendClick{
    
    
    
    NSString * mobile = self.phoneTextField.text;
    NSString * reason = self.textView.text;
    
    
    NSDictionary * para = @{
        @"trading_id":NSStringFormat(@"%@",self.infoModel.ID),
        @"reason":reason,
        @"mobile":mobile
    };
    [SVProgressHUD show];
    [CANetworkHelper uploadImagesWithURL:CAAPI_OTC_CREATE_DISPUTE parameters:para name:@[@"image1",@"image2",@"image3"] images:self.photos progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        [SVProgressHUD dismiss];
        Toast(responseObject[@"message"]);
        if ([responseObject[@"code"] integerValue]==20000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

@end
