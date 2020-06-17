//
//  CACountryViewController.h
//  TASE-IOS
//
//   10/29.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseViewController.h"
#import "CACountryModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CACountryViewControllerDelegate <NSObject>

-(void)CACountryViewController_didSelected:(CACountryModel*)model;

@end

@interface CACountryViewController : CABaseViewController

@property (nonatomic, weak) id <CACountryViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
