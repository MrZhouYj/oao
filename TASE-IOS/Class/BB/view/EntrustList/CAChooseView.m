//
//  CAChooseView.m
//  TASE-IOS
//
//   10/21.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChooseView.h"

@interface CAChooseView()

@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UILabel * rightLabel;

@end

@implementation CAChooseView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        
        [self setSelectedAttribute:self.leftLabel];
        [self setDefaultAttribute:self.rightLabel];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(@20);
      
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(25);
            make.bottom.equalTo(self.leftLabel.mas_bottom);
        }];
        
        UIView * lineView = [UIView new];
        [self addSubview:lineView];
        lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self.mas_bottom);
        }];
     
        if (self.delegata&&[self.delegata respondsToSelector:@selector(CAChooseView_didSelectIndex:)]) {
            [self.delegata CAChooseView_didSelectIndex:0];
        }
        
    }
    return self;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    [self didChooseIndex:currentIndex];
}

-(void)didChooseIndex:(NSInteger)index{
    
    if (index==0) {
  
        [UIView animateWithDuration:0.25 animations:^{
            
            [self setDefaultAttribute:self.rightLabel];
            [self setSelectedAttribute:self.leftLabel];
         
        } completion:^(BOOL finished) {
            
        }];
    }else if (index==1){
        [UIView animateWithDuration:0.25 animations:^{
            
            [self setDefaultAttribute:self.leftLabel];
            [self setSelectedAttribute:self.rightLabel];
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        NSLog(@"无效的index");
    }
    if (self.delegata&&[self.delegata respondsToSelector:@selector(CAChooseView_didSelectIndex:)]) {
        [self.delegata CAChooseView_didSelectIndex:index];
    }
    
}

-(void)setDefaultAttribute:(UILabel*)label{
    
    label.font = FONT_REGULAR_SIZE(15);
    label.dk_textColorPicker = DKColorPickerWithKey(NormalgrayColor_c5c9db);
}

-(void)setSelectedAttribute:(UILabel*)label{
    label.font = FONT_SEMOBOLD_SIZE(22);
    label.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
}

-(void)leftClick{
    
    [self didChooseIndex:0];
}

-(void)rightClick{
    
    [self didChooseIndex:1];
}

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.text = CALanguages(@"全部委托");
        _leftLabel.userInteractionEnabled = YES;
        [_leftLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClick)]];
    }
    return _leftLabel;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [self addSubview:_rightLabel];
        _rightLabel.text = CALanguages(@"历史记录");
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick)]];
    }
    return _rightLabel;
}

@end
