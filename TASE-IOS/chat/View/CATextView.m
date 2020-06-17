//
//  CATextView.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/4.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CATextView.h"

@implementation CATextView

-(instancetype)init{
    self = [super init];
    if (self) {
       UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:CALanguages(@"复制") action:@selector(copyAction:)];
       UIMenuController *menuController = [UIMenuController sharedMenuController];
       [
        menuController
        setMenuItems:[NSArray arrayWithObject:menuItem]];
       [menuController setMenuVisible:NO];
    }
    return self;
}

//隐藏系统菜单的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //允许显示
    if (action == @selector(copyAction:)) {
        return YES;
    }
    //其他不允许显示
    return NO;
}

//自定义的事件
- (void)copyAction:(id)sender{
    
     NSString * string = self.text;
     string = [string  substringWithRange:self.selectedRange];
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
     pasteboard.string = string;
    [self resignFirstResponder];
}

@end
