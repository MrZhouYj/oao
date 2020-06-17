//
//  CAChatBoxMoreView.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/10/31.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChatBoxMoreView.h"

@implementation CAChatBoxMoreView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        UIView * CameraView = [self creatItem:@"xiangji" title:CALanguages(@"拍照") leftView:nil tag:CAChatBoxMoreViewActionTypeCamera];
        [self creatItem:@"xiangce" title:CALanguages(@"相册") leftView:CameraView tag:CAChatBoxMoreViewActionTypeAlbum];

    }
    return self;
}

-(UIView*)creatItem:(NSString*)imageUrl title:(NSString*)title leftView:(UIView*)leftView tag:(NSInteger)tag {
    
    UIView * view = [UIView new];
    [self addSubview:view];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [view addSubview:button];
    
    UILabel * label = [UILabel new];
    [view addSubview:label];
    
    [button setImage:[IMAGE_NAMED(imageUrl) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    button.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    
    label.text = title;
    label.font = FONT_MEDIUM_SIZE(14);
    label.dk_textColorPicker  = DKColorPickerWithKey(NormalBlackColor_191d26);
    label.textAlignment = NSTextAlignmentCenter;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        if (leftView) {
            make.left.equalTo(leftView.mas_right).offset(20);
        }else{
            make.left.equalTo(self).offset(15);
        }
        make.height.equalTo(@70);
        make.width.equalTo(@50);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(view.mas_width);
        make.top.equalTo(view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(button.mas_bottom).offset(10);
    }];
    
    [button addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    return view;
}

-(void)didClick:(UIButton*)btn{
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(CAChatBoxMoreViewActionType_didSelectItem:)]) {
        [self.delegate CAChatBoxMoreViewActionType_didSelectItem:btn.tag];
    }
}

@end
