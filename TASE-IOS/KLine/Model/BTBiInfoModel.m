//
//  BTBiInfoModel.m
//  Bitbt
//
//  Created by iOS on 2019/5/14.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import "BTBiInfoModel.h"

@implementation BTBiInfoModel

-(void)setIntroduction:(NSString *)introduction{
    _introduction = introduction;
    
    [self caculateCellHeight];
}

-(void)caculateCellHeight{
    
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[self.introduction dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];

    [htmlString addAttributes:@{NSFontAttributeName:FONT_REGULAR_SIZE(14)} range:NSMakeRange(0, htmlString.length)];

    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){MainWidth - 30, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

    _desCellHeight  = textSize.height+40;
    
}



@end
