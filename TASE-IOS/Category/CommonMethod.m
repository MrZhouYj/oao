//
//  CommonMethod.m
//  CustomUIView
//
//  Created by hexuren on 15/12/3.
//  Copyright © 2015年 hexuren. All rights reserved.
//

#import "CommonMethod.h"
//#import "MBProgressHUD.h"
//#import "CustomAlertView.h"
//#import "SingletonCheckNetWork.h"
#import "sys/utsname.h"
#import "AppDelegate.h"
//#import "AutoCoding.h"
//#import "SyncDataModel.h"


@implementation CommonMethod

/**
 *  获取当前网络连接状态
 *
 *  @return <#return value description#>
 */
//+(NetworkStatus)getCurrentNetworkStatus{
//    
//    //实例化一个网络检查对象(单例)，通过主机名连接，检查当前网络状态
//    SingletonCheckNetWork *network = [[SingletonCheckNetWork alloc]init];
//    return [network getNetworkStatusWithHostName:@"www.baidu.com"];
//}

/**
 *  通过UserDefaults从Plist文件读取数据
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
+(id)readFromUserDefaults:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //反归档
    NSData *nsdata = [userDefaults objectForKey:key];
    id obj = [self unArchiveObj:nsdata withKey:@"zhodsanfdsga;sdlasozoiasdngsd;asnasda"];
    
    return obj;
    
}



/**
 *  通过UserDefaults将数据写入Plist文件
 *
 *  @param obj <#obj description#>
 *  @param key <#key description#>
 */
+(void)writeToUserDefaults:(id)obj withKey:(NSString *)key{
    
    //归档
    NSData *nsdata = [self archiveObj:obj withKey:@"zhodsanfdsga;sdlasozoiasdngsd;asnasda"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nsdata forKey:key];
    
    [userDefaults synchronize];
    
}

+ (NSString *)transformToPinyin:(NSString *)string
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",string];
    
    return allString;
}

/**
 *  通过UserDefaults从Plist文件删除数据
 *
 *  @param key <#key description#>
 *
 */
+(void)removeFromUserDefaults:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:key];
    
    [userDefaults synchronize];
    
}



/**
 *  给定文本及字体，计算文本宽度、高度
 *
 *  @param string   <#string description#>
 *  @param fontSize <#fontSize description#>
 *
 *  @return <#return value description#>
 */
+(CGSize)computeTextSizeWithString:(NSString *)string andFontSize:(UIFont *)fontSize{
    
    //根据文本的内容及字体大小获取size,从而得到宽、高
    if (!fontSize) {
        return CGSizeZero;
    }
    return [string sizeWithAttributes:@{NSFontAttributeName:fontSize}];
}



/**
 *  计算文本高度
 *
 *  @param string   要计算的文本
 *  @param width    单行文本的宽度
 *  @param fontSize 文本的字体size
 *
 *  @return 返回文本高度
 */
+(CGFloat)computeTextHeightWithString:(NSString *)string andWidth:(CGFloat)width andFontSize:(UIFont *)fontSize{
    
    CGRect rect  = [string boundingRectWithSize:CGSizeMake(width, 10000)
                                        options: NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:fontSize}
                                        context:nil];
    return ceil(rect.size.height);
}



+ (NSString *)calculateWithRoundingMode:(NSRoundingMode )roundingMode roundingValue:(double)roundingValue afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:roundingValue];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSMutableString * value = [NSMutableString stringWithFormat:@"%@",roundedOunces];
//补0
    NSArray * array = [value componentsSeparatedByString:@"."];
    if (array.count>1) {
        NSString * str = array[1];
        if (str.length != position) {
            for (NSInteger i = str.length; i<position; i++) {
                [value appendString:@"0"];
            }
        }
    } else {
        if (position != 0) {
            [value appendString:@"."];
            for (NSInteger i = 0; i <position; i++) {
                [value appendString:@"0"];
            }
        }
    }
    return value;
}


