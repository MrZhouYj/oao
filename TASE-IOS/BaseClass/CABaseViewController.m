//
//  CABaseViewController.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseViewController.h"

@interface CABaseViewController ()

@end

@implementation CABaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteBackGroundColor);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
}

-(void)setNavcTitle:(NSString *)navcTitle{
    
    _navcTitle = navcTitle;
    
    self.navcBar.titleLabel.text = CALanguages(navcTitle);
}

-(CANavigationBar *)navcBar{
    if (!_navcBar) {
        _navcBar = [[CANavigationBar alloc] initWithFrame:CGRectMake(0, 0, MainWidth, kTopHeight)];
        [self.view addSubview:_navcBar];
    }
    return _navcBar;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.navcBar.titleLabel.textColor = titleColor;
}

-(void)viewDidLayoutSubviews{
    
    if (_navcBar) {
        [self.view bringSubviewToFront:self.navcBar];
    }
}

-(void)didEnterBackground{
    
}

-(void)willEnterForeground{
  
}

-(void)languageDidChange{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
   
    [self.navigationController setNavigationBarHidden:YES animated:NO];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    if ([[CASkinManager getCurrentSkinType] isEqualToString:DKThemeVersionNight]) {
        //黑夜模式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }else{
        if (@available(iOS 13.0, *)) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
#pragma clang diagnostic pop
    
    NSArray * views = self.navigationController.viewControllers;
    if (views.count>1) {
        
        [self.navcBar.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setBackTineColor:(UIColor *)backTineColor{
    _backTineColor = backTineColor;
    self.navcBar.backButton.tintColor = backTineColor;
}


-(void)backAction{

    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        [self.scrollView addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView.mas_width);
        }];
    }
    return _contentView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self.view addSubview:_scrollView];
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }];
    }
    return _scrollView;
}
-(UILabel *)bigTitleLabel{
    if (!_bigTitleLabel) {
        _bigTitleLabel = [UILabel new];
        [self.view addSubview:_bigTitleLabel];
        _bigTitleLabel.font = FONT_SEMOBOLD_SIZE(25);
        _bigTitleLabel.textColor = HexRGB(0x191d26);
        _bigTitleLabel.frame = CGRectMake(20, self.navcBar.bottom, MainWidth, 55);
    }
    return _bigTitleLabel;
}

-(void)setBigNavcTitle:(NSString *)bigNavcTitle{
    _bigNavcTitle = bigNavcTitle;
    self.bigTitleLabel.text = CALanguages(bigNavcTitle);
}


-(UIImageView *)backGroungImageView{
    if (!_backGroungImageView) {
        _backGroungImageView = [UIImageView new];
        [self.view addSubview:_backGroungImageView];
        _backGroungImageView.userInteractionEnabled = YES;
        _backGroungImageView.image = IMAGE_NAMED(@"controllerbg");
        [_backGroungImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _backGroungImageView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

@end
