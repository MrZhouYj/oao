//
//  CATabbarController.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CATabbarController.h"

@interface CATabbarController ()

@property (nonatomic, strong) CAHomeViewController * homeVC;
@property (nonatomic, strong) CABBViewController * BBVC;
@property (nonatomic, strong) CAMarketViewController * marketVC;
@property (nonatomic, strong) CALegalViewController * legalVc;

@end

@implementation CATabbarController

+ (instancetype)shareTabbar{
    static CATabbarController * tabbar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbar = [CATabbarController new];
    });
    return tabbar;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    [self initTabbarItem];
    [self setTabbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];
    
    
    [CANetworkHelper networkStatusWithBlock:^(PPNetworkStatusType status) {
        
        if (status==PPNetworkStatusNotReachable) {
            //无网络时
            [[NSNotificationCenter defaultCenter] postNotificationName:CANetworkDidLoseConenctNotifacation object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:CANetworkDidConenctNotifacation object:nil];
        }
    }];
    
    [[CASocket shareSocket] connectServer];
}


-(void)languageDidChange{
    
    self.homeVC.tabBarItem.title = CALanguages(@"首页");
    self.marketVC.tabBarItem.title = CALanguages(@"行情");
    self.BBVC.tabBarItem.title = CALanguages(@"币币");
    self.legalVc.tabBarItem.title = CALanguages(@"法币");
}

-(void)initTabbarItem{
    
   
    self.homeVC.tabBarItem = [self CreatTabBarItem:CALanguages(@"首页") image:@"home" selectedImage:@"home_high"];
    self.marketVC.tabBarItem = [self CreatTabBarItem:CALanguages(@"行情") image:@"market" selectedImage:@"market_high"];
    self.BBVC.tabBarItem = [self CreatTabBarItem:CALanguages(@"币币") image:@"exchange_trade" selectedImage:@"exchange_trade_high"];
    self.legalVc.tabBarItem = [self CreatTabBarItem:CALanguages(@"法币") image:@"fiat_trade" selectedImage:@"RMB_High"];
    
    self.viewControllers = @[self.homeVC,self.marketVC,self.BBVC,self.legalVc];

}

-(UITabBarItem*)CreatTabBarItem:(NSString*)title image:(NSString*)image selectedImage:(NSString*)selImage{
    
    return [[UITabBarItem alloc] initWithTitle:title image:[IMAGE_NAMED(image) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[IMAGE_NAMED(selImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

-(void)setTabbar{
    
    self.tabBar.layer.shadowColor = [UIColor grayColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0.5, -0.6);
    self.tabBar.layer.shadowRadius = 2;
    self.tabBar.layer.shadowOpacity = 0.3;
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(TabBarBackGroundColor);
    
}

+(void)initialize{
    
    //设置默认时的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRGBHex:0xb8bcd0], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //设置选中时的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRGBHex:0x0091db], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [[IQKeyboardManager sharedManager] setToolbarTintColor:[UIColor blackColor]];
    
    [CASkinManager initSkin];
    [CALanguageManager initUserLanguage];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
    [[UIButton appearance] setAdjustsImageWhenHighlighted:NO];
}

#pragma mark 懒加载

-(CAHomeViewController *)homeVC{
    if (!_homeVC) {
        _homeVC = [[CAHomeViewController alloc] init];
    }
    return _homeVC;
}

-(CABBViewController*)BBVC{
    if (!_BBVC) {
        _BBVC = [[CABBViewController alloc] init];
    }
    return _BBVC;
}
-(CAMarketViewController*)marketVC{
    if (!_marketVC) {
        _marketVC = [[CAMarketViewController alloc] init];
    }
    return _marketVC;
}
-(CALegalViewController*)legalVc{
    if (!_legalVc) {
        _legalVc = [[CALegalViewController alloc] init];
    }
    return _legalVc;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
