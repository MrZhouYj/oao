//
//  CABriefTableViewCell.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/10.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABriefTableViewCell.h"

@interface CABriefTableViewCell()

@property (nonatomic, strong) UILabel * leftLabel;

@property (nonatomic, strong) UILabel * rightLabel;

@end

@implementation CABriefTableViewCell

-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(self.contentView);
        }];
        _leftLabel.dk_textColorPicker = DKColorPickerWithKey(WhiteAndBlack);
    }
    return _leftLabel;
}

-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(self.contentView);
            make.width.mas_lessThanOrEqualTo(@(MainWidth-150));
        }];
        _rightLabel.dk_textColorPicker = DKColorPickerWithKey(WhiteAndBlack);
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyClick)]];
    }
    return _rightLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)copyClick{
    if (self.enableCopy) {
        [CommonMethod copyString:self.rightText];
    }
}

-(void)setLeftText:(NSString *)leftText{
    _leftText = leftText;
    self.leftLabel.text = NSStringFormat(@"%@",leftText);
    self.leftLabel.font = FONT_REGULAR_SIZE(14);
}

-(void)setRightText:(NSString *)rightText{
    _rightText = rightText;
    if (!rightText.length) {
        rightText = @"";
    }
    self.rightLabel.text = NSStringFormat(@"%@",rightText);
    self.rightLabel.font = FONT_REGULAR_SIZE(14);
}

-(void)singleBigTitle:(NSString *)title{
    self.leftLabel.font = FONT_SEMOBOLD_SIZE(18);
    if (!title.length) {
        title = @"";
    }
    self.leftLabel.text = NSStringFormat(@"%@",title);
}

-(void)showBriefIntroduct:(NSString *)text{
    
    self.leftLabel.font = FONT_SEMOBOLD_SIZE(18);
    self.leftLabel.text = CALanguages(@"简介");
  
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    self.rightLabel.numberOfLines = 0;
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftLabel.mas_bottom).offset(10);
        make.left.equalTo(self.leftLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.rightLabel.attributedText = [CABriefTableViewCell attributedStringWithHTMLString:text];
    
}

+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)html

{

    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];

    [htmlString addAttributes:@{NSFontAttributeName:FONT_REGULAR_SIZE(14)} range:NSMakeRange(0, htmlString.length)];

    return htmlString;
}




@end
