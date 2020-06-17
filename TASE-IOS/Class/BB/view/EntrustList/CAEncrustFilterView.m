//
//  CAEncrustFilterView.m
//  TASE-IOS
//
//   10/21.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEncrustFilterView.h"
#import "CARowView.h"

@interface CAEncrustFilterView()
<CARowViewDelegata,
UITextFieldDelegate>
{
    CARowView * _unitLastView;
    CARowView * _stateLastView;
}

@property (nonatomic, strong) NSArray * unitArray;

@property (nonatomic, strong) UILabel * stateLabel;

@property (nonatomic, strong) UITextField * currencyTf;

@property (nonatomic, strong) CARowView * rowView;

@property (nonatomic, strong) UIView * unitContentView;

@property (nonatomic, strong) UIView * orderStateContentView;

@end

@implementation CAEncrustFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addLineView];
        [self initPairSubViews];
        [self initOrderStateSubViews];
        [self initBottomButton];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
}

-(void)addLineView{
    
    UIView * lineView = [UIView new];
    [self addSubview:lineView];
    
    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self);
    }];
}

-(void)initBottomButton{
    
   
    
    UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:resetButton];
    [resetButton setTitle:CALanguages(@"重置") forState:UIControlStateNormal];
    resetButton.titleLabel.font = FONT_REGULAR_SIZE(13);
    [resetButton setTitleColor:HexRGB(0x9a9fa3) forState:UIControlStateNormal];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.orderStateContentView.mas_bottom).offset(20);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(@42);
    }];
    
    
    
    
    UIButton * okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okButton];
    [okButton setTitle:CALanguages(@"确定") forState:UIControlStateNormal];
    okButton.titleLabel.font = FONT_REGULAR_SIZE(13);
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     okButton.backgroundColor = HexRGB(0x0a6cdb);
    [resetButton addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(resetButton.mas_top);
        make.width.equalTo(resetButton);
        make.height.equalTo(resetButton.mas_height);
    }];
    
    
    
    
   UIView * lineView = [UIView new];
   [self addSubview:lineView];
   lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
   [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self);
       make.height.equalTo(@0.5);
       make.bottom.equalTo(resetButton.mas_top);
   }];
    
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(okButton.mas_bottom);
    }];
    
}

-(void)resetClick{
    
    [_stateLastView setUp:NO];
    [_unitLastView setUp:NO];
    self.rowView.title = nil;
}

-(void)initPairSubViews{
    
    
    UILabel * pairsNotilabel = [self titleLabel:CALanguages(@"交易对")];
    [pairsNotilabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(20);
    }];
    
    UIView *currencyContentView = [UIView new];
    [self addSubview:currencyContentView];
    
    UILabel * signlabel = [UILabel new];
    [self addSubview:signlabel];
    
    signlabel.text = @"/";
    signlabel.font =   FONT_SEMOBOLD_SIZE(15);
    [signlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);
    }];
    
    currencyContentView.layer.masksToBounds = YES;
    currencyContentView.layer.cornerRadius = 2;
    currencyContentView.layer.borderColor = HexRGB(0xeaeaea).CGColor;
    currencyContentView.layer.borderWidth = 0.5;
    [currencyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(pairsNotilabel.mas_bottom).offset(15);
        make.height.equalTo(@35);
        make.right.equalTo(signlabel.mas_left).offset(-10);
    }];
    
    [signlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(currencyContentView);
    }];
    
    [currencyContentView addSubview:self.currencyTf];
    [self.currencyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(currencyContentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    
    
    [self.rowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(signlabel.mas_right).offset(10);
        make.centerY.equalTo(currencyContentView);
        make.height.equalTo(currencyContentView);
    }];
    
    
    
    [self.unitContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.rowView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.unitContentView.hidden = YES;
    
    [self addSubViews:self.unitArray to:self.unitContentView baseTag:500];
}


-(void)initOrderStateSubViews{
    
     UILabel * stateLabel = [self titleLabel:CALanguages(@"订单状态")];
     self.stateLabel = stateLabel;
     [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self).offset(15);
         make.top.equalTo(self.rowView.mas_bottom).offset(20);
     }];
    
     
    [self.orderStateContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(stateLabel.mas_bottom).offset(15);
    }];
}

-(void)setIsHistory:(BOOL)isHistory{
    _isHistory = isHistory;
    
    NSArray * array = @[];
    if (isHistory) {
          array = @[CALanguages(@"已成交"),CALanguages(@"已撤销")];
    }else{
          array = @[CALanguages(@"买入"),CALanguages(@"卖出")];
    }
    [self addSubViews:array to:self.orderStateContentView baseTag:800];
    
}

