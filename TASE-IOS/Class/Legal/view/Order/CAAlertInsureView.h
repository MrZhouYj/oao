//
//  CAAlertInsureView.h
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPopupView.h"

typedef void(^ConfirmBlock)(id);
typedef void(^CancleBlock)(void);

@interface CAAlertInsureView : CAPopupView

-(void)showAlert:(NSString*)logo
           title:(NSString*)title
        subTitle:(NSString*)subTitle
       notiTitle:(NSString*)notiTitle
    confirmBlock:(ConfirmBlock)confirm
     cancleBlock:(CancleBlock)cancle;

-(void)showAlertTitle:(NSString*)title
             subTitle:(NSString*)subTitle
     importPayMethods:(NSArray*)payMethods
         confirmBlock:(ConfirmBlock)confirm
          cancleBlock:(CancleBlock)cancle;

@end
