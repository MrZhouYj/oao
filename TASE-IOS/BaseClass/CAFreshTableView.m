//
//  CAFreshTableView.m
//  TASE-IOS
//
//  Created by 周永建 on 2019/12/9.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAFreshTableView.h"
#import <MJRefresh/MJRefresh.h>

@implementation CAFreshTableView

-(LYEmptyView*)getEmptyView{
    
    LYEmptyView * emptyView = [LYEmptyView emptyViewWithImage:IMAGE_NAMED(@"datanull") titleStr:CALanguages(@"无数据")  detailStr:@""];
    emptyView.titleLabTextColor = RGB(171, 175, 204);
    emptyView.titleLabFont = FONT_REGULAR_SIZE(15);
    emptyView.actionBtnFont = FONT_REGULAR_SIZE(15);
    emptyView.actionBtnTitleColor = RGB(0, 108, 219);
    emptyView.actionBtnBorderColor = RGB(0, 108, 219);
    emptyView.actionBtnBorderWidth = 1;
    emptyView.actionBtnCornerRadius = 2;
    emptyView.imageSize = CGSizeMake(83/414.f*MainWidth, 83/414.f*MainWidth);
    emptyView.contentViewY = kTopHeight+100;
    
    return emptyView;
}

-(void)languageDidChange{
    self.ly_emptyView = [self getEmptyView];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageDidChange) name:CALanguageDidChangeNotifacation object:nil];

        [self languageDidChange];
    }
    return self;
}

-(void)addReFreshHeader:(void (^)(void))block{
    
    __block MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        if (block) {
            block();
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    NSMutableArray * imageArray = [NSMutableArray array];
    for (int i=1; i<=7; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"fresh_%d.png",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    [header setImages:@[imageArray[0]] forState:MJRefreshStateIdle];
    [header setImages:imageArray forState:MJRefreshStatePulling];
    [header setImages:imageArray forState:MJRefreshStateRefreshing];
    
    self.mj_header = header;
}

-(void)addReFreshFooter:(void (^)(void))block{
    
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
           NSLog(@"添加上上拉加载");
        if (block) {
            block();
        }
    }];
    
//    [footer setTitle:@"" forState:MJRefreshStateIdle];
//    [footer setTitle:@"" forState:MJRefreshStatePulling];
//    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"end" forState:MJRefreshStateNoMoreData];
    
    self.mj_footer = footer;
    
}


@end
