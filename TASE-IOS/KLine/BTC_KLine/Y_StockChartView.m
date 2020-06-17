//
//  Y-StockChartView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartView.h"
#import "Y_KLineView.h"
#import "Masonry.h"
#import "Y_StockChartSegmentView.h"
#import "Y_StockChartGlobalVariable.h"
#import "CAIndicatorSegmentView.h"

//static NSInteger const Y_StockChartSegmentIndicatorIndex = 3000;

@interface Y_StockChartView()
<Y_StockChartSegmentViewDelegate,
CAIndicatorSegmentViewDelegata
>

/**
 *  底部主选择View
 */
@property (nonatomic, strong) Y_StockChartSegmentView *segmentView;

@property (nonatomic, strong) UIView *scorllLine;

@property (nonatomic, strong) UIView *moreSegmentView;
@property (nonatomic, strong) UIButton *moreSelectedBtn;
@property (nonatomic, strong) CAIndicatorSegmentView *indicatorSegmentView;
@property (nonatomic, strong) UIButton *indicatorSelectedBtn;
@property (nonatomic, strong) UIButton *indicatorSegmentSelectedBtnOne;
@property (nonatomic, strong) UIButton *indicatorSegmentSelectedBtnTwo;
//kline时间类型0~9  time  1 15 1h 4h 5 30 60 1d 1w 1m
//@property (nonatomic, assign) NSInteger currentKlineType;
//当前是否显示
@property (nonatomic, assign) BOOL isShowMoreSegmentView;
@property (nonatomic, assign) BOOL isShowindicatorSegmentView;
/**
 *  图表类型
 */
@property(nonatomic,assign) Y_StockChartCenterViewType currentCenterViewType;

/**
 *  当前索引
 */
@property(nonatomic,assign,readwrite) NSInteger currentIndex;
@end


@implementation Y_StockChartView

- (Y_KLineView *)kLineView
{
    if(!_kLineView)
    {
        _kLineView = [Y_KLineView new];
        [_kLineView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_kLineView];
        self.targetLineStatus = Y_StockChartTargetLineStatusMA ;
        self.targetLineAccessoryViewStatus = Y_StockChartTargetLineStatusMACD;
        
        _kLineView.isFullScreen = self.isFullScreen;
        if (_isFullScreen) {
            [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self);
                make.bottom.equalTo(@-30);
                make.right.equalTo(self.indicatorSegmentView.mas_left);
            }];
            
        }else{
            [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.equalTo(self);
                make.top.equalTo(self.segmentView.mas_bottom);
            }];
        }
        
    }
    return _kLineView;
}

- (Y_StockChartSegmentView *)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [Y_StockChartSegmentView new];
        _segmentView.isFullScreen = self.isFullScreen;
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        
        if (_isFullScreen) {
            [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self);
                make.top.equalTo(self.kLineView.mas_bottom);
            }];
        }
        else{
            [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.top.equalTo(self);
                make.height.mas_equalTo(41);
            }];
        }
        [_segmentView layoutIfNeeded];
        
        
        UIView *scorllLine = [[UIView alloc] init];
        scorllLine.backgroundColor = HexRGB(0x006cdb);
        [_segmentView addSubview:scorllLine];
        scorllLine.frame = CGRectMake(0, self.isFullScreen?_segmentView.height-2:_segmentView.height-10, 40, 2);
        self.scorllLine = scorllLine;
        
    }
    return _segmentView;
}

