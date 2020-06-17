//
//  CASegmentView.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASegmentView.h"
#import "CACurrencyModel.h"

@interface CASegmentView()<UIScrollViewDelegate>
{
    UIButton * _lastBtn;
    CGFloat _itemWidth;
    CGRect _originRect;
}

@property (nonatomic, strong) UIView * rightRowView;
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation CASegmentView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(SegmentBackGroundColor);
        _maxCount = 6;
        _isFixedSpace = YES;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dk_backgroundColorPicker = DKColorPickerWithKey(SegmentBackGroundColor);
        _maxCount = 6;
        _isFixedSpace = YES;
        
    }
    return self;
}

-(UIView *)rightRowView{
    if (!_rightRowView) {
        _rightRowView = [UIView new];
        [self addSubview:_rightRowView];
        
//        UIImageView * imageV = [UIImageView new];
//        [_rightRowView addSubview:imageV];
//        imageV.image = IMAGE_NAMED(@"arrowright");
//        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.centerY.equalTo(self->_rightRowView);
//            make.width.equalTo(@6);
//            make.height.equalTo(@11);
//        }];
        
        [_rightRowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBottomClick)]];
        
    }
    return _rightRowView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;

    }
    return _scrollView;
}

-(void)setSegmentCurrentIndex:(NSInteger)segmentCurrentIndex{

    _segmentCurrentIndex = segmentCurrentIndex;
    if (self.segmentItems.count>segmentCurrentIndex) {
        
        UIButton * btn = (UIButton*)[self.scrollView viewWithTag:111+segmentCurrentIndex];
        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self adjustScrollContentOffsetX:btn];
    }
}

-(void)setSegmentItems:(NSArray *)segmentItems{
    
    _segmentItems = segmentItems;
    
    NSMutableArray * views = @[].mutableCopy;
    NSInteger count = _segmentItems.count>_maxCount?_maxCount:self.isFixedSpace?segmentItems.count:_maxCount;
   
    CGFloat width = CGRectGetWidth(self.frame)/(float)count;
    self->_itemWidth = width;
    _lastBtn = nil;
    [self.scrollView removeAllSubViews];
    
    for (int i=0; i<segmentItems.count; i++) {
        
        UIButton * button = [self private_creatButtonTitle:segmentItems[i] tag:111+i];
        [self.scrollView addSubview:button];
        button.frame = CGRectMake(width*i, 0, width, CGRectGetHeight(self.frame)-2);
        [views addObject:button];
        
        if (i==0) {
            self.bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-2, 40, 2);
            self.bottomLineView.centerX = button.centerX;
        }
    }
    
    [self.scrollView addSubview:self.bottomLineView];
    
    if (segmentItems.count>self->_maxCount) {
        [self.scrollView setContentSize:CGSizeMake(width*segmentItems.count, 0)];
//        [self.rightRowView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self);
//            make.height.equalTo(self);
//            make.width.equalTo(@40);
//        }];
//        [self bringSubviewToFront:self.rightRowView];
        
//        CALayer * layer = [[CALayer alloc] init];
//        layer.frame = CGRectMake(20, 0, 20, CGRectGetHeight(self.frame));
//        layer.backgroundColor = HexRGBA(0xedf5fc,1).CGColor;
//        [self.rightRowView.layer insertSublayer:layer atIndex:0];
        
        
        
//        UIColor *colorOne = HexRGBA(0xedf5fc,0.5);
//        UIColor *colorTwo = HexRGBA(0xedf5fc,1);
//        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        //设置开始和结束位置(设置渐变的方向)
//        gradient.startPoint = CGPointMake(0, 0);
//        gradient.endPoint = CGPointMake(1, 0);
//        gradient.colors = colors;
//        gradient.frame = CGRectMake(0, 0, 20, CGRectGetHeight(self.frame));
//        [self.rightRowView.layer insertSublayer:gradient atIndex:0];
        
    }
    
}

-(UIButton*)private_creatButtonTitle:(NSString *)title tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self.normalColor) {
         [button setTitleColor:self.normalColor forState:UIControlStateNormal];
    }else{
         [button setTitleColor:RGB(133, 139, 181) forState:UIControlStateNormal];
    }
    
    if (self.selectedColor) {
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
    }else{
        [button setTitleColor:RGB(0, 108, 219) forState:UIControlStateSelected];
    }
    
    if (self.itemFont) {
        button.titleLabel.font = self.itemFont;
    }else{
        button.titleLabel.font = FONT_MEDIUM_SIZE(14);
    }
    
    button.tag = tag;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:CALanguages(title) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(event_click:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)event_click:(UIButton*)btn{
    
    
    [self.scrollView bringSubviewToFront:self.bottomLineView];
    self.bottomLineView.centerX = btn.centerX;
    [self adjustScrollContentOffsetX:btn];
    

    if (_lastBtn.tag!=btn.tag) {
        [btn setSelected:YES];
        [_lastBtn setSelected:NO];
        _lastBtn = btn;
    }
    if (self.delegata&&[self.delegata respondsToSelector:@selector( CASegmentView_didSelectedIndex:)]) {
        [self.delegata  CASegmentView_didSelectedIndex:btn.tag-111];
    }

}

//当前选中的btn
-(void)adjustScrollContentOffsetX:(UIButton*)btn{
    
    if (self.segmentItems.count>_maxCount) {
        if (btn.center.x > self.frame.size.width/2.0) {
            if (btn.center.x - self.frame.size.width/2.0 < (self.scrollView.contentSize.width - self.frame.size.width)) {
                [self.scrollView setContentOffset:CGPointMake(btn.center.x - self.frame.size.width/2.0, 0) animated:YES];
            } else {
                [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width - self.frame.size.width), 0) animated:YES];
            }
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
      [self dealScroll];
}

-(void)showBottomClick{
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-self.scrollView.width, 0) animated:YES];
}

-(void)dealScroll{
    if (self.segmentItems.count>_maxCount) {
        
        CGFloat curX = self.scrollView.contentOffset.x;
        CGFloat contentSizeW = self.scrollView.contentSize.width;
        CGFloat contentW = self.scrollView.width;
        
        if (curX+contentW==contentSizeW) {
            //滚动到底部
            [self hideRow];
        }else{
            [self showRow];
        }
    }
}

-(void)initOriginReact{
    if (_originRect.size.width) {
        return;
    }
    _originRect = self.rightRowView.frame;
}

-(void)showRow{
    
    [self initOriginReact];
    if (!self.rightRowView.isHidden) {
        return;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
       
        self.rightRowView.frame = self->_originRect;
        self.rightRowView.alpha = 1;
    
        
    }completion:^(BOOL finished) {
        self.rightRowView.hidden = NO;
    }];
}
-(void)hideRow{
    [self initOriginReact];
    if (self.rightRowView.isHidden) {
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.rightRowView.frame = CGRectMake(CGRectGetMinX(self->_originRect), 0, CGRectGetWidth(self->_originRect), CGRectGetHeight(self->_originRect));
        self.rightRowView.alpha = 0;
        
    }completion:^(BOOL finished) {
        self.rightRowView.hidden = YES;
    }];
}

-(void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    if (_showBottomLine) {
        self.bottomLineView.backgroundColor = self.selectedColor;
    }
}

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
    }
    return _bottomLineView;
}

+(NSArray *)getItemsFromArray:(NSArray *)array{
    NSMutableArray * mutArray = @[].mutableCopy;
    for (CACurrencyModel * model in array) {
        [mutArray addObject:model.code_big];
    }
    return mutArray;
}

@end
