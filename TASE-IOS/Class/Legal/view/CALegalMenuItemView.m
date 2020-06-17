//
//  CALegalMenuItemView.m
//  TASE-IOS
//
//   9/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CALegalMenuItemView.h"

@interface CALegalMenuItemView()

@property (nonatomic, strong) UIImageView * backGroundImageView;

@property (nonatomic, strong) UILabel * textLabel;

@end

@implementation CALegalMenuItemView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backGroundImageView = [UIImageView new];
        [self addSubview:self.backGroundImageView];
        self.textLabel = [UILabel new];
        [self addSubview:self.textLabel];
        self.textLabel.font = FONT_MEDIUM_SIZE(17);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.select = NO;
        
    }
    return self;
}

-(void)layoutSubviews{
    
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 10));
    }];
    
//    self.backGroundImageView.frame = self.bounds;
//    self.textLabel.frame = self.bounds;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = CALanguages(title);
}

-(void)setSelect:(BOOL)select{
    _select = select;
    if (_select) {
        
        self.backGroundImageView.image = [IMAGE_NAMED(@"background_hlight") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.textLabel.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        self.textLabel.font = FONT_MEDIUM_SIZE(18);
    }else{
        self.backGroundImageView.image = IMAGE_NAMED(@"background_normal");
        self.textLabel.textColor = RGBA(99, 84, 245,0.53);
        self.textLabel.font = FONT_MEDIUM_SIZE(17);
    }
    
    [self setUserInteractionEnabled:!select];
    
    [self layoutIfNeeded];
}

@end