- (UIView *)moreSegmentView
{
    if(!_moreSegmentView)
    {
        _moreSegmentView = [UIView new];
        _moreSegmentView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
        [_moreSegmentView isYY];
        
        NSArray *titleArr =
                @[
                [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1分")
                                                    klineType:KLineType1Min
                                                         type:Y_StockChartcenterViewTypeKline],
                [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"5分")
                                                    klineType:KLineType5Min
                                                         type:Y_StockChartcenterViewTypeKline],
                [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"30分")
                                                    klineType:KLineType30Min
                                                         type:Y_StockChartcenterViewTypeKline],
                [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"周线")
                                                    klineType:KLineType1Week
                                                         type:Y_StockChartcenterViewTypeKline],
                [Y_StockChartViewItemModel itemModelWithTitle:CALanguages(@"1月")
                                                    klineType:KLineType1Month type:Y_StockChartcenterViewTypeKline]
                ];
        
        __block UIButton *preBtn;
        
        [titleArr enumerateObjectsUsingBlock:^(Y_StockChartViewItemModel*  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:HexRGB(0x9192b1) forState:UIControlStateNormal];
            [btn setTitleColor:HexRGB(0x006cdb) forState:UIControlStateSelected];
            btn.titleLabel.font = FONT_SEMOBOLD_SIZE(13);
            btn.tag = model.klineType;
            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:model.title forState:UIControlStateNormal];
            [_moreSegmentView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_moreSegmentView).multipliedBy(1.0f/6);
                make.height.equalTo(_moreSegmentView);
                make.top.equalTo(_moreSegmentView);
                if(preBtn)
                {
                    make.left.equalTo(preBtn.mas_right);
                } else {
                    make.left.equalTo(_moreSegmentView);
                }
            }];
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            [_moreSegmentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            preBtn = btn;
        }];
        [self addSubview:_moreSegmentView];
        _moreSegmentView.hidden = YES;
        self.isShowMoreSegmentView = NO;
        if (_isFullScreen) {
            [_moreSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.bottom.equalTo(self).offset(-32);
                make.height.equalTo(@44);
            }];
        }
        else{
            [_moreSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(41+5);
                make.height.equalTo(@44);
            }];
        }
       
    }
    return _moreSegmentView;
}



- (CAIndicatorSegmentView *)indicatorSegmentView
{
    if(!_indicatorSegmentView)
    {
        _indicatorSegmentView = [CAIndicatorSegmentView new];
        [self addSubview:_indicatorSegmentView];
        
        _indicatorSegmentView.delegata = self;
        _indicatorSegmentView.isFullScreen = self.isFullScreen;
        
        if (_isFullScreen) {
            [_indicatorSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(self);
                make.width.equalTo(@45);
                make.bottom.equalTo(self.segmentView.mas_top);
            }];
            [self bringSubviewToFront:_indicatorSegmentView];
            
        }
        else{
            [_indicatorSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(41+5);
            }];
            _indicatorSegmentView.hidden = YES;
            [_indicatorSegmentView isYY];
        }
    }
    return _indicatorSegmentView;
}

- (void)setItemModels:(NSArray *)itemModels {
    _itemModels = itemModels;
    if(itemModels){
//        NSMutableArray *items = [NSMutableArray array];
//        for(Y_StockChartViewItemModel *item in itemModels){
//            [items addObject:item.title];
//        }
        self.segmentView.items = itemModels;
//        Y_StockChartViewItemModel *firstModel = itemModels.firstObject;
//        self.currentCenterViewType = firstModel.centerViewType;
    }
    if(self.dataSource){
        
       
//        if (!self.isFullScreen) {
////            self.segmentView.selectedIndex = 1;
//            self.currentKlineType = 1;
//            self.kLineView.lineKTime = 1;
//        }
//        else{
////            self.segmentView.selectedIndex = 1;
//            self.currentKlineType = 1;
//            self.kLineView.lineKTime = 1;
//        }
    }
}

- (void)setDataSource:(id<Y_StockChartViewDataSource>)dataSource {
    _dataSource = dataSource;
    if(self.itemModels)
    {
        [self initSegmentData];
    }
}

- (void)initSegmentData{
    
    if (self.lastKlineType) {
        
        self.currentKlineType = self.currentKlineType;
        self.segmentView.selectedIndex = self.lastKlineType;
        
    }else{
        self.currentKlineType = KLineType15Min;
        self.currentIndex = KLineType15Min;
        self.segmentView.selectedIndex = KLineType15Min;
    }
 
    
//    NSString * selectedIndex = [CommonMethod readFromUserDefaults:CAStockChartSegmentKey];
//    if (selectedIndex) {
//        if (selectedIndex.intValue>=0&&selectedIndex.intValue<4) {
//            self.segmentView.selectedIndex = selectedIndex.intValue;
//        }else{
//            if (self.moreSegmentView) {
//                UIButton * btn = (UIButton*)[self.moreSegmentView viewWithTag:selectedIndex.intValue];
//                if (btn) {
//                    self.currentIndex = selectedIndex.intValue;
//                    self.segmentView.selectedIndex = 4;
//                    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    self.moreSegmentView.hidden = YES;
//                }
//            }
//        }
//    }else{
//
//    }
}

