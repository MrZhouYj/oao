//
//  CAChatView.m
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChatView.h"
#import "CAMessageModel.h"
#import "CATextMessageTableViewCell.h"
#import "CAChatBoxView.h"
#import "CASystemMessageTableViewCell.h"
#import "CAChatHeaderView.h"
#import "CAImageMessageTableViewCell.h"
#import "CAChatHelper.h"
#import "KNPhotoBrowser.h"

@interface CAChatView()
<UITableViewDelegate,
UITableViewDataSource,
CAChatBoxDelegate,
CAChatHeaderViewDelegate,
CABaseAnimationViewDelegate
>
{
    CGFloat _tableViewDefultHeight;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CAChatBoxView *boxView;

@property (nonatomic, strong) CAChatHeaderView *headerView;

@property (nonatomic, strong) UIButton * upDownButton;

@property (nonatomic, strong) NSMutableArray <CAMessageModel *>* messages;

@end

@implementation CAChatView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HexRGB(0xeeeef4);
        
        [self addSubview:self.headerView];
        [self addSubview:self.tableView];
        [self addSubview:self.boxView];
        _unreadMessagesCount = 0;
        self.delegate = self;
        [self CornerTop];
    }
    return self;
}

-(void)setOrderInfoModel:(CAOrderInfoModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    self.headerView.orderInfoModel = orderInfoModel;
}

-(void)thisViewDidAppear:(BOOL)animated{
    self.unreadMessagesCount = 0;
}

-(void)getMessage{
    
        NSDictionary * para = @{
            @"id":NSStringFormat(@"%@",self.ID)
        };
        
        [CANetworkHelper GET:CAAPI_OTC_MESSAGES parameters:para success:^(id responseObject) {
            //刷新数据
            NSLog(@"%@",responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseObject[@"code"] integerValue]==20000)
                {
                    NSArray * datas = responseObject[@"data"];
                    NSMutableArray * mutData = @[].mutableCopy;
                    for (NSDictionary * dic in datas) {
                        CAMessageModel * model = [CAMessageModel modelWithData:dic];
                        [mutData addObject:model];
                    }
                    [self.messages addObjectsFromArray:mutData];
                    [self.tableView reloadData];
                    [self scrollToBottom];
                }
                [self subscribeChat];
            });
            
        } failure:^(NSError *error) {
        }];
}

-(void)subscribeChat{
    [[CASocket shareSocket] addDelegate:self];
    [[CASocket shareSocket] sendDataToSever:[self messagesOtc]];
}
-(void)unSubscribeChat{
    [[CASocket shareSocket] removeDelegate:self];
    [[CASocket shareSocket] unsubCurrentReq];
}

#pragma mark market_list_app 频道拼接
-(NSDictionary*)messagesOtc{
    NSDictionary * dic = @{
        @"channel" : @"otc_fiat_trading_message",
        @"market_id":NSStringFormat(@"%@",self.ID),
        @"token":NSStringFormat(@"%@",[CAUser currentUser].app_token),
    };
    return [CASocket getSub:dic];
}

