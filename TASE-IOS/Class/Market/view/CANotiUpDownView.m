//
//  CANotiUpDownView.m
//  TASE-IOS
//
//   9/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CANotiUpDownView.h"

@interface CANotiUpDownView()

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UIImageView * arrowImageView;

@end

@implementation CANotiUpDownView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
        self.type = CASymbolsSortTypeNone;
       
    }
    return self;
}

-(void)initSubViews{
    
     self.nameLabel = [UILabel new];
    [self addSubview:self.nameLabel];
    
    self.nameLabel.font = FONT_MEDIUM_SIZE(13);
    self.nameLabel.textColor = HexRGB(0x9192b1);
    
    self.arrowImageView = [UIImageView new];
    [self addSubview:self.arrowImageView];
    
    self.arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_didClick)]];
    
    self.arrowImageView.userInteractionEnabled = YES;
    self.nameLabel.userInteractionEnabled = YES;
    
    
}

-(void)event_didClick{
    
    switch (self.type) {
        case CASymbolsSortTypeNone:
            self.type = CASymbolsSortTypeAsc;
            break;
        case CASymbolsSortTypeAsc:
            self.type = CASymbolsSortTypeDesc;
            break;
        case CASymbolsSortTypeDesc:
            self.type = CASymbolsSortTypeNone;
            break;
            
        default:
            break;
    }
    
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(notiUpDownViewDidChange:rowState:)]) {
        [self.delegate notiUpDownViewDidChange:self rowState:self.type];
    }
    
}

-(void)setAlignment:(Alignment)alignment{
    _alignment = alignment;
    switch (alignment) {
        case AlignmentLeft:
        {  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
//                make.height.equalTo(@12);
                make.left.equalTo(self);
            }];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel.mas_right).offset(5);
                make.centerY.equalTo(self.nameLabel);
                make.height.equalTo(self.nameLabel.mas_height);
                make.width.equalTo(@9);
            }];
        }
            break;
        case AlignmentCenter:
        {  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(-7);
//            make.height.equalTo(@12);
        }];
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel.mas_right).offset(5);
                make.centerY.equalTo(self.nameLabel);
                make.height.equalTo(self.nameLabel.mas_height);
                make.width.equalTo(@9);
            }];
        }
            break;
        case AlignmentRight:
        {
            [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self);
                make.centerY.equalTo(self.nameLabel);
                make.height.equalTo(@12);
                make.width.equalTo(@9);
            }];
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
//                make.height.equalTo(@12);
                make.right.equalTo(self.arrowImageView.mas_left).offset(-5);
            }];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = CALanguages(name);
}

-(void)setType:(CASymbolsSortType)type{
    _type = type;
    
    switch (type) {
        case CASymbolsSortTypeNone:
        {
            self.arrowImageView.image = IMAGE_NAMED(@"arrow");
        }
            break;
        case CASymbolsSortTypeAsc:
        {
            self.arrowImageView.image = IMAGE_NAMED(@"upper_high");
        }
            break;
        case CASymbolsSortTypeDesc:
        {
            self.arrowImageView.image = IMAGE_NAMED(@"lower_high");
        }
            break;
            
        default:
            break;
    }
}


@end
