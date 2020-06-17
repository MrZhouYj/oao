//
//  CAButton.m
//  TASE-IOS
//
//   10/15.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAButton.h"

@interface CAButton()

@property (nonatomic, strong) UIView * redDotView;

@end

@implementation CAButton

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIView *)redDotView{
    if (!_redDotView) {
        _redDotView = [UIView new];
        [self addSubview:_redDotView];
        _redDotView.backgroundColor = [UIColor redColor];
        _redDotView.layer.masksToBounds = YES;
        _redDotView.layer.cornerRadius = 3;
        _redDotView.hidden = YES;
    }
    return _redDotView;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)setIsShowRedDot:(BOOL)isShowRedDot{
    _isShowRedDot = isShowRedDot;
    if (_redDotView) {
        _redDotView.hidden = !isShowRedDot;
    }
}

-(void)layoutWithImageSize:(CGSize)size space:(CGFloat)space style:(CAButtonStyle)style{
    
    
   switch (style) {
       case CAButtonStyleTop:
       {
           [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.centerX.equalTo(self);
               make.top.equalTo(self);
               if (size.width) {
                   make.size.mas_equalTo(size);
               }else{
                   make.height.width.equalTo(self.mas_width);
               }
               
           }];
           [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.right.equalTo(self);
               make.top.equalTo(self.imageView.mas_bottom).offset(space);
           }];
           self.titleLabel.textAlignment = NSTextAlignmentCenter;
           
           [self.redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.right.equalTo(self.imageView.mas_right).offset(-2);
               make.top.equalTo(self.imageView.mas_top).offset(-2);
               make.width.height.equalTo(@6);
           }];
       }
          break;
       case CAButtonStyleBottom:
           {
               
           }
               break;
         case CAButtonStyleLeft:
         {
             [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self);
                 make.centerY.equalTo(self);
                 make.size.mas_equalTo(size);
             }];
             [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.imageView.mas_right).offset(space);
                 make.centerY.equalTo(self.imageView);
             }];
             
             [self mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.right.equalTo(self.titleLabel.mas_right);
             }];
           
         }
             break;
             
         case CAButtonStyleRight:
         {
             
         }
             break;
       default:
           break;
   }
}


@end
