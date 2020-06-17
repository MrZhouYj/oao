//
//  CAWelcomeViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAWelcomeViewController.h"
#import "CATabbarController.h"
#import "AppDelegate.h"
#import "WelcomeVIew.h"
@interface CAWelcomeViewController ()
<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray * _welcomes;
}
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation CAWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _welcomes = @[@{
                      @"icon":@"wel-1",
                      @"progress":@"progress-1",
                      @"hanzi":@"国际交易平台",
                      @"en":@"International Trading Platform"
    },@{
                      @"icon":@"wel-2",
                      @"progress":@"progress-2",
                      @"hanzi":@"实时市场监控",
                      @"en":@"Real Time Market Monitoring"
    },@{
                      @"icon":@"wel-3",
                      @"progress":@"progress-3",
                      @"hanzi":@"资产安全保障",
                      @"en":@"Keeping Asset Security"
    },];
    
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    self.scrollView.contentSize=CGSizeMake(MainWidth*_welcomes.count, 0);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    self.scrollView.bounces=NO;
    
    int i=0;
    for (NSDictionary * welcome in _welcomes) {
    
        WelcomeVIew * imageView = [[WelcomeVIew alloc] initWithFrame:CGRectMake(i*MainWidth, 0, MainWidth, MainHeight)];
        [self.scrollView addSubview:imageView];
        
        imageView.iconImageView.image = IMAGE_NAMED(welcome[@"icon"]);
        imageView.hanziLabel.text = welcome[@"hanzi"];
        imageView.enLabel.text = welcome[@"en"];
        imageView.progressImageView.image = IMAGE_NAMED(welcome[@"progress"]);
        
        if (i==_welcomes.count-1) {
            imageView.enterButton.hidden = NO;
            [imageView.enterButton addTarget:self action:@selector(restoreRootViewController) forControlEvents:UIControlEventTouchUpInside];
        }
        i++;
    }
}
- (void)restoreRootViewController
{
    [CommonMethod writeToUserDefaults:@(1) withKey:@"hasShowWelcome"];
    CATabbarController * tabView = [CATabbarController shareTabbar];
    CABaseNavigationController * rootViewController = [[CABaseNavigationController alloc] initWithRootViewController:tabView];
    
    typedef void (^Animation)(void);
    UIWindow* window = [AppDelegate shareAppDelegate].window;
    
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}


@end
