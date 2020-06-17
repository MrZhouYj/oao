//
//  CAMessageBaseTableViewCell.m
//  TASE-IOS
//
 
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAMessageBaseTableViewCell.h"

@implementation CAMessageBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.messageBackgroundImageView];
        [self addSubview:self.avatarImageView];
        
    }
    
    return  self;
}
-(void)layoutSubviews
{

    [super layoutSubviews];
    if (_messageModel.ownerTyper == CAMessageOwnerTypeSelf) {
        // 屏幕宽 - 10 - 头像宽
        [self.avatarImageView setOrigin:CGPointMake(CGRectGetWidth(self.frame) - 10 - CGRectGetWidth(self.avatarImageView.frame), 10)];
        
    }
    else if (_messageModel.ownerTyper == CAMessageOwnerTypeOther) {
        
        [self.avatarImageView setOrigin:CGPointMake(10, 10)];
        
    }
}


-(void)setMessageModel:(CAMessageModel *)messageModel
{
    
    _messageModel = messageModel;
    
    switch (_messageModel.ownerTyper) {
        case CAMessageOwnerTypeSelf:
            
            /**
             *  自己发的消息
             */
            [self.avatarImageView setHidden:NO];
            [self.messageBackgroundImageView setHidden:NO];
            
            self.avatarImageView.image = IMAGE_NAMED(@"message_sender_avator");
            
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 5, 20) resizingMode:UIImageResizingModeStretch];
           
            break;
         
        case CAMessageOwnerTypeOther:
            /**
             *  自己接收到的消息
             */
            [self.avatarImageView setHidden:NO];
            self.avatarImageView.image = IMAGE_NAMED(@"message_receiver_avator");
            [self.messageBackgroundImageView setHidden:NO];
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            
            
            break;
        case CAMessageOwnerTypeSystem:
            /**
             *  系统消息
             */
            [self.avatarImageView setHidden:YES];
            [self.messageBackgroundImageView setHidden:YES];
        
        
        break;
            
        default:
            
            break;
    
    }
}


/**
 * avatarImageView 头像
 */

-(UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        float imageWidth = 40;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [_avatarImageView setHidden:YES];
    }
    return _avatarImageView;
}
/**
 *  聊天背景图
 */
- (UIImageView *) messageBackgroundImageView
{
    if (_messageBackgroundImageView == nil) {
        _messageBackgroundImageView = [[UIImageView alloc] init];
        [_messageBackgroundImageView setHidden:YES];
    }
    return _messageBackgroundImageView;
}

@end
