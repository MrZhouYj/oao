//
//  CASystemMessageTableViewCell.m
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CASystemMessageTableViewCell.h"

@interface CASystemMessageTableViewCell()

@property (nonatomic, strong) UIButton *messageTextButton;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CASystemMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.messageTextButton];
        [self addSubview:self.timeLabel];
    }
    return self;
}

-(void)layoutSubviews{
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.width.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    
    [self.messageTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.messageModel.messageSize.width);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
    }];
}

-(void)setMessageModel:(CAMessageModel *)messageModel{
    [super setMessageModel:messageModel];
    
    [self.messageTextButton setTitle:NSStringFormat(@"%@",messageModel.body) forState:UIControlStateNormal];
    [self.timeLabel setText:NSStringFormat(@"%@",messageModel.sent_at)];
}

- (UILabel *) timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:FONT_MEDIUM_SIZE(12)];
        _timeLabel.textColor =  HexRGB(0x999ebc);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _timeLabel;
}

- (UIButton *) messageTextButton
{
    if (_messageTextButton == nil) {
        _messageTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageTextButton.titleLabel.font = FONT_MEDIUM_SIZE(12);
        [_messageTextButton setTitleColor:HexRGB(0x999ebc) forState:UIControlStateNormal];
        
        _messageTextButton.backgroundColor = HexRGB(0xdcdce5);
        _messageTextButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _messageTextButton.layer.masksToBounds = YES;
        _messageTextButton.layer.cornerRadius = 5;
        
    }
    return _messageTextButton;
}


@end
