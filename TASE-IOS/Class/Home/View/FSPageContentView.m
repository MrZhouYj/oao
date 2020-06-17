//
//  FSPageContentView.m
//  Huim
//
//  Created by huim on 2017/4/28.
//  Copyright © 2017年 huim. All rights reserved.
//

#import "FSPageContentView.h"
#import "CAHomeTableView.h"

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
static NSString *collectionCellIdentifier = @"collectionCellIdentifier";

@interface FSPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) BOOL isSelectBtn;//是否是滑动

@end

@implementation FSPageContentView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FSPageContentViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.delegate = delegate;
    }
    return self;
}

-(void)setChildsViews:(NSArray *)childsViews{
    
    if (_childsViews.count) {
        _childsViews = @[];
        [self.collectionView reloadData];
    }
    self.contentViewCurrentIndex = 0;
    _childsViews = childsViews;
    [self setupSubViews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView reloadData];
}

#pragma mark --LazyLoad

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
        [self addSubview:collectionView];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark --setup
- (void)setupSubViews
{
    _startOffsetX = 0;
    _isSelectBtn = NO;
    _contentViewCanScroll = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childsViews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    if (IOS_VERSION < 8.0) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         CAHomeTableView*childVC = self.childsViews[indexPath.item];
        childVC.frame = cell.contentView.bounds;
        [cell.contentView addSubview:childVC];
    }
    return cell;
}

#ifdef __IPHONE_8_0
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CAHomeTableView *childVc = self.childsViews[indexPath.row];
    childVc.frame = self.bounds;
    
    [cell.contentView addSubview:childVc];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.bounds.size;
}

#endif

#pragma mark UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isSelectBtn = NO;
    _startOffsetX = scrollView.contentOffset.x;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(FSContentViewWillBeginDragging:)]) {
        [self.delegate FSContentViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isSelectBtn) {
        return;
    }
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex;
    CGFloat progress;
    
    
    
    if (currentOffsetX > _startOffsetX) {//左滑left
        progress = (currentOffsetX - _startOffsetX)/scrollView_W;
        endIndex = startIndex + 1;
        if (endIndex > self.childsViews.count - 1) {
            endIndex = self.childsViews.count - 1;
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(FSContentViewDidScroll:index:)]) {
            [self.delegate FSContentViewDidScroll:self index:floor(currentOffsetX/scrollView_W)];
        }
    }
//    else if (currentOffsetX == _startOffsetX){//没滑过去
//        progress = 0;
//        endIndex = startIndex;
//    }
    else{//右滑right
        progress = (_startOffsetX - currentOffsetX)/scrollView_W;
        endIndex = startIndex - 1;
        endIndex = endIndex < 0?0:endIndex;
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(FSContentViewDidScroll:index:)]) {
            [self.delegate FSContentViewDidScroll:self index:ceil(currentOffsetX/scrollView_W)];
        }
    }
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(FSContentViewDidScroll:startIndex:endIndex:progress:)]) {
        
        [self.delegate FSContentViewDidScroll:self startIndex:startIndex endIndex:endIndex progress:progress];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex = floor(currentOffsetX/scrollView_W);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(FSContenViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate FSContenViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

#pragma mark setter

- (void)setContentViewCurrentIndex:(NSInteger)contentViewCurrentIndex
{
    
    if (!self.childsViews&&self.childsViews.count<=0) {
        return;
    }
    _contentViewCurrentIndex = contentViewCurrentIndex;
    if (_contentViewCurrentIndex < 0||_contentViewCurrentIndex > self.childsViews.count-1) {
        return;
    }
    _isSelectBtn = YES;
    @try {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:contentViewCurrentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

- (void)setContentViewCanScroll:(BOOL)contentViewCanScroll
{
    _contentViewCanScroll = contentViewCanScroll;
    _collectionView.scrollEnabled = _contentViewCanScroll;
}

@end
