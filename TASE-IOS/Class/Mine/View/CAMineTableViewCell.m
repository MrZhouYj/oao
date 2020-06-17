//
//  CAMineTableViewCell.m
//  TASE-IOS
//
//   9/17.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMineTableViewCell.h"
@interface CAMineTableViewCell()



@end
@implementation CAMineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    
    return self;
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    self.imageV.image = [UIImage imageNamed:data[@"image"]];
    self.textLab.text = CALanguages(data[@"text"]);
    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(40);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.contentView);
    }];
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [UIImageView new];
        [self.contentView addSubview:_imageV];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.width.height.equalTo(@18);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _imageV;
}

-(UILabel *)textLab{
    if (!_textLab) {
        _textLab = [UILabel new];
        [self.contentView addSubview:_textLab];
        [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(19);
            make.centerY.equalTo(self.imageV);
        }];
        
        _textLab.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        _textLab.font = FONT_REGULAR_SIZE(15);
    }
    return _textLab;
}

@end
