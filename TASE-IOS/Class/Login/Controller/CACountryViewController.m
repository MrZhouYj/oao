//
//  CACountryViewController.m
//  TASE-IOS
//
//  Copyright © 2019 CA. All rights reserved.
//

#import "CACountryViewController.h"
#import "CASearchTableViewCell.h"


@interface CACountryViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>
{
    BOOL _isShowSearchResult;
}
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) NSArray * searchResultArray;

@property (nonatomic, strong) UITextField * searchTf;

@end

@implementation CACountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isShowSearchResult = NO;
    
   [self initSubViews];
           
   [self getData];
}

-(void)getData{
    
    [CANetworkHelper GET:CAAPI_COMMON_CONUNTRY_CODES parameters:nil success:^(id responseObject) {
        self.dataArray = [CACountryModel getModels:responseObject[@"country_codes"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)initSubViews{
    
    self.navcBar.backButton.hidden = YES;
    CGRect navcRect = self.navcBar.frame;
    CGRect navcContentRect = self.navcBar.navcContentView.frame;
    navcRect.size.height+=10;
    navcContentRect.origin.y+=10;
    self.navcBar.frame = navcRect;
    self.navcBar.navcContentView.frame = navcContentRect;
    
    
    
    UIView * lineViewDown = [UIView new];
    [self.navcBar.navcContentView addSubview:lineViewDown];
    lineViewDown.dk_backgroundColorPicker  = DKColorPickerWithKey(LineColor);
    [lineViewDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.navcBar.navcContentView);
        make.height.equalTo(@0.5);
    }];

    
    
    
    UIImageView * searchImageView = [UIImageView new];
    [self.navcBar.navcContentView addSubview:searchImageView];
    searchImageView.image = IMAGE_NAMED(@"sousuo");
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navcBar.navcContentView).offset(15);
        make.centerY.equalTo(self.navcBar.navcContentView);
        make.width.height.equalTo(@18);
    }];
    
    
    
    
    UIButton * cancaleButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navcBar.navcContentView addSubview:cancaleButton];
    [cancaleButton setTitle:CALanguages(@"取消") forState:UIControlStateNormal];
    [cancaleButton setTitleColor:HexRGB(0xa3a4bd) forState:UIControlStateNormal];
    cancaleButton.titleLabel.font = FONT_MEDIUM_SIZE(14);
    [cancaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navcBar.navcContentView).offset(-10);
        make.centerY.equalTo(self.navcBar.navcContentView);
        make.width.equalTo(@60);
    }];
    [cancaleButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UITextField * searchTf = [UITextField new];
    [self.navcBar.navcContentView addSubview:searchTf];
    self.searchTf = searchTf;
    searchTf.returnKeyType = UIReturnKeySearch;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:CALanguages(@"请选择国家或地区") attributes:
         @{NSForegroundColorAttributeName:HexRGB(0xbfbfc1),
           NSFontAttributeName:FONT_REGULAR_SIZE(14)}
         ];
    searchTf.attributedPlaceholder = attrString;
    searchTf.font = FONT_REGULAR_SIZE(14);
    searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTf.delegate = self;
    searchTf.dk_textColorPicker = DKColorPickerWithKey(NormalBlackColor_191d26);
    [searchTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImageView.mas_right).offset(10);
        make.centerY.equalTo(searchImageView);
        make.right.equalTo(cancaleButton.mas_left).offset(-15);
    }];
    [searchTf addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navcBar.mas_bottom);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
    }];
    
}

-(void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
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
        cell.countryModel = self.searchResultArray[indexPath.row];
    }else{
        cell.countryModel = self.dataArray[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.delegate && [self.delegate respondsToSelector:@selector(CACountryViewController_didSelected:)]) {
        
        [self.delegate CACountryViewController_didSelected:self.dataArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)searchWithKey:(NSString*)keyString{
    
    if (keyString&&keyString.length) {
        
        __block NSString * key = keyString;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
           key = [NSMutableString stringWithString:key];
           NSString *checker = [NSString stringWithFormat:@"%C", 8198];
           key = [key stringByReplacingOccurrencesOfString:checker withString:@""];
       
           NSMutableArray * backMutArray = @[].mutableCopy;
           for (CACountryModel *model in self.dataArray) {
               
               NSString * searchString =[CommonMethod transformToPinyin: model.name];
               
               NSRange range = [searchString rangeOfString:key options:NSCaseInsensitiveSearch];
               if (range.length>0) {
                   [backMutArray addObject:model];
               }
           }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               self.searchResultArray = backMutArray;
               [self.tableView reloadData];
            });
        });
        
    }else{
        _isShowSearchResult = NO;
        [self.tableView reloadData];
    }
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
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


@end