- (void)webSocketDidOpen{
    
    [[CASocket shareSocket] sendDataToSever:[self messagesOtc]];
}
-(void)webSocket:(CASocket *)webSocket didReceiveMessage:(NSDictionary *)message{

    if (message[@"channel"]) {
        if ([message[@"channel"] isEqualToString:[self messagesOtc][@"subscribe"]]) {
            NSLog(@"%@",message);
            NSDictionary *msg = message[@"content"];
            if (msg) {
                CAMessageModel * model = [CAMessageModel modelWithData:msg];
                [self.messages addObject:model];
                [self.tableView reloadData];
                [self scrollToBottom];
                if (!self.isShowing) {
                    self.unreadMessagesCount++;
                }
            }
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CAMessageModel  * messageModel = self.messages[indexPath.row];
 
    id cell = [tableView dequeueReusableCellWithIdentifier:messageModel.cellIndentify forIndexPath:indexPath];
  
    [cell setMessageModel:messageModel];
    
    
    return cell;
    
}

#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAMessageModel *message = [self.messages objectAtIndex:indexPath.row];
    return message.cellHeight;
}

- (void) scrollToBottom
{
    
    if (self.messages.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
}

#pragma mark 发送消息
- (void)chatBox:(CAChatBoxView *)chatBox sendTextMessage:(NSString *)textMessage{
    
   
    CAMessageModel *recMessage = [[CAMessageModel alloc] init];
    recMessage.messageType = CAMessageTypeText;
    recMessage.ownerTyper = CAMessageOwnerTypeSelf;
    recMessage.date = [NSDate date];// 当前时间
    recMessage.body = textMessage;
  
    [self addNewMessage:recMessage];

    [self scrollToBottom];
    
}

-(void)chatBox:(CAChatBoxView *)chatBox sendImageMessage:(nonnull UIImage *)imageMessage{
    
    NSLog(@"开始发送图片消息");
    CAMessageModel *recMessage = [[CAMessageModel alloc] init];
    recMessage.messageType = CAMessageTypeImage;
    recMessage.ownerTyper = CAMessageOwnerTypeSelf;
    recMessage.date = [NSDate date];// 当前时间
    recMessage = [CAChatHelper initImageMessage:imageMessage imageMessageModel:recMessage];
    
    [self addNewMessage:recMessage];
    [self scrollToBottom];
    
    NSLog(@"开始发送图片消息  end");
}

- (void) addNewMessage:(CAMessageModel *)message
{
    NSLog(@"发送文本消息");
    NSDictionary * dic = @{
        @"content":NSStringFormat(@"%@",[CAChatHelper removeEmoji:message.body]),
        @"id":NSStringFormat(@"%@",self.ID)
    };
    NSLog(@"%@",dic);
    [self.messages addObject:message];
    [self.tableView reloadData];
    
    [CANetworkHelper POST:@"otc/send_text_message"  parameters:dic success:^(id responseObject) {
    
    } failure:^(NSError *error) {
      
    }];
    
    
}

-(void)CAChatHeaderView_hideChatViewClick{
    
    [self hide:YES];
}

- (void)chatBox:(CAChatBoxView *)chatBox changeChatBoxHeight:(CGFloat)height{
    
    self.tableView.height = _tableViewDefultHeight - height+49+SafeAreaBottomHeight;
    self.boxView.y = self.tableView.height+self.tableView.y;
   
    [self scrollToBottom];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.boxView resignFirstResponder];
}


-(void)routerEventWithName:(NSString *)eventName userInfo:(id)userInfo{
    
    if ([eventName isEqualToString:NSStringFromClass([CAImageMessageTableViewCell class])]) {
        //发送的消息中图片的点击事件
        CAMessageModel * curModel = (CAMessageModel*)userInfo;
        NSMutableArray *tempArr = [NSMutableArray array];
        NSMutableArray *itemsArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.messages.count; i++) {
            
            CAMessageModel *model = self.messages[i];
            if (model.messageType == CAMessageTypeImage) {
                KNPhotoItems *items = [[KNPhotoItems alloc] init];
                if (model.originImage) {
                    items.sourceImage = model.originImage;
                }else if(model.imageURL.length){
                    items.url = model.imageURL;
                }
                [tempArr addObject:model];
                [itemsArr addObject:items];
            }
            
        }
        
        NSArray *visibleCells = self.tableView.visibleCells;
        
        for (NSInteger i = 0; i < itemsArr.count; i++) {
            KNPhotoItems *items = itemsArr[i];
            CAMessageModel *model = tempArr[i];
            
            for (NSInteger j = 0; j < visibleCells.count; j++) {
                id cell = visibleCells[j];
                if ([cell isKindOfClass:[CAImageMessageTableViewCell class]]) {
                    CAImageMessageTableViewCell *cell = (CAImageMessageTableViewCell *)visibleCells[j];
                    if(cell.messageModel.originImage == nil && cell.messageModel.imageURL == nil){
                        
                    }else{
                        if(model == cell.messageModel){
                            items.sourceView = cell.messageImageView;
                        }
                    }
                }
            }
        }
        
        KNPhotoBrowser *photoBrower = [[KNPhotoBrowser alloc] init];
        photoBrower.itemsArr = itemsArr;
        photoBrower.isNeedPageControl = true;
        photoBrower.isNeedPanGesture  = true;
        photoBrower.currentIndex = [tempArr indexOfObject:curModel];
        [photoBrower present];
    }
}

-(CAChatHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CAChatHeaderView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 120)];
        
        _headerView.delegate = self;
        _headerView.backgroundColor = HexRGB(0xf7f6fb);
    }
    return _headerView;
}

-(UITableView *)tableView{
    if (!_tableView ) {
        
        _tableViewDefultHeight = self.height-49-SafeAreaBottomHeight-self.headerView.height;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, MainWidth, _tableViewDefultHeight) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[CATextMessageTableViewCell class] forCellReuseIdentifier:@"CATextMessageTableViewCell"];
         [_tableView registerClass:[CASystemMessageTableViewCell class] forCellReuseIdentifier:@"CASystemMessageTableViewCell"];
        [_tableView registerClass:[CAImageMessageTableViewCell class] forCellReuseIdentifier:@"CAImageMessageTableViewCell"];
        
        [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapClick)]];
    }
    return _tableView;
}

-(void)tableViewTapClick{
    [self.boxView resignFirstResponder];
}


-(CAChatBoxView *)boxView{
    if (!_boxView) {
        _boxView = [[CAChatBoxView alloc] initWithFrame:CGRectMake(0, self.tableView.height+self.tableView.y, MainWidth, 49)];
        [_boxView setDelegate:self];
        
        //用来填充x底部的34
        UIView * lineView = [UIView new];
        [self addSubview:lineView];
        
        lineView.frame = CGRectMake(0, _boxView.ly_maxY, MainWidth, SafeAreaBottomHeight);
        lineView.backgroundColor = _boxView.backgroundColor;
        
        _boxView.viewController = self.viewController;
    }
    return _boxView;
}


-(NSMutableArray<CAMessageModel *> *)messages{
    if (!_messages) {
        _messages = @[].mutableCopy;
    }
    return _messages;
}

@end
