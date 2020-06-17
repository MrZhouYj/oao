//
//  CAHomeSegmentView.m
//  TASE-IOS
//
//   9/16.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAHomeSegmentView.h"
static NSInteger const baseTag = 2100;
@interface CAHomeSegmentView()
{
    UIImageView * _btmLineView;
    UIButton * _selBtn;
    UIView *_topView;
    UIView *_lineView;
    
    UILabel * _leftLabel;
    UILabel * _rightLabel;
    UILabel * _centerLabel;
    
    UIView * _titleView;
}
@property (nonatomic, strong) NSArray * segmentArray;

@end

@implementation CAHomeSegmentView

@synthesize symbol = _symbol;


-(instancetype)init{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];

        [self initSubviews];
        
    }
    return self;
}

-(void)languageDidChange{
    [self initTopView];
    self.curType = self.curType;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initSubviews{
    
    UIView *topView = [UIView new];
    _topView = topView;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    
    UIView * lineView = [UIView new];
    [self addSubview:lineView];
    _lineView = lineView;
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    _btmLineView = [UIImageView new];
    [self addSubview:_btmLineView];
    _btmLineView.contentMode = UIViewContentModeScaleAspectFit;
    _btmLineView.image = [IMAGE_NAMED(@"Horizontalline") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIView * titleView = [UIView new];
    _titleView = titleView;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(30));
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    [self initTopView];
    
    
    __block UIButton * b = _selBtn;
    [_btmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(b);
        make.centerY.equalTo(lineView);
        make.height.equalTo(@2);
    }];
    
    _leftLabel = [self creatLabel];
    _centerLabel = [self creatLabel];
    _rightLabel = [self creatLabel];
    [titleView addSubview:_leftLabel];
    [titleView addSubview:_centerLabel];
    [titleView addSubview:_rightLabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(15);
        make.centerY.equalTo(titleView);
        
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView);
        
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView).offset(-15);
        make.centerY.equalTo(titleView);
        
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    self.curType = CAHomeSegmentIncreaseList;
}

-(void)initTopView{
    
    [_topView removeAllSubViews];
    NSMutableArray * mutArr = @[].mutableCopy;
    for (int i=0; i<self.segmentArray.count; i++) {
        UIButton * btn = [self creatButton:self.segmentArray[i] tag:i+baseTag];
        [_topView addSubview:btn];
        [mutArr addObject:btn];
        if (i==0) {
            [btn setSelected:YES];
            _selBtn = btn;
        }
    }
    
    [mutArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [mutArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView);
    }];
}

-(void)setSymbol:(NSString *)symbol{
    _symbol = symbol;
}

-(NSString *)symbol{
    if (_symbol.length) {
        return _symbol;
    }
    return @"";
}

-(void)setCurType:(CAHomeSegmentType)curType{
    
    switch (curType) {
        case CAHomeSegmentIncreaseList:
            _leftLabel.text = CALanguages(@"名称");
            _centerLabel.text = CALanguages(@"最新价");
            _rightLabel.text = CALanguages(@"涨跌幅");
            break;
        case CAHomeSegmentTurnoverList:
            _leftLabel.text = CALanguages(@"名称");
            _centerLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"最新价"),self.symbol);
            _rightLabel.text = NSStringFormat(@"%@(%@)",CALanguages(@"24小时成交额"),self.symbol);
        break;
            
        default:
            break;
    }
    
    _curType = curType;
    UIButton * btn = (UIButton*)[_topView viewWithTag:curType+baseTag];
    if (btn==_selBtn) {
        return;
    }
    [btn setSelected:YES];
    [_selBtn setSelected:NO];
    _selBtn = btn;
    __block UIButton * b = _selBtn;
    __block UIView * l = _lineView;
    [_btmLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(b);
        make.centerY.equalTo(l);
        make.height.equalTo(@2);
    }];
    
    
}

-(void)btnClick:(UIButton*)btn{
    
    if (btn==_selBtn) {
        return;
    }
    NSInteger tag = btn.tag - baseTag;
    self.curType = (CAHomeSegmentType)tag;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CAHomeSegmentViewDidSelectedIndex:)]) {
        [self.delegate CAHomeSegmentViewDidSelectedIndex:tag];
    }
}

-(UILabel*)creatLabel{
    
    UILabel * label = [UILabel new];
    label.font = FONT_REGULAR_SIZE(12);
    label.textColor = RGB(149, 156, 190);
    
    return label;
}

-(UIButton*)creatButton:(NSString*)title tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = FONT_MEDIUM_SIZE(15);
    [button setTitleColor:HexRGB(0x006cdb) forState:UIControlStateSelected];
    [button setTitleColor:HexRGB(0x858bb5) forState:UIControlStateNormal];
    [button setTitle:CALanguages(title) forState:UIControlStateNormal];
    button.tag = tag;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(NSArray *)segmentArray{
    
    _segmentArray = @[@"涨幅榜" ,@"成交额榜"];
    
    return _segmentArray;
}

@end
