//
//  CAAlertInsureView.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/11/26.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAAlertInsureView.h"
#import "CAChoosePayTypeView.h"

@interface CAAlertInsureView()
<CAChoosePayTypeViewDelegate>
{
    BOOL _isShowPayMethodsMenu;
    NSArray * _payMenthods;
}
@property (nonatomic, strong) UILabel * insureTitleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@property (nonatomic, strong) UILabel * notiTitleLabel;

@property (nonatomic, strong) UIButton * confimButton;
@property (nonatomic, strong) UIButton * cancleButton;
@property (nonatomic, strong) CAChoosePayTypeView * payView;
@property (nonatomic, strong) NSArray * payMethods;

@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic, copy) CancleBlock cancleBlock;
@property (nonatomic, copy) NSString * currentPayMethod;
@end

@implementation CAAlertInsureView

-(void)showAlert:(NSString *)logo title:(NSString *)title subTitle:(NSString *)subTitle notiTitle:(NSString *)notiTitle confirmBlock:(ConfirmBlock)confirm cancleBlock:(CancleBlock)cancle{
    
//    self.titleImage = IMAGE_NAMED(@"popview_insureicon");
    self.confirmBlock = confirm;
    self.cancleBlock = cancle;
    
    [self initSubViews];
    
    self.insureTitleLabel.text = CALanguages(title);
    self.subTitleLabel.text = CALanguages(subTitle);
    self.notiTitleLabel.text = CALanguages(notiTitle);
    
    
    [self show];
}

-(void)showAlertTitle:(NSString *)title subTitle:(NSString *)subTitle importPayMethods:(NSArray *)payMethods confirmBlock:(ConfirmBlock)confirm cancleBlock:(CancleBlock)cancle{
    
    _isShowPayMethodsMenu = YES;
    _payMenthods =  payMethods;
    [self initSubViews];
    self.confirmBlock = confirm;
    self.cancleBlock = cancle;
    
    self.insureTitleLabel.text = CALanguages(title);
    self.subTitleLabel.text = CALanguages(subTitle);
    self.payMethods = payMethods;
    
    [self show];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)initSubViews{
    
    
    self.insureTitleLabel = [self creatLabelFont:FONT_SEMOBOLD_SIZE(19) color:HexRGB(0x191d26)];
    [self.insureTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    
    
    self.subTitleLabel = [self creatLabelFont:FONT_REGULAR_SIZE(15) color:HexRGB(0x191d26)];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.insureTitleLabel.mas_bottom).offset(15);
    }];
    
    self.notiTitleLabel = [self creatLabelFont:FONT_REGULAR_SIZE(14) color:HexRGB(0x006cdb)];
    [self.notiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(5);
    }];
    
    if (_isShowPayMethodsMenu) {
        self.payView = [CAChoosePayTypeView new];
        [self addSubview:self.payView];
        self.payView.delegata = self;
        [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(0);
            make.top.equalTo(self.notiTitleLabel.mas_bottom);
            make.height.equalTo(@50);
        }];
        self.payView.supportPayMethodArray = _payMenthods;
        self.payView.canMultipleSelection = NO;

    }
    
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.cancleButton];
    [self.cancleButton setTitle:CALanguages(@"取消") forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:HexRGB(0x191d26) forState:UIControlStateNormal];
     self.cancleButton.titleLabel.font = FONT_REGULAR_SIZE(15);
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        if (self->_isShowPayMethodsMenu) {
            make.top.equalTo(self.payView.mas_bottom).offset(15);
        }else
        make.top.equalTo(self
                         .notiTitleLabel.mas_bottom).offset(15);
        make.width.equalTo(self.contentView).multipliedBy(0.5);
        make.height.equalTo(@45);
    }];
    
    self.confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.confimButton];
    [self.confimButton setTitle:CALanguages(@"确定")  forState:UIControlStateNormal];
    [self.confimButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
    self.confimButton.titleLabel.font = FONT_REGULAR_SIZE(15);
    [self.confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.cancleButton.mas_top);
        make.width.height.equalTo(self.cancleButton);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confimButton.mas_bottom);
    }];
    
    [self.confimButton addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)CAChoosePayTypeView_didSelected:(NSString *)payType{
    
    NSArray * array = self.payView.payMethodsArray;
    
    if (array.count) {
        self.confimButton.enabled = YES;
        [self.confimButton setTitleColor:HexRGB(0x006cdb) forState:UIControlStateNormal];
        self.currentPayMethod = array.lastObject;
    }else{
        self.confimButton.enabled = NO;
        [self.confimButton setTitleColor:HexRGB(0x191d26) forState:UIControlStateNormal];
    }
}

-(void)okClick{
    if (self.confirmBlock) {
        self.confirmBlock(self.currentPayMethod);
    }
    [self hide];
}
-(void)cancleClick{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [self hide];
}

-(UILabel *)creatLabelFont:(UIFont*)font color:(UIColor*)color{
   
    UILabel * label = [UILabel new];
    [self.contentView addSubview:label];
    
    label.font = font;
    label.numberOfLines = 0;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


@end
