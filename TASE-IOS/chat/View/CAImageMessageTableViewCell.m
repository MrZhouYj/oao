//
//  CAImageMessageTableViewCell.m
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAImageMessageTableViewCell.h"

@interface CAImageMessageTableViewCell()


@end

@implementation CAImageMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.messageImageView];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
  
    float y = self.avatarImageView.y;
    
    if (self.messageModel.ownerTyper == CAMessageOwnerTypeSelf) {
        float x = self.avatarImageView.x - self.messageModel.messageSize.width - 10;
        [self.messageImageView setOrigin:CGPointMake(x , y)];
    }
    else if (self.messageModel.ownerTyper == CAMessageOwnerTypeOther) {
        float x = self.avatarImageView.x + self.avatarImageView.width + 10;
        [self.messageImageView setOrigin:CGPointMake(x, y)];
    }
    
}

-(void)setMessageModel:(CAMessageModel *)messageModel
{

    [super setMessageModel:messageModel];
    
    if (messageModel.imageURL.length) {

    }
    
    if (self.messageModel.originImage) {
        self.messageImageView.image = messageModel.originImage;
    }
    
    self.messageImageView.size = messageModel.messageSize;
}

-(void)imageViewDidClick{
    
    [self routerEventWithName:NSStringFromClass(self.class) userInfo:self.messageModel];
}

-(UIImageView *)messageImageView{
    if (!_messageImageView) {
        _messageImageView = [UIImageView new];
        _messageImageView.layer.masksToBounds = YES;
        _messageImageView.layer.cornerRadius = 2;
        _messageImageView.userInteractionEnabled = YES;
        
        [_messageImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick)]];
    }
    return _messageImageView;
}

@end
