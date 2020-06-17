//
//  CAEmptyTableViewCell.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/25.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEmptyTableViewCell.h"

@implementation CAEmptyTableViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
   
    self.contentLabel.font = FONT_REGULAR_SIZE(15);
    self.contentLabel.textColor= RGB(171, 175, 204);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];
    
    [self languageDidChange];
}

-(void)languageDidChange{
    self.contentLabel.text = CALanguages(@"暂无记录");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
