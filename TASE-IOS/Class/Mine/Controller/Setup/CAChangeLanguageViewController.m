//
//  CAChangeLanguageViewController.m
//  TASE-IOS
//
//  Created by ZEMac on 2019/9/7.
//  Copyright © 2019 CA. All rights reserved.
//

#import "CAChangeLanguageViewController.h"
#import "CAMineTableViewCell.h"
#import "CATabbarController.h"

@interface CAChangeLanguageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray * dataArr;

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CAChangeLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self freshAction];
}

-(void)freshAction{
    
    self.navcTitle =  @"切换语言";
    
    [self.tableView reloadData];
}

-(void)languageDidChange{
 
    [self freshAction];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CAMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CAMineTableViewCell"];

    cell.imageV.image = IMAGE_NAMED(self.dataArr[indexPath.row][@"image"]);
    
    cell.textLab.text = self.dataArr[indexPath.row][@"text"];
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * key = self.dataArr[indexPath.row][@"key"];
    
    NSLog(@"%@",key);
    
    [CALanguageManager setUserLanguage:key];
    
    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:CALanguages(@"完成")];

}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[
                     @{
                         @"image":@"change_lang_english",
                         @"text":@"English",
                         @"key":ENGLISH_english,
                         },
                     @{
                         @"image":@"change_lang_chinese",
                         @"text":@"简体中文",
                         @"key":CHINESE_Chinese,
                         },
                     @{
                         @"image":@"change_lang_korean",
                         @"text":@"한국어",
                         @"key":KOREAN_Korean,
                         },
                     @{
                         @"image":@"change_lang_russia",
                         @"text":@"русский язык",
                         @"key":RUSSIAN_Russian,
                         },
                     @{
                         @"image":@"change_lang_japan",
                         @"text":@"日本語",
                         @"key":JAPANESE_Japanese,
                         },
                     ];
    }
    return _dataArr;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[CAMineTableViewCell class] forCellReuseIdentifier:@"CAMineTableViewCell"];
    }
    return _tableView;
}

@end
