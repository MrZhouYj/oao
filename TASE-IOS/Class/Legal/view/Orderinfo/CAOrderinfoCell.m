//
//  CAOrderinfoCell.m
//  TASE-IOS
//
//  Created by ZEMac on 2020/2/4.
//  Copyright © 2020 CA. All rights reserved.
//

#import "CAOrderinfoCell.h"

@interface CAOrderinfoCell()

@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UIImageView * rightRowImageView;

@property (nonatomic, strong) UILabel * rightContentLabel;

@property (nonatomic, strong) UIImageView * rightContentImageView;

@property (nonatomic, strong) UIImageView * copYImageView;

@end

@implementation CAOrderinfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        UIView * lineView = [UIView new];
        [self.contentView addSubview:lineView];
        lineView.dk_backgroundColorPicker = DKColorPickerWithKey(LineColor);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyClick)]];
    }
    return self;
}

-(void)copyClick{
    if (self.enableCopy) {
        [CommonMethod copyString:self.rightContentText];
    }else{
        if (self.block) {
            self.block();
        }
    }
}

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        [self.contentView addSubview:_leftLabel];
        _leftLabel.font = FONT_MEDIUM_SIZE(13);
        _leftLabel.textColor = HexRGB(0xa3a5be);
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.contentView).offset(15);
              make.centerY.equalTo(self.contentView);
              make.width.lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.5);
          }];
    }
    return _leftLabel;
}

-(UILabel *)rightContentLabel{
    if (!_rightContentLabel) {
        _rightContentLabel = [UILabel new];
        [self.contentView addSubview:_rightContentLabel];
        _rightContentLabel.font = FONT_MEDIUM_SIZE(13);
        _rightContentLabel.textColor = HexRGB(0x191d26);
        _rightContentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightContentLabel;
}

-(UIImageView *)rightRowImageView{
    if (!_rightRowImageView) {
        _rightRowImageView = [UIImageView new];
        [self.contentView addSubview:_rightRowImageView];
        _rightRowImageView.image = IMAGE_NAMED(@"arrowright");
        _rightRowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _rightRowImageView;
}

-(UIImageView *)copYImageView{
    if (!_copYImageView) {
        _copYImageView = [UIImageView new];
        [self.contentView addSubview:_copYImageView];
        _copYImageView.image = IMAGE_NAMED(@"copyIcon");
        _copYImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _copYImageView;
}

-(UIImageView *)rightContentImageView{
    if (!_rightContentImageView) {
        _rightContentImageView = [UIImageView new];
        [self.contentView addSubview:_rightContentImageView];
        _rightContentImageView.contentMode = UIViewContentModeScaleAspectFit;
            
        }
    return _rightContentImageView;
}

-(void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    self.leftLabel.text = CALanguages(leftTitle);
    [self layoutIfNeeded];
}
-(void)setRightContentText:(NSString *)rightContentText{
    _rightContentText = rightContentText;
    
    if (rightContentText) {
        if (_rightContentImage) {
            self.rightContentImage = nil;
        }
    }

    self.rightContentLabel.text = rightContentText;
    
    [self setNeedsLayout];
}

-(void)setEnableCopy:(BOOL)enableCopy{
    _enableCopy = enableCopy;
    self.copYImageView.hidden = !enableCopy;
    [self layoutIfNeeded];
}

-(void)setShowArrow:(BOOL)showArrow{
    _showArrow = showArrow;
    self.rightRowImageView.hidden = !showArrow;
    [self layoutIfNeeded];
}

-(void)setRightContentImage:(UIImage *)rightContentImage{
    _rightContentImage = rightContentImage;
    
    if (rightContentImage!=nil) {

        self.rightContentText = nil;
    }
    self.rightContentImageView.image = rightContentImage;
    
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
   
    if (self.showArrow) {
        [_rightRowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@10);
            make.height.equalTo(@12);
        }];
    }
    
    if (_rightContentImage) {

        [self.rightContentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
           if (self.showArrow) {
              make.right.equalTo(self.rightRowImageView.mas_left).offset(-10);
           }else{
               make.right.equalTo(self.contentView).offset(-15);
           }
            make.height.equalTo(@24);
            make.width.equalTo(@24);
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    

    if (_rightContentText) {
        
        if (self.enableCopy) {
            [self.copYImageView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.height.equalTo(@13);
               make.width.equalTo(@13);
               make.centerY.equalTo(self.contentView);
               make.right.equalTo(self.contentView).offset(-15);
            }];
        }
        
        [self.rightContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.showArrow) {
               make.right.equalTo(self.rightRowImageView.mas_left).offset(-5);
            }else if (self.enableCopy){
                make.right.equalTo(self.copYImageView.mas_left).offset(-5);
            }else{
               make.right.equalTo(self.contentView).offset(-15);
            }
            make.width.equalTo(self.contentView).multipliedBy(0.5);
            make.centerY.equalTo(self.contentView);
        }];
    }
}

@end