+(NSString*)deleteFloatAllZero:(NSString*)string
{
    NSArray * arrStr=[string componentsSeparatedByString:@"."];
    
    NSString *str=arrStr.firstObject;
    
    NSString *str1=arrStr.lastObject;
    
    while ([str1 hasSuffix:@"0"]) {
        
        str1=[str1 substringToIndex:(str1.length-1)];
        
    }
    
    return (str1.length>0)?[NSString stringWithFormat:@"%@.%@",str,str1]:str;
}

/**
 *  判断输入字符是否都为字母
 *
 *  @param string 传人要判断的字符串
 *
 *  @return 如果字符串包含非字母，则返回NO，反之返回YES
 */
+(BOOL)isAllEnglish:(NSString *)string{
    NSInteger length = [string length];
    char c;
    for (int i = 0; i < length; i++) {
        c = [string characterAtIndex:i];
        if((c >= 'a' && c <= 'z') || (c >='A' && c <= 'Z')){
            continue;
        }else{
            return NO;
        }
    }
    return YES;
}


/**
 *  判断输入字符是否都为数字
 *
 *  @param string 传人要判断的字符串
 *
 *  @return 如果字符串包含非数字，则返回NO，反之返回YES
 */
+(BOOL)isAllInterger:(NSString *)string{
    NSInteger length = [string length];
    char c;
    for (int i = 0; i < length; i++) {
        c = [string characterAtIndex:i];
        if(c >= '0' && c <= '9'){
            continue;
        }else{
            return NO;
        }
    }
    return YES;
}


/**
 *  判断输入字符是否都为字母或数字
 *
 *  @param string 传人要判断的字符串
 *
 *  @return 如果字符串包含非字母、数字，则返回NO，反之返回YES
 */
+(BOOL)isAllEnglishOrInterger:(NSString *)string{
    NSInteger length = [string length];
    char c;
    for (int i = 0; i < length; i++) {
        c = [string characterAtIndex:i];
        if((c >= 'a' && c <= 'z') || (c >='A' && c <= 'Z') || (c >= '0' && c <= '9')){
            continue;
        }else{
            return NO;
        }
    }
    return YES;
}


/**
 *  JSON解析（序列化）NSData对象数据，返回id对象数据
 *
 *  @param data NSData数据
 *
 *  @return 返回id对象数据
 */
+(id)serializeDataToJsonObj:(NSData *)data{
    if (data) {
        NSError *serializationError = nil;
        //解析（序列化）NSData数据对象为JSON类型对象数据
        id objData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
        
        if (serializationError) {
            // NSLog(@"serializationError----%@",serializationError);
            //解析（序列化）出错，返回nil
            return nil;
            
        }else{
            //正常解析（序列化），返回id对象数据
            return objData;
        }
    }else{
        
        return nil;
    }
    
}

/**
 *  生成带删除线的字符串
 *
 *  @param str 传人需要加删除线的字符串
 *
 *  @return 返回带删除线的字符串
 */
+(NSAttributedString *)genarateAttributedString:(NSString *)str{
    
    NSDictionary *attributedDict = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    return [[NSAttributedString alloc]initWithString:str attributes:attributedDict];
}


/**
 *  去除字符串里面的空格
 *
 *  @param str 需要去空格的字符串
 *
 *  @return 返回不包含空格的字符串
 */
+(NSString *)removeSpace:(NSString *)str{
    
    return  [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

/**
 *  计算指定文件夹下所有文件的大小总和
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 返回总的文件大小
 */
+(CGFloat)computeFileSizeForDir:(NSString*)folderPath{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    CGFloat totalSize =0;
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [folderPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            totalSize+= fileAttributeDic.fileSize/ 1024.0/1024.0;
            
        }else{
            
            [self computeFileSizeForDir:fullPath];
        }
    }
    
    return totalSize;
}


/**
 *  删除指定文件夹下的所有文件
 *
 *  @param folderPath 需要清理文件的文件夹
 *
 *  @return <#return value description#>
 */
+(BOOL)deleteFileFromFolderPath:(NSString*)folderPath{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [folderPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSError *removeError;
            [fileManager removeItemAtPath:fullPath error:&removeError];
            //删除出现错误时，做相应的处理
            
        }else{
            
            [self deleteFileFromFolderPath:fullPath];
        }
    }
    
    return YES;
}

