//
//  CABBBottomTimeLineView.m
//  TASE-IOS
//
//   9/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBBottomTimeLineView.h"
#import "CARowView.h"

@interface CABBBottomTimeLineView()<CARowViewDelegata>
{
    UILabel * _leftTitleLabel;
}
@property (nonatomic, strong) Y_KLineView * KlineView;

@property (nonatomic, strong) CARowView * rowView;

@end

@implementation CABBBottomTimeLineView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];

        [self initKlineView];
        [self addLinesView];
        [self initTop];
        [self languageDidChange];
    }
    return self;
}

-(void)languageDidChange{
    self.rowView.upTitle = CALanguages(@"展开") ;
    self.rowView.downTitle = CALanguages(@"收起");
    self.rowView.up  = self.rowView.isUp;
    self.code = self.code;
}

-(void)initTop{
    
    UIView * view = [UIView new];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.KlineView.mas_top);
    }];
    
    _leftTitleLabel = [UILabel new];
    [view addSubview:_leftTitleLabel];
    _leftTitleLabel.font = FONT_MEDIUM_SIZE(14);
    _leftTitleLabel.dk_textColorPicker = DKColorPickerWithKey(RowNotiColor);
    [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
    }];
    
    
    
    self.rowView = [CARowView new];
    [view addSubview:self.rowView];
    self.rowView.delegata = self;
    
    [self.rowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view);
        make.width.equalTo(@65);
        make.height.equalTo(@25);
    }];

    
    self.rowView.layer.borderColor = HexRGB(0xc6c9d8).CGColor;
    self.rowView.layer.borderWidth  = 0.5;
    self.rowView.layer.masksToBounds = YES;
    self.rowView.layer.cornerRadius  = 2;
    
    self.rowView.titleFont = FONT_REGULAR_SIZE(12);
    self.rowView.imageTineColor = RGB(184, 188, 208);
    self.rowView.up = NO;
    
    self.rowView.label.dk_textColorPicker = DKColorPickerWithKey(RowNotiColor);
   
}

-(void)setCode:(NSString *)code{
    _code = code;
    
    _leftTitleLabel.text = NSStringFormat(@"%@ %@",code,CALanguages(@"分时图"));
}

-(void)CARowView_didChangeRowState:(int)state rowView:(nonnull CARowView *)rowView{
   
    if (state) {
        [self showWith:YES];
    }else{
        [self hideWith:YES];
    }
}

-(void)showWith:(BOOL)animated{
    CGRect rect = self.frame;
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, rect.origin.y-170, CGRectGetWidth(rect), CGRectGetHeight(rect));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.frame = CGRectMake(0, rect.origin.y-170, CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
}
-(void)hideWith:(BOOL)animated{
    CGRect rect = self.frame;
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, rect.origin.y+170, CGRectGetWidth(rect), CGRectGetHeight(rect));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.frame = CGRectMake(0, rect.origin.y+170, CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
}

- (void)addLinesView {
    CGFloat white = self.KlineView.bounds.size.height /4;
    CGFloat height = self.KlineView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 5;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i),self.KlineView.bounds.size.width , 0.5)];
        hengView.backgroundColor = [UIColor colorWithRGBHex:0xdadce5];
        [self.KlineView addSubview:hengView];
        [self.KlineView sendSubviewToBack:hengView];
    }
    //竖格
    for (int i = 0;i < 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 0, 0.5, self.KlineView.bounds.size.height-20)];
        shuView.backgroundColor = [UIColor colorWithRGBHex:0xdadce5];
        [self.KlineView addSubview:shuView];
        [self.KlineView sendSubviewToBack:shuView];
    }
}


-(void)initKlineView{
    
    self.KlineView = [[Y_KLineView alloc] initWithFrame:CGRectMake(0, self.height-170, MainWidth, 170)];
    [self addSubview:self.KlineView];
    self.KlineView.onlyShowTimeLineView = YES;
    self.KlineView.backgroundColor = [UIColor clearColor];
    self.KlineView.targetLineStatus = Y_StockChartTargetLineStatusAccessoryClose;
    self.KlineView.targetLineAccessoryViewStatus = Y_StockChartTargetLineStatusAccessoryClose;
    self.KlineView.lineKTime = 0;
    self.KlineView.isFullScreen = NO;
    self.KlineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
    
}

-(void)reDraw{
    _KlineView.kLineModels = self.groupModel.models;
    [_KlineView reDraw];
}

-(void)addKLineModel:(Y_KLineModel *)model{
    
    Y_KLineModel * lastModel  = self.klineDataArray.lastObject;
    if ([lastModel.Date longLongValue]!=[model.Date longLongValue]) {
      
//       if (self.klineDataArray.count==0) {
//           [model initFirstModel];
//       }else{
//           [model initData];
//       }
       [self.klineDataArray addObject:model];
    }else{
       
//        [model initData];
        [self.klineDataArray replaceObjectAtIndex:self.klineDataArray.count-1 withObject:lastModel];
    }
    
    _KlineView.kLineModels = self.klineDataArray;
    [_KlineView reDraw];
    
}

-(void)addKLineModels:(NSArray<Y_KLineModel *> *)models{
//    if (models.count) {
//        Y_KLineModel * lastModel  = self.klineDataArray.firstObject;
//        [lastModel initFirstModel];
//        for (Y_KLineModel * model in models) {
//            [self.klineDataArray addObject:model];
//            [model initData];
//        }
//    }
    if (models.count) {
        [self.klineDataArray addObjectsFromArray:models];
        _KlineView.kLineModels = self.klineDataArray;
        [_KlineView reDraw];
    }
   
}

-(void)setGroupModel:(Y_KLineGroupModel *)groupModel{
    _groupModel = groupModel;
    
    _KlineView.kLineModels = _groupModel.models;
    [_KlineView reDraw];
}

-(NSMutableArray*)klineDataArray{
    if (!_klineDataArray) {
        _klineDataArray = @[].mutableCopy;
    }
    return _klineDataArray;
}

@end