-(void)addSubViews:(NSArray*)array to:(UIView*)spView baseTag:(NSInteger)baseTag{
    
    [spView removeAllSubViews];

    for (int i=0; i<array.count; i++) {
        CARowView * row = [CARowView new];
        [spView addSubview:row];
        row.title = array[i];
        row.rowHidden = YES;
        row.delegata = self;
        row.borderNormalColor = HexRGB(0xeaeaea);
        row.borderSelectColor = HexRGB(0x0a6cdb);
        row.titleFont = FONT_MEDIUM_SIZE(12);
        row.selectColor = HexRGB(0x0a6cdb);
        row.backGroundSelectColor = [UIColor whiteColor];
        row.backGroundNormalColor = HexRGB(0xf7f6fb);
        row.up = NO;
        row.tag = baseTag+i;

    }
    
    [spView.subviews mas_distributeViewsWithItemHeight:30 wrapLineCount:3 lineSpace:10 itemSpace:10 superView:spView];
}

-(UIView *)orderStateContentView{
    if (!_orderStateContentView) {
        _orderStateContentView = [UIView new];
        [self addSubview:_orderStateContentView];
        _orderStateContentView.backgroundColor = [UIColor whiteColor];
    }
    return _orderStateContentView;
}

-(void)showUnitContentView:(BOOL)isShow{
 
    if (isShow) {
        self.unitContentView.hidden = NO;
        [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.unitContentView.mas_bottom).offset(20);
            make.left.equalTo(self).offset(15);
        }];
    }else{
        self.unitContentView.hidden = YES;
        [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rowView.mas_bottom).offset(20);
            make.left.equalTo(self).offset(15);
        }];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.rowView.isUp) {
        
        [self.rowView setUp:NO];
        [self showUnitContentView:NO];
        
    }
    
    return YES;
}

-(void)CARowView_didChangeRowState:(int)state rowView:(nonnull CARowView *)rowView{
  
    if (self.currencyTf.isFirstResponder) {
        [self.currencyTf resignFirstResponder];
    }
    
    if (rowView.tag==1000) {
      
        [self showUnitContentView:!rowView.isUp];
        
    }else if (rowView.tag>=500&&rowView.tag<600){
       
        if (_unitLastView&&_unitLastView!=rowView) {
            [_unitLastView setUp:NO];
        }
        _unitLastView = rowView;
       
        if (state) {
           self.rowView.title = [self.unitArray objectAtIndex:_unitLastView.tag-500];
        }else{
            self.rowView.title = nil;
        }
                
    }else if (rowView.tag>=800&&rowView.tag<890){
        if (_stateLastView&&_stateLastView!=rowView) {
            [_stateLastView setUp:NO];
        }
        _stateLastView = rowView;
   
    }
}

-(UIView *)unitContentView{
    if (!_unitContentView) {
        _unitContentView = [UIView new];
        [self addSubview:_unitContentView];
    }
    return _unitContentView;
}

-(UITextField *)currencyTf{
    if (!_currencyTf) {
        UITextField *currencyTf = [UITextField new];
        currencyTf.placeholder = CALanguages(@"币种");
        currencyTf.font = FONT_REGULAR_SIZE(13);
        _currencyTf = currencyTf;
        _currencyTf.delegate = self;
    }
    return _currencyTf;
}

-(CARowView *)rowView{
    if (!_rowView) {
        CARowView * row = [CARowView new];
        [self addSubview:row];
        _rowView = row;
        row.layOut = CARowViewLayoutBetween;
        row.placeHolderColor = HexRGB(0xeaeaea);
        row.placeHolder = CALanguages(@"请选择计价单位");
        row.delegata = self;
        row.borderNormalColor = HexRGB(0xeaeaea);
        row.borderSelectColor = HexRGB(0x0a6cdb);
        row.titleFont = FONT_MEDIUM_SIZE(13);
        row.up = NO;
        row.tag = 1000;
    }
    return _rowView;
}

-(UILabel *)titleLabel:(NSString*)title{
    
    UILabel * label = [UILabel new];
    [self addSubview:label];
    
    label.text = title;
    label.font = FONT_SEMOBOLD_SIZE(15);
    label.backgroundColor = [UIColor whiteColor];
    
    return label;
}

-(NSArray *)unitArray{
    return @[@"USDT",@"HUSD",@"BTC",@"ETH",@"HT",@"TRX"];
}


@end