/**
 *  获取字符串的首字符(大写)，如果首字符为数字，则返回#号
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)getFirstLetterFromString:(NSString *)string{
    
    NSMutableString *mPinyin = [string mutableCopy];
    
    CFMutableStringRef cfString = (__bridge CFMutableStringRef)mPinyin;
    CFStringTransform(cfString, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(cfString, NULL, kCFStringTransformStripDiacritics, NO);
    
    if ([[(__bridge NSString *)cfString substringToIndex:1] characterAtIndex:0] >= 'a' && [[(__bridge NSString *)cfString substringToIndex:1] characterAtIndex:0] <= 'z') {
        
        return [NSString stringWithFormat:@"%c",[[(__bridge NSString *)cfString substringToIndex:1] characterAtIndex:0] - 32];
        
    }else if ([[(__bridge NSString *)cfString substringToIndex:1] characterAtIndex:0] >= 'A' && [[(__bridge NSString *)cfString substringToIndex:1] characterAtIndex:0] <= 'Z'){
        
        return [(__bridge NSString *)cfString substringToIndex:1];
        
    }else{
        //账号只能是字母、数字
        //如果首字符为数字，则返回#号
        return @"#";
    }
    
    
}


/**
 *  时间戳转时间
 *
 *  @param timestamp <#timestamp description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)convertTimestampToString:(long long)timestamp{
    
    //设置时间显示格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yy/mm/dd hh:mm 24"];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //将时间戳(long long 型)转化为NSDate ,注意除以1000(IOS要求是10位的时间戳)
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    //将NSDate按格式转化为对应的时间格式字符串
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}
+(NSString *)convertTimestampToString:(long long)timestamp format:(NSString *)format{
    //设置时间显示格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:format];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //将时间戳(long long 型)转化为NSDate ,注意除以1000(IOS要求是10位的时间戳)
    //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    //将NSDate按格式转化为对应的时间格式字符串
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}
/**
 *  获取系统当前的时间戳
 *
 *  @return <#return value description#>
 */
