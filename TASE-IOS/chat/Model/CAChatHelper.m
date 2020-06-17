
//
//  CAChatHelper.m
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChatHelper.h"

@implementation CAChatHelper

+(NSString*)getImageName{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = @"yyyyMMddHHmmss";

    NSString *time = [formatter stringFromDate:[NSDate date]];

    NSString * name = [NSString stringWithFormat:@"chatImage_%@_%d.jpeg",time,arc4random()%100];
    
    return name;
}

+(CAMessageModel *)initImageMessage:(UIImage *)originImage imageMessageModel:(nonnull CAMessageModel *)model{
 
    NSString *basePath = [NSString stringWithFormat:@"%@/chatCache",PATH_DOCUMENT];
            
    NSString * imageName = [self getImageName];//小图缓存路径
    NSString *smallDetailPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",@"small",imageName]];
    //原图缓存路径
    NSString *detailPath = [basePath stringByAppendingPathComponent:imageName];

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL exist = [manager fileExistsAtPath:basePath];
        if (!exist) {
            [manager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        //压缩比
        CGFloat compressScale = 1;
        NSData * originData = UIImagePNGRepresentation(originImage);
        if (originData.length/1024.0/1024.0 < 3) {
            compressScale = 0.1;  //压缩10倍
        }else{  //大于3M
            compressScale = 0.05; //压缩20倍
        }
        
        NSData * smallAlbumData = UIImageJPEGRepresentation(originImage, compressScale);
        
        
        //小图写入缓存
        [smallAlbumData writeToFile:smallDetailPath atomically:YES];
        //原图写入缓存
        [originData writeToFile:detailPath atomically:YES];
        
    });
 
    model.imageSize = originImage.size;
    model.originImage = originImage;
    model.originImagePath = detailPath;
    model.thumbnailImagePath = smallDetailPath;
    
    return model;
}

+ (CGSize)caculateImageSize:(CGSize )imageSize {

    
    CGFloat maxWidth = MainWidth*0.35;
    CGFloat maxHeight = maxWidth;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat imageWidth = width;
    CGFloat imageHeight = height;
    
    if (width>height&&width>maxWidth) {
        
        imageWidth = maxWidth;
        imageHeight = imageWidth/width*height;
        
    }else if (width>maxWidth||height>maxHeight) {
        
        imageHeight = maxHeight;
        imageWidth = maxHeight/height*width;
        NSLog(@"imageHeight  %f  imageWidth %f",imageHeight,imageWidth);
    }
    
    return CGSizeMake(imageWidth, imageHeight);
}

+ (NSString *)removeEmoji:(NSString *)text{
    
    NSString *tempStr = [[NSString alloc]init];
    NSMutableString *kksstr = [[NSMutableString alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSMutableString *strMu = [[NSMutableString alloc]init];
    for(int i =0; i < [text length]; i++)
    {
    tempStr = [text substringWithRange:NSMakeRange(i, 1)];
    [strMu appendString:tempStr];
    if ([self stringContainsEmoji:strMu]) {
    strMu = [[strMu substringToIndex:([strMu length]-2)] mutableCopy];
    [array removeLastObject];
    continue;
    }else
    [array addObject:tempStr];
    }
    for (NSString *strs in array) {
    [kksstr appendString:strs];
    }
    return kksstr;
}
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
options:NSStringEnumerationByComposedCharacterSequences usingBlock:
^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                        const unichar ls = [substring characterAtIndex:1];
                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                             returnValue = YES;
                        }
                 }
            } else if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 if (ls == 0x20e3) {
                       returnValue = YES;
                 }
             } else {
                  // non surrogate
                  if (0x2100 <= hs && hs <= 0x27ff) {
                        returnValue = YES;
                   } else if (0x2B05 <= hs && hs <= 0x2b07) {
                        returnValue = YES;
                  } else if (0x2934 <= hs && hs <= 0x2935) {
                        returnValue = YES;
                  } else if (0x3297 <= hs && hs <= 0x3299) {
                        returnValue = YES;
                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                        returnValue = YES;
             }
         }
    }];
    return returnValue;
}
@end
