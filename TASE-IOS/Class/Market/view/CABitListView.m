//
//  CABitListView.m
//  TASE-IOS
//
//   9/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABitListView.h"

static NSInteger baseTag = 1200;

@interface CABitListView()
{
    UIButton * _lastButton;
}
@end

@implementation CABitListView

-(void)setBitListDataArray:(NSArray *)bitListDataArray{
    _bitListDataArray = bitListDataArray;
    [self.contentView removeAllSubViews];
    
    if (_bitListDataArray.count) {
        
        NSMutableArray * mutViewsArray = @[].mutableCopy;
        for (int i=0; i<bitListDataArray.count; i++) {
            UIButton * btn = [self creatButton:bitListDataArray[i] tag:i];
            [self.contentView addSubview:btn];
            [mutViewsArray addObject:btn];
        }
        if (mutViewsArray.count>=2&&mutViewsArray.count<=6) {
           
            [mutViewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:15 tailSpacing:15];
        }else if(mutViewsArray.count==1){
            [mutViewsArray.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView);
            }];
        }
        [mutViewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
        
    }
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    UIButton * btn = (UIButton*)[self.contentView viewWithTag:index+baseTag];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton*)btn{
   
    if (btn.isSelected) {
        return;
    }
    
    [btn setSelected:YES];
    [_lastButton setSelected:NO];
    _lastButton = btn;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(bitListViewDidSelectedIndex:)]) {
        [self.delegate bitListViewDidSelectedIndex:btn.tag-baseTag];
    }
}



-(UIButton*)creatButton:(NSString*)title tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitleColor:RGB(0, 108, 219) forState:UIControlStateSelected];
    [button setTitleColor:RGB(145, 146, 177) forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT_MEDIUM_SIZE(14);
    button.tag = baseTag + tag;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
