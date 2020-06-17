//
//  CAOrderInfoCellModel.h
//  TASE-IOS
//
//  Created by ZEMac on 2020/2/4.
//  Copyright © 2020 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAOrderInfoCellModel : NSObject

@property (nonatomic, copy) NSString * leftTitle;
@property (nonatomic, copy) NSString * rightContentText;
@property (nonatomic, strong) UIImage * rightContentImage;
@property (nonatomic, assign) BOOL enableCopy;

@property (nonatomic, copy) NSString * rightContent;
@property (nonatomic, assign) BOOL showRow;


+(instancetype)modelWithleftTitle:(NSString*)leftTitle
                     rightContent:(NSString*)rightContent
                          showRow:(BOOL)showRow
                       enableCopy:(BOOL)enableCopy;

@end

NS_ASSUME_NONNULL_END
