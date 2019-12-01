//
//  LLLanguageViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/9/2.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLLanguageViewController.h"
#import "LanguageManager.h"
#import "AppDelegate.h"

@interface LLLanguageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) NSInteger selRow;
@end

@implementation LLLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"Language");
    self.view.backgroundColor = [UIColor cyanColor];
    [self initSubviews];
  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    rightButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    if(![LanguageManager currentUserLanguage]){
        self.selRow = 0;
    } else if ([[LanguageManager currentUserLanguage] isEqualToString:kChinese]) {//简体
        self.selRow = 1;
    }else if ([[LanguageManager currentUserLanguage] isEqualToString:kEnglish]) {
        self.selRow = 2;
    }else if ([[LanguageManager currentUserLanguage] isEqualToString:kJapanese]) {
        self.selRow = 3;
    }
    
}
- (void)rightBtnAction:(UIBarButtonItem*)sender{
    NSLog(@"右上角按钮点击");
    if (self.selRow == 0) {//跟随系统
        [LanguageManager followSystemLanguage];
    } else if (self.selRow == 1) {//简体中文
        [LanguageManager setUserLanguage:kChinese];
    }else if (self.selRow == 2) {//英文
        [LanguageManager setUserLanguage:kEnglish];
    }else if (self.selRow == 3) {//日语
        [LanguageManager setUserLanguage:kJapanese];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD show];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate setLanguage];
    [SVProgressHUD dismissWithDelay:2];
    
}

- (void)initSubviews {
    [self.view addSubview:self.table];
}

#pragma  mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    if(indexPath.row == self.selRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selRow = indexPath.row;
    [self.table reloadData];
}

#pragma mark - Getter & Setter
- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:Localized(@"跟随系统语言")];
        [_dataArray addObject:Localized(@"中文")];
        [_dataArray addObject:Localized(@"English")];
        [_dataArray addObject:Localized(@"Japanese")];
    }
    return _dataArray;
}
@end
