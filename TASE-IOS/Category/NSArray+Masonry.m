//
//  NSArray+Masonry.m
//  TASE-IOS
//
//   10/22.
//  Copyright © 2019 CA. All rights reserved.
//

#import "NSArray+Masonry.h"

@implementation NSArray (Masonry)

-(void)mas_distributeViewsWithItemHeight:(CGFloat)itemHeight wrapLineCount:(NSInteger)count lineSpace:(CGFloat)lineSpace itemSpace:(CGFloat)itemSpace superView:(UIView *)superView{
    
    [self mas_distributeViewsWithItemHeight:itemHeight wrapLineCount:count lineSpace:lineSpace itemSpace:itemSpace topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0 superView:superView];
    
}



-(void)mas_distributeViewsWithItemHeight:(CGFloat)itemHeight wrapLineCount:(NSInteger)count lineSpace:(CGFloat)lineSpace itemSpace:(CGFloat)itemSpace topSpacing:(CGFloat)topSpacing bottomSpacing:(CGFloat)bottomSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing superView:(UIView *)superView{
    
    UIView * leftView = nil;
    UIView * topView = nil;
    
    UIView * lastView = nil;
    
    if (self.count<count) {
        NSLog(@"少于 %ld个",count);
    }
    NSInteger allCount = 0;
    if (self.count<count) {
        allCount = count;
    }else if (self.count%count!=0){
        NSLog(@"不满一行  补位");
        allCount = self.count+(count-self.count%count);
    }else{
        allCount = self.count;
    }
    
    for (int i=0; i<allCount; i++) {
        
        UIView * view;
        if (i<self.count) {
             view = self[i];
        }else{
            view = [UIView new];
            [superView addSubview:view];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(itemHeight));
            
            if (topView) {
                make.top.equalTo(topView.mas_bottom).offset(lineSpace);
            }else{
                make.top.equalTo(superView).offset(topSpacing);
            }
            
            if (leftView) {
                make.left.equalTo(leftView.mas_right).offset(itemSpace);
                make.width.equalTo(leftView);
                if (i%count==count-1) {
                    make.right.equalTo(superView).offset(tailSpacing);
                }
            }else{
                make.left.equalTo(superView).offset(leadSpacing);
                
            }
            
        }];
        
        if (i%count==count-1) {
            leftView = nil;
            topView = view;
        }else{
            leftView = view;
        }
        
        lastView = view;
    }
    
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(bottomSpacing);
    }];
}

@end