- (void)reloadData {
    
//    self.isShowMoreSegmentView = YES;
//    if (self.isMoreTimeDataUpdate && self.currentIndex == 4) {
//        id stockData = [self.dataSource stockDatasWithIndex:self.currentKlineType];
//        if(!stockData) {
//            return;
//        }
//
//        self.kLineView.kLineModels = (NSArray *)stockData;
//        self.kLineView.targetLineStatus = self.targetLineStatus;
//        self.kLineView.targetLineAccessoryViewStatus = self.targetLineAccessoryViewStatus;
//        self.kLineView.MainViewType = Y_StockChartcenterViewTypeKline;
//        if (self.currentKlineType == KLineTypeTimeLine) {
//            self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
//        }
//        [self.kLineView reDraw];
//    }else{
//
//    }
    [self reloadDataWithTimeIndex:self.currentKlineType];
}

#pragma mark - 代理方法

- (void)y_StockChartSegmentView:(Y_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index {
     self.currentIndex = index;
    [self resetSegmentUI:(Y_KLineType)index];
}

-(void)resetSegmentUI:(Y_KLineType)index{
    
    if (!self.isFullScreen) {
            if (index == KLineTypeTimeMore ){//更多时间
                UIButton * moreBut = [self.segmentView viewWithTag:KLineTypeTimeMore];
                if (self.isShowMoreSegmentView) {
                    
                    self.moreSegmentView.hidden = YES;
                    self.isShowMoreSegmentView = NO;
                    
                    if (self.currentKlineType == KLineTypeTimeLine||self.currentKlineType == KLineType15Min||self.currentKlineType == KLineType1Hour||self.currentKlineType == KLineType1Day) {
                        UIButton * but =  [self.segmentView viewWithTag:self.currentKlineType];
                        [but setSelected:YES];
                        [moreBut setSelected:NO];
                    }else{
                       [moreBut setSelected:YES];
                    }
                }
                else{
                    [moreBut setSelected:YES];
                    self.moreSegmentView.hidden = NO;
                    self.isShowMoreSegmentView = YES;
                }
                
                self.indicatorSegmentView.hidden = YES;
                self.isShowindicatorSegmentView = NO;
                UIButton *btn = [self.segmentView viewWithTag:KLineTypeTimeIndex];
                btn.selected = NO;
                [self bringSubviewToFront:self.moreSegmentView];
            }
            else if (index == KLineTypeTimeIndex ){//指标
                UIButton *btn = [self.segmentView viewWithTag:KLineTypeTimeIndex];
//                if (self.currentKlineType >= 0 && self.currentKlineType <= 4) {
//                    self.segmentView.selectedIndex =  self.currentKlineType;
//                    [self.segmentView setNeedsLayout];
//                }
                if (self.isShowindicatorSegmentView == YES) {
                    self.indicatorSegmentView.hidden = YES;
                    self.isShowindicatorSegmentView = NO;
                    
                    [btn setSelected:NO];
                }else{
                    self.indicatorSegmentView.hidden = NO;
                    self.isShowindicatorSegmentView = YES;
                    
                    [btn setSelected:YES];
                    self.moreSegmentView.hidden = YES;
                    self.isShowMoreSegmentView = NO;
                    [self bringSubviewToFront:self.indicatorSegmentView];
                }
                
            }else { //分时、1分、15分、4小时
                            
                if (self.moreSelectedBtn) {
                    if (self.moreSelectedBtn.isSelected) {
                        [self.moreSelectedBtn setSelected:NO];
                    }
                }
                self.currentKlineType = index;
                self.kLineView.lineKTime = self.currentKlineType;
                [self reloadDataWithTimeIndex:index];
                UIButton *btn = [self.segmentView viewWithTag:KLineTypeTimeMore];
                [btn setTitle:CALanguages(@"更多") forState:UIControlStateNormal];
            }
        }
    else{
    if (index==20) {
        
    }else{
        self.currentKlineType = index;
        self.kLineView.lineKTime = self.currentKlineType;
        [self reloadDataWithTimeIndex:index];
    }
            
    //        if (index == 9 ){//指标
    //            if (self.isFullScreen) {
    //                return;
    //            }
    //            if (self.isShowindicatorSegmentView == YES) {
    //                self.indicatorSegmentView.hidden = YES;
    //                self.isShowindicatorSegmentView = NO;
    //                UIButton *btn = [self.segmentView viewWithTag:2010];
    //                btn.selected = NO;
    //            }
    //            else{
    //                self.indicatorSegmentView.hidden = NO;
    //                self.isShowindicatorSegmentView = YES;
    //                UIButton *btn = [self.segmentView viewWithTag:2010];
    //                btn.selected = YES;
    //                self.moreSegmentView.hidden = YES;
    //                self.isShowMoreSegmentView = NO;
    //                [self bringSubviewToFront:self.indicatorSegmentView];
    //            }
    //        }
    //        else { //分时、1分、15分、1小时
    //            self.currentKlineType = index;
    //            self.kLineView.lineKTime = self.currentKlineType;
    //            [self reloadDataWithTimeIndex:index];
    //            [_moreSelectedBtn setSelected:NO];
    //        }
        }
}

- (void) reloadDataWithTimeIndex:(Y_KLineType )klineType {
   
    if (!self.isFullScreen) {
        self.indicatorSegmentView.hidden = YES;
    }
    
    UIButton *btn = nil;
    
    if (klineType==KLineTypeTimeLine||klineType==KLineType15Min||klineType==KLineType1Hour||klineType==KLineType1Day||klineType==KLineTypeTimeMore) {
        btn = [_segmentView viewWithTag:klineType];
    }else {
        btn = [_segmentView viewWithTag:self.isFullScreen?klineType:KLineTypeTimeMore];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scorllLine.centerX = btn.centerX;
    }];

    self.moreSegmentView.hidden = YES;
    self.isShowMoreSegmentView = NO;
    
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        
        id stockData = [self.dataSource stockDatasWithIndex:klineType];
        if(!stockData) {
            return;
        }
        Y_StockChartCenterViewType type = Y_StockChartcenterViewTypeKline;
//        if (klineType < [self.itemModels count]) {
//             Y_StockChartViewItemModel *itemModel = self.itemModels[klineType];
//             type = itemModel.centerViewType;
//        }
        if(type != self.currentCenterViewType) {
            //移除当前View，设置新的View
            self.currentCenterViewType = type;
            switch (type) {
                case Y_StockChartcenterViewTypeKline:
                {
                    self.kLineView.hidden = NO;
                    [self bringSubviewToFront:self.segmentView];
                }
                    break;
                default:
                    break;
            }
        }
        if(type == Y_StockChartcenterViewTypeOther)
        {
            if (self.currentKlineType >= 4 && self.currentKlineType<= 9) {
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = Y_StockChartcenterViewTypeKline;
                self.kLineView.targetLineStatus = self.targetLineStatus;
                self.kLineView.targetLineAccessoryViewStatus = self.targetLineAccessoryViewStatus;
                [self.kLineView reDraw];
            }
            
        } else {
            
            self.kLineView.kLineModels = (NSArray *)stockData;
            self.kLineView.MainViewType = type;
            if (self.currentKlineType == KLineTypeTimeLine) {
                self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
            }
            self.kLineView.targetLineStatus = self.targetLineStatus;
            self.kLineView.targetLineAccessoryViewStatus = self.targetLineAccessoryViewStatus;

            [self.kLineView reDraw];
        }
        [self bringSubviewToFront:self.segmentView];
    }
}

