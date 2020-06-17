//
//  CAOrderInfoCellModel.m
//  TASE-IOS
//
//  Created by ZEMac on 2020/2/4.
//  Copyright © 2020 CA. All rights reserved.
//

#import "CAOrderInfoCellModel.h"

@implementation CAOrderInfoCellModel

+(instancetype)modelWithleftTitle:(NSString *)leftTitle rightContent:(NSString *)rightContent showRow:(BOOL)showRow enableCopy:(BOOL)enableCopy{
    
    CAOrderInfoCellModel * model = [CAOrderInfoCellModel new];
    
    model.leftTitle = leftTitle;
    model.rightContentText = rightContent;
    model.showRow = showRow;
    model.enableCopy = enableCopy;
    
    return model;
}

@end
