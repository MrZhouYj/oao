//
//  CAIndicatorSegmentView.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/11.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAIndicatorSegmentView.h"

@interface CAIndicatorSegmentView()

@property (nonatomic, strong, nullable) UIButton * mainEyeButton;
@property (nonatomic, strong, nullable) UIButton * subEyeButton;

@property (nonatomic, strong, nullable) UIButton * mainSelButton;
@property (nonatomic, strong, nullable) UIButton * subSelButton;

@property (nonatomic, strong) NSArray * mainArray;
@property (nonatomic, strong) NSArray * subArray;


@end

@implementation CAIndicatorSegmentView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
        
      
        self.mainArray = @[@{@"text":@"MA",
                                  @"status":@(Y_StockChartTargetLineStatusMA)},
                              @{@"text":@"BOLL",
                                @"status":@(Y_StockChartTargetLineStatusBOLL)}];
        
        self.subArray = @[@{@"text":@"MACD",
                                 @"status":@(Y_StockChartTargetLineStatusMACD)},
                               @{@"text":@"KDJ",
                               @"status":@(Y_StockChartTargetLineStatusKDJ)},
                               @{@"text":@"RSI",
                                 @"status":@(Y_StockChartTargetLineStatusRSI)},
                               @{@"text":@"WR",
                               @"status":@(Y_StockChartTargetLineStatusWR)}
        ];
        
        
        
    }
    return self;
}

-(void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen =  isFullScreen;
    if (!_isFullScreen) {
        
        UIView * mainView = [self creatSubViews:(CALanguages(@"主图") ) itemsArray:self.mainArray topView:nil];
        UIView * subView  = [self creatSubViews:(CALanguages(@"副图")) itemsArray:self.subArray topView:mainView];

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(subView.mas_bottom);
        }];
        
    }else{
        UIView * mainView = [self creatFullSubViews:(CALanguages(@"主图")) itemsArray:self.mainArray topView:nil];
        
        UIView * lineView = [UIView new];
        [self addSubview:lineView];
        lineView.dk_backgroundColorPicker =  DKColorPickerWithKey(LineColor);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(mainView.mas_bottom);
        }];
        
        
        [self creatFullSubViews:(CALanguages(@"副图")) itemsArray:self.subArray topView:lineView];
        
        UIView * lineLeftView = [UIView new];
        [self addSubview:lineLeftView];
        lineLeftView.dk_backgroundColorPicker =  DKColorPickerWithKey(LineColor);
        [lineLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(@1);
        }];
    }
    
}

-(UIView*)creatFullSubViews:(NSString*)title itemsArray:(NSArray*)itemsArray topView:(UIView*)topView{
    
    UILabel * titleLabel = UILabel.new;
    [self addSubview:titleLabel];
    titleLabel.text = (title);
    titleLabel.textColor = RGB(190, 190, 207);
    titleLabel.font = FONT_REGULAR_SIZE(13);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView?topView:self);
        make.left.right.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.1);
    }];
           
    //创建选项Buttons
    UIView * lastBtn = titleLabel;
    for (int i=0; i<itemsArray.count; i++) {
        UIButton * button = [self creatTextButton:itemsArray[i]];
        [self addSubview:button];
        button.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastBtn.mas_bottom);
            make.height.equalTo(self).multipliedBy(0.1);
            make.left.right.equalTo(self);
        }];
        lastBtn = button;
        if (i==0) {
            [button setSelected:YES];
            //默认选中第一个
            if (topView) {
                self.subSelButton = button;
            }else{
                self.mainSelButton = button;
            }
        }
    }
    
     UIButton * eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [eyeBtn setImage:IMAGE_NAMED(@"chart_eye_close") forState:UIControlStateNormal];
     [eyeBtn setImage:IMAGE_NAMED(@"chart_eye_open") forState:UIControlStateSelected];
     [self addSubview:eyeBtn];
     [eyeBtn setSelected:YES];
     eyeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
     eyeBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
     eyeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
     [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.equalTo(self);
         make.height.equalTo(self).multipliedBy(0.1);
         make.top.equalTo(lastBtn.mas_bottom);
     }];
     [eyeBtn addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
     if (topView) {
         self.subEyeButton = eyeBtn;
     }else{
         self.mainEyeButton = eyeBtn;
     }
    
    return eyeBtn;
}

