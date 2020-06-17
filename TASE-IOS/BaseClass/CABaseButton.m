//
//  CABaseButton.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/23.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABaseButton.h"

@implementation CABaseButton

+(instancetype)buttonWithTitle:(NSString *)title{
    
    CABaseButton * button = [CABaseButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:CALanguages(title) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGE_NAMED(@"cancle_background_icon") forState:UIControlStateNormal];
    button.enabled = NO;
    [button setBackgroundImage:IMAGE_NAMED(@"button_background_highlight") forState:UIControlStateHighlighted];
    button.titleLabel.font = FONT_REGULAR_SIZE(14);

    return button;
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    if (enabled) {
        
       [self setBackgroundImage:IMAGE_NAMED(@"button_background") forState:UIControlStateNormal];
    }else{
        
       [self setBackgroundImage:IMAGE_NAMED(@"cancle_background_icon") forState:UIControlStateNormal];
    }
}

@end