+(long long)getCurrentTimestamp{
    
    //获取系统当前的时间戳
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time =[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", time];
    
    return [timeString longLongValue];
}

/**
 *  获取当前时间：小时（按24小时计算）
 *
 *  @return return value description
 */
+(int)getCurrentHour{
    
    NSString *currentTime = [self convertTimestampToString:[self  getCurrentTimestamp]];
    NSRange tempRange = [currentTime rangeOfString:@":"];
    
    NSRange range;
    range.location = tempRange.location - 3;
    range.length = 2;
    
    if ([currentTime containsString:@"上午"]) {
        NSRange amRange = [currentTime rangeOfString:@"午"];
        range.location = amRange.location + 1;
        range.length = tempRange.location - range.location;
        return [[currentTime substringWithRange:range] intValue];
        
    }else if ([currentTime containsString:@"下午"]){
        NSRange pmRange = [currentTime rangeOfString:@"午"];
        range.location = pmRange.location + 1;
        range.length = tempRange.location - range.location;
        
        return ([[currentTime substringWithRange:range] intValue] + 12);
        
    }else{
        NSRange pmRange = [currentTime rangeOfString:@" "];
        range.location = pmRange.location + 1;
        range.length = tempRange.location - range.location;
        
        return [[currentTime substringWithRange:range] intValue];
    }
    
}


/**
 *  将图片保存到应用的沙盒中，返回图片所在的沙盒路径
 *
 *  @param data         <#data description#>
 *  @param imageNameStr <#imageNameStr description#>
 *
 *  @return 返回图片所在的沙盒路径
 */
+(NSString *)saveImageToSandbox:(NSData *)data andImageName:(NSString *)imageNameStr{
    
    //获取沙盒中Library文件夹的路径
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    
    //拼接文件在沙盒中Library/Caches下的完整路径
    NSString *filePath = [NSString stringWithFormat:@"%@/Caches/%@",libraryPath,imageNameStr];
    
    //将图片写入到沙盒路径下的Documents文件夹
    [data writeToFile:filePath atomically:YES];
    
    return filePath;
    
}


/**
 *  返回一个带有背景色的图片
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *)imageWithBgColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 *  将服务器返回的数据中，NSNull对象替换为@""(空字符串)
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+(id)replaceNSNullToStringWithId:(id)obj{
    
    //如果对象是一个字典
    if ([obj isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *mDataDict = [NSMutableDictionary dictionaryWithDictionary:obj];
        //遍历字典内的数据
        for (NSString *key in [mDataDict allKeys]) {
            
            [mDataDict setValue:[self replaceNSNullToStringWithId:mDataDict[key]] forKey:key];
        }
        
        return mDataDict;
        
    }
    //如果对象是一个数组
    else if ([obj isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *mDataArray = [NSMutableArray arrayWithArray:obj];
        //遍历数组内的数据
        for (int i = 0; i < mDataArray.count; i++) {
            
            [mDataArray replaceObjectAtIndex:i withObject:[self replaceNSNullToStringWithId:mDataArray[i]]];
        }
        
        return mDataArray;
        
    }
    //如果对象是一个NSString 或 NSNumber，则直接返回
    else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        
        return obj;
        
    }
    
    else{
        NSLog(@"其它");
        return @"";
    }
    
}


#pragma mark — 归档

+ (NSData *)archiveObj:(id)obj withKey:(NSString *)key
{
    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *keyedA = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [keyedA encodeObject:obj forKey:key];
    [keyedA finishEncoding];
    return data;
}
#pragma mark — 反归档
+ (id)unArchiveObj:(NSData *)data withKey:(NSString *)key
{
    NSKeyedUnarchiver *keyedUnA = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id obj = [keyedUnA decodeObjectForKey:key];
    [keyedUnA finishDecoding];
    return obj;
}



+(NSString *)getFirstFromString:(NSString *)string{
    
    if (string&&string.length>=1) {
           
           NSString * first = [string substringToIndex:1];
           if ([self isChineseWithStr:first]) {
               return first;
           }else{
               return [first uppercaseString];
           }
       }
    return @"";
}



+ (BOOL)isChineseWithStr:(NSString *)str
{
    if (str.length) {
        int a = [str characterAtIndex:0];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }else{
        return NO;
    }
    
}



+ (UIImage*)getImageFromBase64String:(NSString*)url{
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:url options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)getImageFromBase64StringContainImageType:(NSString *)url{
    
    if (url.length) {
           
       url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       url = [url stringByReplacingOccurrencesOfString:@"\r" withString:@""];
       url = [url stringByReplacingOccurrencesOfString:@"\n" withString:@""];
       
       NSURL *baseImageUrl = [NSURL URLWithString:url];
       NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
       UIImage *image = [UIImage imageWithData:imageData];
       
        return image;
    }
    
    return nil;
    
}

+ (NSString *)getBase64StringWithOriginImage:(UIImage *)image scale:(CGFloat)scale{
    
    UIImage *originImage = image;
    
    NSData *imgData = UIImageJPEGRepresentation(originImage, scale);
    
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

    return encodedImageStr;
}

+ (NSString *)getDeviceName{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

   //------------------------------iPhone---------------------------
   if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
   if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
   if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
   if ([platform isEqualToString:@"iPhone3,1"] ||
       [platform isEqualToString:@"iPhone3,2"] ||
       [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
   if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
   if ([platform isEqualToString:@"iPhone5,1"] ||
       [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
   if ([platform isEqualToString:@"iPhone5,3"] ||
       [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
   if ([platform isEqualToString:@"iPhone6,1"] ||
       [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
   if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
   if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
   if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
   if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
   if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
   if ([platform isEqualToString:@"iPhone9,1"] ||
       [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
   if ([platform isEqualToString:@"iPhone9,2"] ||
       [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
   if ([platform isEqualToString:@"iPhone10,1"] ||
       [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
   if ([platform isEqualToString:@"iPhone10,2"] ||
       [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
   if ([platform isEqualToString:@"iPhone10,3"] ||
       [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
   if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
   if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
   if ([platform isEqualToString:@"iPhone11,4"] ||
       [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
   if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
   if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
   if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";

   //------------------------------iPad--------------------------
   if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
   if ([platform isEqualToString:@"iPad2,1"] ||
       [platform isEqualToString:@"iPad2,2"] ||
       [platform isEqualToString:@"iPad2,3"] ||
       [platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
   if ([platform isEqualToString:@"iPad3,1"] ||
       [platform isEqualToString:@"iPad3,2"] ||
       [platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
   if ([platform isEqualToString:@"iPad3,4"] ||
       [platform isEqualToString:@"iPad3,5"] ||
       [platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
   if ([platform isEqualToString:@"iPad4,1"] ||
       [platform isEqualToString:@"iPad4,2"] ||
       [platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
   if ([platform isEqualToString:@"iPad5,3"] ||
       [platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
   if ([platform isEqualToString:@"iPad6,3"] ||
       [platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
   if ([platform isEqualToString:@"iPad6,7"] ||
       [platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
   if ([platform isEqualToString:@"iPad6,11"] ||
       [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
   if ([platform isEqualToString:@"iPad7,11"] ||
       [platform isEqualToString:@"iPad7,12"]) return @"iPad 6";
   if ([platform isEqualToString:@"iPad7,1"] ||
       [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
   if ([platform isEqualToString:@"iPad7,3"] ||
       [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
   
   //------------------------------iPad Mini-----------------------
   if ([platform isEqualToString:@"iPad2,5"] ||
       [platform isEqualToString:@"iPad2,6"] ||
       [platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
   if ([platform isEqualToString:@"iPad4,4"] ||
       [platform isEqualToString:@"iPad4,5"] ||
       [platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
   if ([platform isEqualToString:@"iPad4,7"] ||
       [platform isEqualToString:@"iPad4,8"] ||
       [platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
   if ([platform isEqualToString:@"iPad5,1"] ||
       [platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
   
   //------------------------------iTouch------------------------
   if ([platform isEqualToString:@"iPod1,1"]) return @"iTouch";
   if ([platform isEqualToString:@"iPod2,1"]) return @"iTouch2";
   if ([platform isEqualToString:@"iPod3,1"]) return @"iTouch3";
   if ([platform isEqualToString:@"iPod4,1"]) return @"iTouch4";
   if ([platform isEqualToString:@"iPod5,1"]) return @"iTouch5";
   if ([platform isEqualToString:@"iPod7,1"]) return @"iTouch6";
   
   //------------------------------Samulitor-------------------------------------
   if ([platform isEqualToString:@"i386"] ||
       [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
   
  
    return platform;

}

+(BOOL)checkPhoneOrEmail:(NSString*)phoneOrEmail{
    
    if ([phoneOrEmail containsString:@"@"]) {//邮箱
        return [self validateEmail:phoneOrEmail];
    }else{
        return [self validataPhone:phoneOrEmail];
    }
}

+ (BOOL)validataPhone:(NSString*)phone{
    
    if (phone.length>=5&&phone.length<=11) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)validateEmail: (NSString *) candidate {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validatePassword: (NSString *) password {
//    ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,32}$
    NSString *emailRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,32}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:password];
}


+(void)copyString:(NSString *)copyString{
    if (copyString.length) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = copyString;
        Toast(CALanguages(@"复制成功"));
    }
}



@end
