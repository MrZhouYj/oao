//
//  CABBSearshView.m
//  TASE-IOS
//
//   10/18.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CABBSearshView.h"
#import "CASegmentView.h"
#import "CASearchTableViewCell.h"
#import "CASymbolsModel.h"

@interface CABBSearshView()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
CASegmentViewDelegate
>

{
    BOOL _isShowSearchResult;

    NSArray * _allKeys;
    NSInteger _currentIndex;
}

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) CASegmentView * segmentView;

@property (nonatomic, strong) UIView * searchView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) NSArray * searchResultArray;

@property (nonatomic, strong) UITextField * searchTf;

@end

@implementation CABBSearshView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isShowSearchResult = NO;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.segmentView];
        [self addSubview:self.tableView];
        
        _currentIndex = 0;
        
        [self didChange];

    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didChange{
    
    _titleLabel.text =  CALanguages(@"币币");
    NSArray * segments = [CommonMethod readFromUserDefaults:CAMaretSortKey];
    
    if (segments.count) {
        
        NSMutableArray * segmentItems = segments.mutableCopy;
        [segmentItems insertObject:CALanguages(@"自选") atIndex:0];
        _allKeys = segmentItems;
        self.segmentView.segmentItems = segmentItems;
        self.segmentView.segmentCurrentIndex = 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isShowSearchResult) {
        return self.searchResultArray.count;
    }
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   CASearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CASearchTableViewCell"];
    if (_isShowSearchResult) {
        cell.model = self.searchResultArray[indexPath.row];
    }else{
        cell.model = self.dataArray[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CASymbolsModel * model;
    if (_isShowSearchResult) {
        
        model = self.searchResultArray[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    if (model) {
        if (self.delegata&&[self.delegata respondsToSelector:@selector(CABBSearshView_didsectedMarket:)]) {
            [self.delegata CABBSearshView_didsectedMarket:model];
            [CommonMethod writeToUserDefaults:NSStringFormat(@"%@",model.market_id) withKey:CAMaretDefaultMarketId];
            if (_isShowSearchResult) {
                _isShowSearchResult = NO;
                self.searchTf.text = @"";
                [self reloadData];
            }
            [self hide:NO];
        }
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    _isShowSearchResult =  NO;
    self.searchResultArray = @[];
    [self.tableView reloadData];
    
    return YES;
}

-(void)textFieldTextDidChange{
    
    _isShowSearchResult = YES;
    [self searchWithKey:self.searchTf.text];
}

-(void)searchWithKey:(NSString*)key{
    
    if (key&&key.length) {
        
        key = [NSMutableString stringWithString:key];
        NSString *checker = [NSString stringWithFormat:@"%C", 8198];
        key = [key stringByReplacingOccurrencesOfString:checker withString:@""];
        NSMutableArray * backMutArray = @[].mutableCopy;
        for (CASymbolsModel *model in self.dataArray) {
            
            NSString * searchString = model.ask_unit;
            NSRange range = [searchString rangeOfString:key options:NSCaseInsensitiveSearch];
            if (range.length>0) {
                [backMutArray addObject:model];
            }
        }
        NSLog(@"%@",self.dataArray);
        self.searchResultArray = backMutArray;
        
    }else{
        _isShowSearchResult = NO;
    }
    
    [self.tableView reloadData];
    
}


-(void)layoutSubviews{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(kStatusBarHeight+15);
    }];
    
    
   [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self);
       make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
       make.height.equalTo(@40);
   }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@45);
        make.top.equalTo(self.segmentView.mas_bottom);
    }];
    
    
   [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.bottom.right.equalTo(self);
       make.top.equalTo(self.searchView.mas_bottom);
   }];
}

-(UIView *)searchView{
    
    if (!_searchView) {
        _searchView = [UIView new];
        [self addSubview:_searchView];
        
        UIView * lineView = [UIView new];
        [_searchView addSubview:lineView];
        lineView.dk_backgroundColorPicker  = DKColorPickerWithKey(LineColor);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_searchView);
            make.height.equalTo(@0.5);
        }];
        
        UIView * lineViewDown = [UIView new];
        [_searchView addSubview:lineViewDown];
        lineViewDown.dk_backgroundColorPicker  = DKColorPickerWithKey(LineColor);
        [lineViewDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_searchView);
            make.height.equalTo(@0.5);
        }];

        UIImageView * searchImageView = [UIImageView new];
        [_searchView addSubview:searchImageView];
        searchImageView.image = IMAGE_NAMED(@"sousuo");
        [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_searchView).offset(15);
            make.centerY.equalTo(_searchView);
            make.width.height.equalTo(@20);
        }];
        
        UITextField * searchTf = [UITextField new];
        [self addSubview:searchTf];
        self.searchTf = searchTf;
        searchTf.returnKeyType = UIReturnKeySearch;
        [searchTf addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:CALanguages(@"搜索")  attributes:
             @{NSForegroundColorAttributeName:HexRGB(0xbfbfc1),
               NSFontAttributeName:FONT_REGULAR_SIZE(13)}
             ];
           
        searchTf.attributedPlaceholder = attrString;
        searchTf.font = FONT_REGULAR_SIZE(13);
        searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        searchTf.delegate = self;
        
        searchTf.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
        
        [searchTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchImageView.mas_right).offset(5);
            make.centerY.equalTo(searchImageView);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return _searchView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CASearchTableViewCell class] forCellReuseIdentifier:@"CASearchTableViewCell"];
    }
    return _tableView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SEMOBOLD_SIZE(22);
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(BoldTextColor_1b1e2b);
        
    }
    return _titleLabel;
}

-(CASegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[CASegmentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        _segmentView.delegata = self;
        _segmentView.maxCount = 4;
        _segmentView.dk_backgroundColorPicker = DKColorPickerWithKey(WhiteItemBackGroundColor);
    }
    return _segmentView;
}

-(void)reloadData{
    
    if (_allKeys.count>_currentIndex) {
        
        if (_currentIndex==0) {
            //自选
            self.dataArray = [CASymbolsModel getSymbolsFav];
        }else{
            self.dataArray = [CASymbolsModel getSymbolsBy:_allKeys[_currentIndex]];
        }
        
        if (_isShowSearchResult) {
            [self searchWithKey:self.searchTf.text];
        }
        [self.tableView reloadData];
    }
}

-(void)CASegmentView_didSelectedIndex:(NSInteger)index{
    
    _currentIndex = index;
    
    [self reloadData];
}

@end
