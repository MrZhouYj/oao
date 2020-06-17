//
//  CAAboutUsViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAboutUsViewController.h"

@interface CAAboutUsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoTextImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameZHLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameENLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation CAAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLabel.text = NSStringFormat(@"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);

}


@end
