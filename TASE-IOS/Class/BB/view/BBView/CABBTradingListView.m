//
//  CABBTradingListView.m
//  TASE-IOS
//
//   9/24.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBTradingListView.h"

static NSInteger baseTag = 1000;

@interface CABBTradingListView()
//显示的数据
@property (nonatomic ,strong) NSArray * dataArray;
//显示的数据的个数 5 或者10
@property (nonatomic, assign) NSInteger showNumber;

@property (nonatomic, strong) NSMutableArray * listViewArray;

@end

@implementation CABBTradingListView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self freshWithData:@[] showNumber:self.showNumber tradingType:TradingSell];
    }
    return self;
}

-(void)freshWithData:(NSArray *)dataArray showNumber:(NSInteger)showNumber tradingType:(TradingType)type{
    
    
    if (type==TradingSell) {
//        NSArray * array = [[dataArray reverseObjectEnumerator] allObjects];
        if ((dataArray.count>5&&showNumber<=5)||(dataArray.count>10&&showNumber<=10)) {
            dataArray = [dataArray subarrayWithRange:NSMakeRange(dataArray.count-showNumber, showNumber)];
        }
    }
    
    
    self.dataArray = dataArray;
    
    self.showNumber = showNumber;
    [self removeAllSubViews];

    CABBDeepListView * lastView = nil;
    for (int i=0; i<showNumber; i++) {
        CABBDeepListView * listView = [CABBDeepListView new];
        [self addSubview:listView];
        listView.type = type;
        if (dataArray.count>i&&dataArray[i]) {
            listView.scaleDeep = 0;
            listView.price = NSStringFormat(@"%@",dataArray[i][@"price"]);
            listView.number = NSStringFormat(@"%@",dataArray[i][@"volume"]);
        }
       
        [self.listViewArray addObject:listView];
        listView.tag = i+baseTag;
       
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(1.0/showNumber);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            }else{
                make.top.equalTo(self);
            }
        }];
        lastView = listView;
        
        [listView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listViewClick:)]];
    }
}

-(void)listViewClick:(UIGestureRecognizer*)tap{
    
    NSInteger index = [[tap view] tag]-baseTag;
    if (self.dataArray.count>index) {
       NSString *price = self.dataArray[index][@"price"];
       [self routerEventWithName:@"listViewChoosePrice" userInfo:price];
    }
    
}

-(NSMutableArray *)listViewArray{
    if (!_listViewArray) {
        _listViewArray = @[].mutableCopy;
    }
    return _listViewArray;
}

@end
