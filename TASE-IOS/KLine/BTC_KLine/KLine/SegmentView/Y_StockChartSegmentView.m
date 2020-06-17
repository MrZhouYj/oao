//
//  Y_StockChartSegmentView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartSegmentView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "UIButton+ImageTitleSpacing.h"

NSString * const CAStockChartSegmentKey = @"CAStockChartSegmentKey";

@interface Y_StockChartSegmentView()

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation Y_StockChartSegmentView

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        
        // 添加两条线
        UIView * topView = [UIView new];
        [self addSubview:topView];
        
        topView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        UIView * bottomView = [UIView new];
        [self addSubview:bottomView];
        
        bottomView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
// HexRGB(0x9192b1) HexRGB(0x006cdb)
    }
    return self;
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if(items.count == 0 || !items)
    {
        return;
    }
   
    UIView * btnsView = [UIView new];
    [self addSubview:btnsView];
    UIButton *moreButton;
    
    CGFloat width = 0;
    if (self.isFullScreen) {
        width = MainHeight/(items.count+1);
        [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }else{
        width = (MainWidth-50)/(items.count+1);
        
        //最右边的指标
        UIButton * indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:indexButton];
        [indexButton setImage:IMAGE_NAMED(@"chart_setup_normal") forState:UIControlStateNormal];
        [indexButton setImage:IMAGE_NAMED(@"chart_setup_high") forState:UIControlStateSelected];
        indexButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [indexButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
        }];
        indexButton.tag = KLineTypeTimeIndex;
        [indexButton addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [indexButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        
        //更多
        moreButton = [self private_createButtonWithTitle:CALanguages(@"更多") tag:KLineTypeTimeMore];
        [self addSubview:moreButton];
        [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(indexButton.mas_left).offset(-15);
            make.centerY.equalTo(self);
            make.width.equalTo(@(width));
            make.height.equalTo(self);
        }];
        
        [btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(moreButton.mas_left);
        }];
    }
    
    
    NSInteger index = 0;
    UIButton *preBtn = nil;
    
    if ([items.firstObject isKindOfClass:[Y_StockChartViewItemModel class]]) {
        
        for (Y_StockChartViewItemModel * model in items)
        {
            UIButton *btn = [self private_createButtonWithTitle:model.title tag:model.klineType];
            [btnsView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btnsView);
                make.width.equalTo(@(width));
                if(preBtn)
                {
                    make.left.equalTo(preBtn.mas_right);
                } else {
                    make.left.equalTo(btnsView);
                }
            }];
            
            preBtn = btn;
            index++;
        }
    }else{
        
        for (NSString *title in items)
        {
            UIButton *btn = [self private_createButtonWithTitle:title tag:index];
            [btnsView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btnsView);
                make.width.equalTo(btnsView).multipliedBy(1.0/(items.count+0.2));
                if(preBtn)
                {
                    make.left.equalTo(preBtn.mas_right);
                } else {
                    make.left.equalTo(btnsView);
                }
            }];
            
            preBtn = btn;
            index++;
        }
    }
}

#pragma mark 设置底部按钮index
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag: selectedIndex];
    if (btn.tag==KLineTypeTimeIndex) {
        return;
    }
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelectedBtn:(UIButton *)selectedBtn
{
    if (selectedBtn.tag==KLineTypeTimeIndex||selectedBtn.tag==KLineTypeTimeMore) {
        NSLog(@"点击的是指标");
        return;
    }
    if(_selectedBtn == selectedBtn)
    {
       
    }
    [_selectedBtn setSelected:NO];
    [_selectedBtn.titleLabel setFont:FONT_SEMOBOLD_SIZE(13)];
    [selectedBtn setSelected:YES];
    [selectedBtn.titleLabel setFont:FONT_SEMOBOLD_SIZE(13)];
    _selectedBtn = selectedBtn;
    _selectedIndex = selectedBtn.tag;
    [self layoutIfNeeded];
}

#pragma mark - 私有方法
#pragma mark 创建底部按钮
- (UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:RGB(145, 146, 177) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(0, 108, 219) forState:UIControlStateSelected];
    btn.titleLabel.font = FONT_SEMOBOLD_SIZE(13);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    
//    if (!self.isFullScreen) {
//        if (tag == 2004 || tag == 2005) {
//            [btn setImage:IMAGE_NAMED(@"kline_arrow") forState:UIControlStateNormal];
//            [btn layoutButtonWithEdgeInsetsStyle:ZMButtonEdgeInsetsStyleRight imageTitleSpace:12];
//        }
//        else if (tag == 2007){
//            [btn setImage:IMAGE_NAMED(@"transaction-fullscreen-ic") forState:UIControlStateNormal];
//        }
//    }
   
    return btn;
}

#pragma mark 底部按钮点击事件
- (void)event_segmentButtonClicked:(UIButton *)btn {
    if (btn.tag == 2005) {
//        if (self.isFullScreen) {
//            self.selectedBtn = btn;
//        }
    }
    else{
        
    }
    
    if (btn.tag==KLineTypeTimeIndex||btn.tag==KLineTypeTimeMore) {
        if (self.selectedBtn.tag==btn.tag) {
            NSLog(@"不会重复点击的");
            return;
        }
    }
    if (btn.tag == 2010 && self.isFullScreen) {
        
    }else{
        
    }
    self.selectedBtn = btn;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate y_StockChartSegmentView:self clickSegmentButtonIndex: btn.tag];
    }
}

@end
