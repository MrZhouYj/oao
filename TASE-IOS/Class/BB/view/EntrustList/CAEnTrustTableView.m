//
//  CAEnTrustTableView.m
//  TASE-IOS
//
//   10/21.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAEnTrustTableView.h"
#import "CAEntrustTableViewCell.h"
#import "CAEntrustHistoryListTableViewCell.h"

@interface CAEnTrustTableView()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, assign) BOOL isNoMoreData;

@end

@implementation CAEnTrustTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.current_page = 1;
        self.datas = @[].mutableCopy;
        
        kWeakSelf(self);
        [self addReFreshFooter:^{
            
        }];
        [self addReFreshHeader:^{
            weakself.current_page=1;
            [weakself routerEventWithName:@"freshData" userInfo:nil];
        }];
        
        [self registerClass:[CAEntrustTableViewCell class] forCellReuseIdentifier:@"CAEntrustTableViewCell"];
        [self registerClass:[CAEntrustHistoryListTableViewCell class] forCellReuseIdentifier:@"CAEntrustHistoryListTableViewCell"];
       
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isHistory) {
        return 180;
    }
    
    return 115;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isHistory) {
        CAEntrustHistoryListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAEntrustHistoryListTableViewCell"];
        if (self.datas.count>indexPath.row) {
            cell.model = self.datas[indexPath.row];
        }
        return cell;
    }else{
        CAEntrustTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAEntrustTableViewCell"];
        if (self.datas.count>indexPath.row) {
            cell.model = self.datas[indexPath.row];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    if (row==self.datas.count-2&&!self.isNoMoreData&&!self.isLoadingData) {
        
        self.current_page++;
        [self routerEventWithName:@"loadNextPageData" userInfo:nil];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.datas.count>indexPath.row) {
        if (self.isHistory) {
            [self routerEventWithName:@"pushToEntrustListInfoController" userInfo:self.datas[indexPath.row]];
        }else{
            if (self.datas.count>indexPath.row) {
                CAPreventRepeatClickTime(0.5);
                [self routerEventWithName:@"cancleEntrust" userInfo:self.datas[indexPath.row]];
            }
        }
    }
}

-(void)setStateToIdle{
    
    [self.mj_footer setState:MJRefreshStateIdle];
    self.isNoMoreData = NO;
}

-(void)noMoreData{
    
    self.isNoMoreData = YES;
    [self.mj_footer setState:MJRefreshStateNoMoreData];
}
-(void)endFresh{
    
    [self.mj_header endRefreshing];
}

@end
