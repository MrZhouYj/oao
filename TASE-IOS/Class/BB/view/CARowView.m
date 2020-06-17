//
//  CARowView.m
//  TASE-IOS
//
//   9/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CARowView.h"

@interface CARowView()

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIButton * rowBtn;

@end

@implementation CARowView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self initSubViews];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChange)]];
        
    }
    return self;
}

-(void)didChange{
    
    
    if (self.delegata && [self.delegata respondsToSelector:@selector(CARowView_didChangeRowState:rowView:)]) {
        
        [self.rowBtn setSelected:!self.up];
        
        [self.delegata CARowView_didChangeRowState:!self.up rowView:self];
        
        self.up = !self.up;
    }
}

-(void)layoutSubviews{
    
    switch (self.layOut) {
        case CARowViewLayoutCenter:
        {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.centerX.equalTo(self);
                make.height.equalTo(@15);
                if (self.rowHidden) {
                    make.right.equalTo(self.label.mas_right);
                }else{
                    make.right.equalTo(self.rowBtn.mas_right);
                }
                
            }];
            
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.contentView.mas_height);
                make.left.equalTo(self.contentView);
            }];
            
            if (!self.rowHidden) {
                [self.rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.equalTo(self.label.mas_right).offset(5);
                       make.width.equalTo(@8);
                       make.height.equalTo(@6);
                       make.centerY.equalTo(self.label);
                   }];
            }
            
        }
            break;
        case CARowViewLayoutBetween:
        {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self);
                make.height.equalTo(self);
                if (self.rowHidden) {
                    make.right.equalTo(self.label.mas_right);
                }else{
                    make.right.equalTo(self.rowBtn.mas_right);
                }
                
            }];
            
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.contentView.mas_height);
                make.left.equalTo(self.contentView);
            }];
            
            if (!self.rowHidden) {
                [self.rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.equalTo(self.label.mas_right).offset(5);
                       make.width.equalTo(@8);
                       make.height.equalTo(@6);
                       make.centerY.equalTo(self.label);
                }];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.upTitle = placeHolder;
    self.downTitle = placeHolder;
    self.label.text = placeHolder;
    self.label.textColor = self.placeHolderColor;
    
    [self setNeedsLayout];
}

-(void)setLayOut:(CARowViewLayout)layOut{
    _layOut = layOut;
    [self setNeedsLayout];
}


-(void)initSubViews{
     self.contentView = [UIView new];
    [self addSubview:self.contentView];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    self.label.font = titleFont;
    [self setNeedsLayout];
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.label.textColor = titleColor;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    if (title) {
       
        self.upTitle = title;
        self.downTitle = title;
        self.label.textColor = [UIColor blackColor];
        self.up = self.up;
    }else{
        if (self.placeHolder) {
            self.placeHolder = self.placeHolder;
        }
    }
}

-(void)setBorderNormalColor:(UIColor *)borderNormalColor{
    
    _borderNormalColor = borderNormalColor;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderColor = borderNormalColor.CGColor;
    self.layer.borderWidth = 0.5;
    
}

-(void)setImageTineColor:(UIColor *)imageTineColor{
    _imageTineColor = imageTineColor;
    [self.rowBtn setTintColor:_imageTineColor];
}

-(UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        [self.contentView addSubview:_label];
    }
    return _label;
}

-(void)setUp:(BOOL)up{
    _up = up;
    [_rowBtn setSelected:up];
    if (_up) {
        
        self.label.text = self.downTitle;
        
        if (self.borderSelectColor) {
            self.layer.borderColor = self.borderSelectColor.CGColor;
        }
        if (self.selectColor) {
            self.label.textColor = self.selectColor;
        }
        
        if (self.backGroundSelectColor) {
            self.backgroundColor = self.backGroundSelectColor;
        }
       
        
    }else{
        
        self.label.text = self.upTitle;
        
        if (self.borderNormalColor) {
            self.layer.borderColor = self.borderNormalColor.CGColor;
        }
        if (self.selectColor) {
            self.label.textColor = [UIColor blackColor];
        }
        if (self.backGroundNormalColor) {
            self.backgroundColor = self.backGroundNormalColor;
        }
    }
    [self setNeedsLayout];
}

-(void)setRowHidden:(BOOL)rowHidden{
    _rowHidden = rowHidden;
    self.rowBtn.hidden = rowHidden;
}

-(UIButton *)rowBtn{
    if (!_rowBtn) {
        _rowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_rowBtn];
        [_rowBtn setImage:[IMAGE_NAMED(@"row_up") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_rowBtn setImage:[IMAGE_NAMED(@"row_down") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        _rowBtn.userInteractionEnabled = NO;
    }
    return _rowBtn;
}

@end