- (void)setMoreSelectedBtn:(UIButton *)moreSelectedBtn {
    [_moreSelectedBtn setSelected:NO];
    [moreSelectedBtn setSelected:YES];
    
    UIButton *btn = [self.segmentView viewWithTag:KLineTypeTimeMore];
    if (moreSelectedBtn.tag == KLineType1Min) {
        [btn setTitle:(CALanguages(@"1分")) forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == KLineType5Min) {
        [btn setTitle:(CALanguages(@"5分")) forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == KLineType30Min) {
        [btn setTitle:(CALanguages(@"30分")) forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == KLineType1Week) {
        [btn setTitle:(CALanguages(@"周线")) forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == KLineType1Month) {
        [btn setTitle:(CALanguages(@"1月")) forState:UIControlStateNormal];
    }
    _moreSelectedBtn = moreSelectedBtn;
    self.moreSegmentView.hidden = YES;
    self.isShowMoreSegmentView = NO;
}

- (void)setIndicatorSegmentSelectedBtnOne:(UIButton *)indicatorSegmentSelectedBtnOne {
    [_indicatorSegmentSelectedBtnOne setSelected:NO];
    [indicatorSegmentSelectedBtnOne setSelected:YES];
    _indicatorSegmentSelectedBtnOne = indicatorSegmentSelectedBtnOne;
}

- (void)setIndicatorSegmentSelectedBtnTwo:(UIButton *)indicatorSegmentSelectedBtnTwo {
    [_indicatorSegmentSelectedBtnTwo setSelected:NO];
    [indicatorSegmentSelectedBtnTwo setSelected:YES];
    _indicatorSegmentSelectedBtnTwo = indicatorSegmentSelectedBtnTwo;
}

#pragma mark  指标 action

-(void)CAIndicatorSegmentView_didSelectedStatus:(Y_StockChartTargetLineStatus)status{
    self.kLineView.targetLineStatus = status;
    self.targetLineStatus = status;
    [Y_StockChartGlobalVariable setisEMALine:self.targetLineStatus];
    if (self.currentKlineType == 0) {
        self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
    }
    [self.kLineView reDraw];
}
-(void)CAIndicatorSegmentView_didSelectedAccessoryStatus:(Y_StockChartTargetLineStatus)status{
    self.kLineView.targetLineAccessoryViewStatus = status;
    self.targetLineAccessoryViewStatus = status;
    [self.kLineView reDraw];
}

-(void)hideMoreViewAndIndicatorView{
    if (_moreSegmentView) {
        if (!_moreSegmentView.isHidden) {
            [_moreSegmentView setHidden:YES];
        }
    }
    if (_indicatorSegmentView) {
        if (!_indicatorSegmentView.isHidden) {
            [_indicatorSegmentView setHidden:YES];
        }
    }
}

#pragma mark 更多action

- (void)event_segmentButtonClicked:(UIButton *)btn {
    
     
     self.moreSelectedBtn = btn;
     Y_KLineType index = (Y_KLineType)btn.tag;
      
    //更多时间里的
    self.indicatorSegmentView.hidden = YES;
    self.isShowindicatorSegmentView = NO;
    UIButton *button = [self.segmentView viewWithTag:self.currentKlineType];
    button.selected = NO;
    
    if (self.isShowMoreSegmentView) {
        self.moreSegmentView.hidden = YES;
        self.isShowMoreSegmentView = NO;
    }
    else{
        self.moreSegmentView.hidden = NO;
        self.isShowMoreSegmentView = YES;
    }
    [self bringSubviewToFront:self.segmentView];
    
    self.currentKlineType = index;
    self.kLineView.lineKTime = self.currentKlineType;
    
    [self reloadDataWithTimeIndex:index];
}

- (void)fullScreenTargetClickWithIndex:(NSInteger)index
{
    self.kLineView.targetLineStatus = index;
    self.targetLineStatus = index;

    [Y_StockChartGlobalVariable setisEMALine:self.targetLineStatus];

    if (self.currentKlineType == KLineTypeTimeLine) {
        self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
    }
    [self.kLineView reDraw];
}

@end


/************************ItemModel类************************/
@implementation Y_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title klineType:(Y_KLineType)klineType type:(Y_StockChartCenterViewType)type
{
    Y_StockChartViewItemModel *itemModel = [Y_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    itemModel.klineType = klineType;
    return itemModel;
}

@end
