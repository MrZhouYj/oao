
//
//  CAFeedbackViewController.m
//  TASE-IOS
//
//  Created by 周永建 on 2020/3/25.
//  Copyright © 2020 CA. All rights reserved.
//


#import "CAFeedbackViewController.h"

#define MaxSize 800

@interface CAFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextField;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) CAUser * user;

@end

@implementation CAFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navcTitle = @"意见反馈";
    
    self.view.backgroundColor = HexRGB(0xfafafa);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];

    [self setUi];
    
    [self textChange];
}

-(void)textChange{
    
    NSString * text = self.contentTextField.text;
    if (text.length>MaxSize) {
        text = [text substringToIndex:MaxSize];
        self.contentTextField.text = text;
    }
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%@:%ld",CALanguages(@"剩余字数"),MaxSize-text.length];
}

-(void)setUi{
    
    
    self.sendBtn.titleLabel.font = FONT_MEDIUM_SIZE(16);
    [self.sendBtn setTitleColor:HexRGB(0xf8fbff) forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = RGB(0, 108, 219);
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 2;
    [self.sendBtn setTitle:CALanguages(@"提交") forState:UIControlStateNormal];
    self.contentTextField.font = FONT_MEDIUM_SIZE(16);
    
    
}

- (IBAction)sendClick:(id)sender {
    
    if (!self.contentTextField.text.length) {
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary * para = @{
        @"content":NSStringFormat(@"%@",self.contentTextField.text),
    };
    [CANetworkHelper POST:CAAPI_MINE_FEEDBACK  parameters:para success:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue]==20000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            Toast(responseObject[@"message"]);
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
