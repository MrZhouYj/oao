//
//  CAMineHeaderView.m
//  TASE-IOS
//
//   9/17.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMineHeaderView.h"
#import "LQXSwitch.h"
#import "CAMoneyActionMenuView.h"
#import "CAUser.h"

@interface CAMineHeaderView()
{
    CAMoneyActionMenuView * _menuView;
}
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UIButton * rightRowImageButton;
@property (nonatomic, strong) LQXSwitch * switchView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * uidLabel;
@property (nonatomic, strong) CAUser * user;
@end

@implementation CAMineHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.bgImageView.image = IMAGE_NAMED(@"logo");
        [self initSubViews];
        self.user = [CAUser currentUser];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_gotoUserInfo)]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChangeInfomation) name:CAUserDidChangedUserInfomationNotifacation object:nil];
        
        [self userDidChangeInfomation];
        [self languageDidChange];
       
    }
    return self;
}

-(void)userDidChangeInfomation{
    kWeakSelf(self);
    [self.user getUserDetails:^{
        weakself.nameLabel.text = weakself.user.nick_name;
        [weakself languageDidChange];
    }];
}

-(void)languageDidChange{
    
    if (self.user.isAvaliable) {
        self.nameLabel.text = _user.nick_name;
        self.uidLabel.text = NSStringFormat(@"UID:%@",self.user.uid);
    }else{
        self.nameLabel.text = CALanguages(@"点击登录");
    }
    self.rightRowImageButton.hidden = !self.user.isAvaliable;
//    _switchView.onText = CALanguages(@"夜间");
//    _switchView.offText = CALanguages(@"白天");
    
    if (_menuView) {
        [_menuView languageDidChange];
    }
}

-(void)initSubViews{
    
   
    [self languageDidChange];
    
    UIView * lineView = [UIView new];
    [self addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
    
    
    _menuView = [CAMoneyActionMenuView new];
    [self addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(lineView.mas_top).offset(-20);
        make.width.mas_equalTo(CGRectGetWidth(self.frame)-80);
        make.height.equalTo(@60);
    }];
    
    self.rightRowImageButton = [UIButton new];
    [self addSubview:self.rightRowImageButton];
    [self.rightRowImageButton setImage:IMAGE_NAMED(@"arrowright") forState:UIControlStateNormal];
    self.rightRowImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightRowImageButton.tintColor = HexRGB(0xfefefe);
    [self.rightRowImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.height.equalTo(@10);
        make.centerY.equalTo(self);
    }];
    
 
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.equalTo(self.mas_height);
            make.height.equalTo(self.mas_height);
        }];
    }
    return _bgImageView;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [self addSubview:_nameLabel];
        _nameLabel.font =   FONT_SEMOBOLD_SIZE(23);
        _nameLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.switchView.mas_bottom).offset(15);
            make.left.equalTo(self).offset(40);
        }];
    }
    return _nameLabel;
}
-(UILabel *)uidLabel{
    if (!_uidLabel) {
        _uidLabel = [UILabel new];
        [self addSubview:_uidLabel];
        _uidLabel.font = FONT_REGULAR_SIZE(13);
        _uidLabel.textColor = RGB(133, 139, 181);
        [_uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
        
    }
    return _uidLabel;
}



-(LQXSwitch *)switchView{
    if (!_switchView) {
        _switchView = [[LQXSwitch alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 59, 21) onColor:RGBA(215, 217, 231, 0.96) offColor:HexRGB(0x8e95bd) font:FONT_REGULAR_SIZE(13) ballSize:17];
        [self addSubview:_switchView];
        _switchView.onText = CALanguages(@"夜间");
        _switchView.offText = CALanguages(@"白天");
        _switchView.onTextColor = RGB(142,149,189);
        
        if ([[CASkinManager getCurrentSkinType] isEqualToString:DKThemeVersionNight]) {
            
            [_switchView setOn:NO];
        }else{
            [_switchView setOn:YES];
        }
        
        
        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15+kStatusBarHeight);
            make.right.equalTo(self).offset(-20);
            make.width.equalTo(@59);
            make.height.equalTo(@21);
        }];
        _switchView.hidden = YES;
        _switchView.changeBlock = ^(BOOL ison){
            NSLog(@"%d",ison);
            
            if (@available(iOS 10.0, *)) {
                [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
            } 
            
            if (ison) {
                //设置为黑夜模式
                [CASkinManager setSkin:DKThemeVersionNight];
            }else{
                //设置为白天模式
                [CASkinManager setSkin:DKThemeVersionNormal];
            }
        };
        
       
    }
    return _switchView;
}


-(void)event_gotoUserInfo{
    
    if (_user.isAvaliable) {
        [self routerEventWithName:@"pushViewController" userInfo:@"CAPersonCenterViewController"];
    }else{
        [self routerEventWithName:@"pushViewController" userInfo:@"CAloginViewController"];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
