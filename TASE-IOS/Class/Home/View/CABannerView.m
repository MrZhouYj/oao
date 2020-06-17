//
//  CABannerView.m
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABannerView.h"
#import "CABannerModel.h"

@interface CABannerCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation CABannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _imageView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:_imageView];

    }
    return self;
}

@end

@interface CABannerView()
<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int PageIndex;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIPageControl *mypageControl;

@end

@implementation CABannerView


- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    
    return _imageViews;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.PageIndex = -1;
        [self addNSTimer];
    }
    return self;
}

- (UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.width, self.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor clearColor];
      
        [_myCollectionView registerClass:[CABannerCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
        
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:100 / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
        [self addSubview:_myCollectionView];
        
        _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.width-100)/2, self.height-20, 100, 20)];
        _mypageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _mypageControl.pageIndicatorTintColor = HexRGB(0x0091db);
        [self addSubview:_mypageControl];
    }
    return _myCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 100;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CABannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    if (_items.count>indexPath.row) {
        CABannerModel * model = _items[indexPath.row];
        NSString *imgUrl = [model.image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    }
    return cell;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    if (_items.count<2) {
        self.myCollectionView.scrollEnabled = NO;
        [self.mypageControl setHidden:YES];
    }else{
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:NO];
    }
    
    [self.myCollectionView reloadData];
    self.mypageControl.numberOfPages = _items.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    if (self.PageIndex == page) return;
    self.PageIndex = page;
    self.mypageControl.currentPage = page;
}

#pragma mark -添加定时器
-(void)addNSTimer{
    
    _timer = [NSTimer scheduledAutoReleaseTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userinfo:nil repeats:YES];
    
}

- (void)nextPage{
    
    if (_items.count<1) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.myCollectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:100 / 2];
    [self.myCollectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == _items.count) {
        nextItem = 0;
        nextSection ++;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_items.count>indexPath.row) {
        CABannerModel * model = _items[indexPath.row];
        [self routerEventWithName:NSStringFromClass(self.class) userInfo:model.url];
    }
    
}


#pragma mark -删除定时器

-(void)removeNSTimer{
    [_timer invalidate];
    _timer =nil;
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}

#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}



@end
