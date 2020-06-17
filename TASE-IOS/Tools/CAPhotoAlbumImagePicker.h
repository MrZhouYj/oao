//
//  CAPhotoAlbumImagePicker.h
//  TASE-IOS
//
//   9/29.
//  Copyright © 2019 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    PATH_CHATREC_IMAGE    [PATH_DOCUMENT stringByAppendingPathComponent:@"Chat/Images"]

NS_ASSUME_NONNULL_BEGIN

typedef void (^CAPhotoAlbumImagePickerBlock)(UIImage *image);

@interface CAPhotoAlbumImagePicker : NSObject

+(instancetype)shareImgaePicker;

- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(CAPhotoAlbumImagePickerBlock)photoBlock;

-(void)getPhotoByTakeAPhotoBlock:(CAPhotoAlbumImagePickerBlock)photoBlock;

-(void)getPhotoInAlbumPhotoBlock:(CAPhotoAlbumImagePickerBlock)photoBlock;



@end

NS_ASSUME_NONNULL_END
