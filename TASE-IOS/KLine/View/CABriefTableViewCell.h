//
//  CABriefTableViewCell.h
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CABriefTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString * leftText;

@property (nonatomic, copy) NSString * rightText;

@property (nonatomic, assign) BOOL enableCopy;

-(void)singleBigTitle:(NSString*)title;

-(void)showBriefIntroduct:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
