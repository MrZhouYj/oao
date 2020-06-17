//
//  CAActionSheetView.m
//  TASE-IOS
//
//   10/22.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAActionSheetView.h"

@interface CAActionCell()

@property (nonatomic, strong) UILabel * label;

@end

@implementation CAActionCell

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.label];
        
        UIView * lineView = [UIView new];
        [self addSubview:lineView];
        
        lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setText:(NSString *)text{
    _text = text;
    self.label.text = text;
}

-(void)setIsHightLight:(BOOL)isHightLight{
    _isHightLight = isHightLight;
    if (isHightLight) {
        self.label.textColor = HexRGB(0x0a6cdb);
    }else{
        self.label.textColor = [UIColor blackColor];
    }
}

-(UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FONT_SEMOBOLD_SIZE(14);
        
    }
    return _label;
}

@end

@interface CAActionSheetView()

@property (nonatomic, copy) void (^block)(NSInteger);

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, assign) NSInteger selIndex;

@end

@implementation CAActionSheetView

+(instancetype)showActionSheet:(NSArray *)data selectIndex:(NSInteger)index click:(void (^)(NSInteger))block{
    
    CGFloat height = data.count*49+49+5;
    
    CAActionSheetView * actionSheetView = [[CAActionSheetView alloc] initWithFrame:CGRectMake(0, MainHeight-height, MainWidth, height)];
    
    actionSheetView.block = block;
    actionSheetView.dataArray = data;
    actionSheetView.selIndex = index;
    [actionSheetView CornerTop];
    [actionSheetView initSubViews];
    
    [actionSheetView showInView:[[UIApplication sharedApplication] keyWindow] isAnimation:YES direaction:CABaseAnimationDirectionFromBottom];
    
    
    return actionSheetView;
}


-(void)initSubViews{
    
    
    CAActionCell * topCell = nil;
    
       for (int i=0; i<self.dataArray.count; i++) {
           CAActionCell * cell = [CAActionCell new];
           [self addSubview:cell];
           cell.isHightLight = i==self.selIndex;
           cell.text = self.dataArray[i];
           [cell mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.right.equalTo(self);
               if (topCell) {
                   make.top.equalTo(topCell.mas_bottom);
               }else{
                   make.top.equalTo(self);
               }
               make.height.equalTo(@49);
           }];
           topCell = cell;
           cell.tag = 1000+i;
           [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)]];
       }
    
    UIView * lineView = [UIView new];
    [self addSubview:lineView];

    lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@5);
        make.top.equalTo(topCell.mas_bottom);
    }];

    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancleButton];
    [cancleButton setTitle:CALanguages(@"取消")  forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    cancleButton.titleLabel.font = FONT_SEMOBOLD_SIZE(14);
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@49);
    }];
    
    
    [cancleButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)hideSelf{
    [self hide:YES];
}

-(void)cellClick:(UITapGestureRecognizer*)tap{
    NSInteger index = [[tap view] tag]-1000;
    
    [self hide:YES];
    
    if (index==self.selIndex) {
        
        return;
    }
    if (self.block) {
        self.block(index);
    }
    
}

@end
