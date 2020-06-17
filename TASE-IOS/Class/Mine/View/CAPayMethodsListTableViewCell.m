//
//  CAPayMethodsListTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/19.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAPayMethodsListTableViewCell.h"

@interface CAPayMethodsListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *payIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLabel;


@end

@implementation CAPayMethodsListTableViewCell

- (IBAction)activationAction:(id)sender {
    
//    [self routerEventWithName:@"activationAction" userInfo:self.key];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.payNameLabel.font = FONT_MEDIUM_SIZE(15);
    self.userNameLabel.font = FONT_MEDIUM_SIZE(15);
    self.stateLabel.font = FONT_MEDIUM_SIZE(14);
    self.userAccountLabel.font = FONT_MEDIUM_SIZE(15);
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.payIconImageView);
    }];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stateLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.stateLabel);
        make.width.height.equalTo(@15);
    }];
    
}



-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.payNameLabel.text = NSStringFormat(@"%@",dataDic[@"payment_name"]);
}

-(void)setKey:(NSString *)key{
    _key = key;
    
    BOOL isActive = NO;
    
    if ([key isEqualToString:@"wechat"]) {
        self.payIconImageView.image = IMAGE_NAMED(@"WeChat");
        self.userAccountLabel.text = NSStringFormat(@"%@",self.dataDic[@"account"]);
        self.userNameLabel.text = NSStringFormat(@"%@",self.dataDic[@"real_name"]);
        isActive = [self.dataDic[@"is_wechat_activated"] boolValue];
        
    }else if ([key isEqualToString:@"bank_card"]){
        self.payIconImageView.image = IMAGE_NAMED(@"Bankcard");
        self.userAccountLabel.text = NSStringFormat(@"%@",self.dataDic[@"bank_account_number"]);
        self.userNameLabel.text = NSStringFormat(@"%@",self.dataDic[@"real_name"]);
        isActive = [self.dataDic[@"is_bankcard_activated"] boolValue];
        
    }else if ([key isEqualToString:@"alipay"]){
        self.payIconImageView.image = IMAGE_NAMED(@"Alipay");
        self.userAccountLabel.text = NSStringFormat(@"%@",self.dataDic[@"account"]);
        self.userNameLabel.text = NSStringFormat(@"%@",self.dataDic[@"real_name"]);
        isActive = [self.dataDic[@"is_alipay_activated"] boolValue];
    }
    
    if (isActive) {
        self.stateImageView.image = IMAGE_NAMED(@"pay_method_sel");
        self.stateLabel.textColor = HexRGB(0x006cdb);
        self.stateLabel.text =CALanguages(@"已激活");
    }else{
        self.stateImageView.image = IMAGE_NAMED(@"pay_method_normal");
        self.stateLabel.textColor = HexRGB(0x191d26);
        self.stateLabel.text = CALanguages(@"未激活");
    }
}

@end
