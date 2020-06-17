//
//  CAFriendListTableViewCell.m
//  TASE-IOS
//
//   9/27.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFriendListTableViewCell.h"
@interface CAFriendListTableViewCell()

@property (nonatomic, strong) UILabel * firstNameLabel;

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UILabel * phoneLabel;
@end

@implementation CAFriendListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    self.firstNameLabel = [UILabel new];
    [self.contentView addSubview:self.firstNameLabel];
    
    [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@40);
    }];
    
    self.firstNameLabel.backgroundColor = RGB(0,108,219);
    self.firstNameLabel.font = FONT_MEDIUM_SIZE(26);
    self.firstNameLabel.textColor = [UIColor whiteColor];
    self.firstNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.firstNameLabel.layer.masksToBounds = YES;
    self.firstNameLabel.layer.cornerRadius = 20;
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = FONT_MEDIUM_SIZE(16);
    self.nameLabel.textColor = RGB(25,29,38);
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstNameLabel.mas_right).offset(10);
        make.top.equalTo(self.firstNameLabel.mas_top);
    }];
    
    self.phoneLabel = [UILabel new];
    [self.contentView addSubview:self.phoneLabel];
    self.phoneLabel.font = FONT_MEDIUM_SIZE(15);
    self.phoneLabel.textColor = RGB(150,157,191);
    
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.firstNameLabel.mas_bottom);
    }];
    
}

-(void)setModel:(CAFriendsModel *)model{
    _model = model;
    
    self.firstNameLabel.text = [CommonMethod getFirstFromString:model.nick_name];
    self.nameLabel.text = NSStringFormat(@"%@  %@",model.nick_name,model.email);
    self.phoneLabel.text = NSStringFormat(@"%@",model.mobile);;
}

@end
