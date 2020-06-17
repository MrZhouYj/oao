//
//  CAFiringViewController.m
//  TASE-IOS

#import "CAFiringViewController.h"
#import "CATabbarController.h"
//#import <Lottie/Lottie.h>
#import "AppDelegate.h"

@interface CAFiringViewController ()

@end

@implementation CAFiringViewController


-(UIImage *)getTheLaunchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;

    NSString *viewOrientation = nil;

    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }

    NSString *launchImage = nil;

    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
  
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
        launchImage = dict[@"UILaunchImageName"];
        }
    }

    return [UIImage imageNamed:launchImage];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * bgImageView = [UIImageView new];
    [self.view addSubview:bgImageView];
//    bgImageView.image = [UIImage imageNamed:@"LaunchImage"];
    bgImageView.image = [self getTheLaunchImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    
    
//    LOTAnimationView * animationView = [LOTAnimationView animationNamed:@"huobi_splash_screen_1"];
//    [self.view addSubview:animationView];
//    CGFloat radioWidth = 750/450.f;
//    animationView.frame = CGRectMake(0, 100, MainWidth ,MainWidth/radioWidth);
//
//    LOTAnimationView * animationView2 = [LOTAnimationView animationNamed:@"huobi_splash_screen_2"];
//    [self.view addSubview:animationView2];
//    CGFloat radioWidth2 = 750/100.f;
//    animationView2.frame = CGRectMake(0, MainHeight-120, MainWidth, MainWidth/radioWidth2);
//
//    [animationView playWithCompletion:^(BOOL animationFinished) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self restoreRootViewController];
//        });
//    }];
//    [animationView2 play];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self restoreRootViewController];
    });
}

- (void)restoreRootViewController
{
    
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