-(UIView*)creatSubViews:(NSString*)title itemsArray:(NSArray*)itemsArray topView:(UIView*)topView{
    
    UIView * view = [UIView new];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(topView?topView.mas_bottom:self);
        make.height.equalTo(@40);
    }];
    {
        UILabel * titleLabel = UILabel.new;
        [view addSubview:titleLabel];
        titleLabel.text = (title);
        titleLabel.textColor = RGB(190, 190, 207);
        titleLabel.font = FONT_REGULAR_SIZE(13);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
        }];
    }
    
    {
        //创建选项Buttons
        UIView * lastBtn = [self lineView:view];
        for (int i=0; i<itemsArray.count; i++) {
            UIButton * button = [self creatTextButton:itemsArray[i]];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.mas_right).offset(10);
                make.width.equalTo(view).multipliedBy(0.15);
                make.centerY.equalTo(lastBtn);
            }];
            lastBtn = button;
            if (i==0) {
                [button setSelected:YES];
                //默认选中第一个
                if (topView) {
                    self.subSelButton = button;
                }else{
                    self.mainSelButton = button;
                }
            }
        }
    }
    
    {
        UIButton * eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [eyeBtn setImage:IMAGE_NAMED(@"chart_eye_close") forState:UIControlStateNormal];
        [eyeBtn setImage:IMAGE_NAMED(@"chart_eye_open") forState:UIControlStateSelected];
        [view addSubview:eyeBtn];
        [eyeBtn setSelected:YES];
        [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(view);
        }];
        [eyeBtn addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       
        if (topView) {
            self.subEyeButton = eyeBtn;
        }else{
            self.mainEyeButton = eyeBtn;
        }
    }
    
    
    return view;
}

#pragma mark 眼睛点击事件
-(void)eyeButtonClick:(UIButton*)button{
    if (button.isSelected) {
        if (button==self.mainEyeButton) {
            self.mainSelButton = nil;
            if (self.delegata&&[self.delegata respondsToSelector:@selector(CAIndicatorSegmentView_didSelectedStatus:)]) {
                [self.delegata CAIndicatorSegmentView_didSelectedStatus:Y_StockChartTargetLineStatusCloseMA];
            }
        }else{
            self.subSelButton = nil;
            if (self.delegata&&[self.delegata respondsToSelector:@selector(CAIndicatorSegmentView_didSelectedAccessoryStatus:)]) {
                [self.delegata CAIndicatorSegmentView_didSelectedAccessoryStatus:Y_StockChartTargetLineStatusAccessoryClose];
            }
        }
    }
}
-(void)setMainSelButton:(UIButton *)mainSelButton{

    if (mainSelButton) {
        [self.mainEyeButton setSelected:YES];
    }else{
        [self.mainSelButton setSelected:NO];
        [self.mainEyeButton setSelected:NO];
    }
    _mainSelButton = mainSelButton;
}
-(void)setSubSelButton:(UIButton *)subSelButton{

    if (subSelButton) {
        [self.subEyeButton setSelected:YES];
    }else{
        [self.subSelButton setSelected:NO];
        [self.subEyeButton setSelected:NO];
    }
    _subSelButton = subSelButton;
}
-(void)item_click:(UIButton*)button{
 
    if (button.isSelected) {
        return;
    }
    
    [button setSelected:YES];
    
    if (button.tag==Y_StockChartTargetLineStatusMA||button.tag==Y_StockChartTargetLineStatusBOLL) {
        //点击的主图
        if (self.mainSelButton) {
            [self.mainSelButton setSelected:NO];
        }
        self.mainSelButton = button;
        
        if (self.delegata&&[self.delegata respondsToSelector:@selector(CAIndicatorSegmentView_didSelectedStatus:)]) {
            [self.delegata CAIndicatorSegmentView_didSelectedStatus:button.tag];
        }
        
    }else{
    
        if (self.subSelButton) {
              [self.subSelButton setSelected:NO];
          }
        self.subSelButton = button;
        
        if (self.delegata&&[self.delegata respondsToSelector:@selector(CAIndicatorSegmentView_didSelectedAccessoryStatus:)]) {
            [self.delegata CAIndicatorSegmentView_didSelectedAccessoryStatus:button.tag];
        }
    }
}
#pragma mark 快速创建
-(UIButton*)creatTextButton:(NSDictionary*)item{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:RGB(145, 146, 177) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(25, 29, 38) forState:UIControlStateSelected];
    
    if (_isFullScreen) {
        btn.titleLabel.font = FONT_SEMOBOLD_SIZE(12);
    }else{
        btn.titleLabel.font = FONT_SEMOBOLD_SIZE(14);
    }
    [btn setTitle:item[@"text"] forState:UIControlStateNormal];
    btn.tag = [item[@"status"] integerValue];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(item_click:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(UIView*)lineView:(UIView*)supView{
    UIView * view = [UIView new];
    view.backgroundColor = RGB(190, 190, 207);
    [supView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(supView).offset(50);
        make.centerY.equalTo(supView);
        make.width.mas_equalTo(1);
        make.height.equalTo(supView).multipliedBy(0.4);
    }];
    
    return view;
}
@end
