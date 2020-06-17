//
//  CATranscationPairsView.m
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CATranscationPairsView.h"
#import "CATranscationPairsCollectionView.h"
#import "CASegmentIndicatorView.h"

@interface CATranscationPairsView()<UIScrollViewDelegate>
{
    NSInteger pages;
}
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) CASegmentIndicatorView * indicatorView;

@property (nonatomic, strong) NSMutableArray * items;

@end

@implementation CATranscationPairsView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.items = @[].mutableCopy;
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    
    if (_dataArray.count==dataArray.count) {
        //刷新操作
        _dataArray = dataArray;
        NSInteger index = 0;
        for (CATranscationPairsCollectionView * view in self.items) {
            view.model = dataArray[index];
            index++;
        }
        
    }else{
        
        [self.items removeAllObjects];
        _dataArray = dataArray;
        pages = ceilf(dataArray.count/3.0);
        if (pages>1) {
             self.indicatorView.allPages = pages;
        }

        CGSize size  = [self getItemSize];
        CGFloat startX = 15;
        for (int i=0; i<dataArray.count; i++) {
            
            CATranscationPairsCollectionView * view = [CATranscationPairsCollectionView new];
            [self.scrollView addSubview:view];
            view.frame = CGRectMake(startX, 0, size.width, size.height);
            [self.items addObject:view];
            view.model = dataArray[i];
            CGFloat p =  (i+1)%3==0?15:0;
            startX+= size.width+15+p;
        }
       
        [self.scrollView setContentSize:CGSizeMake(MainWidth*pages, 0)];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(10+pages>1?20:0);
    }];
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
        
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;

        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo([self getItemSize].height+15);
        }];
        
        //灰线
        UIView * lineView = [UIView new];
        [self addSubview:lineView];
        lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@10);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return _scrollView;
}

-(CGSize)getItemSize{
    
    CGFloat width = (MainWidth-60)/3.f;
    CGFloat height = 140/117.f*width;
    return CGSizeMake(width, height);
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = self.scrollView.contentOffset.x;
    CGFloat radio = x/MainWidth;
    NSInteger index = ceilf(radio);
    if (index>=pages) {
        index=pages-1;
    }
    self.indicatorView.curIndex = index;
}

-(CASegmentIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [CASegmentIndicatorView new];
        [self addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@20);
            make.top.equalTo(self.scrollView.mas_bottom).offset(-5);
        }];
    }
    return _indicatorView;
}

@end
