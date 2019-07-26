//
//  LLShoppingCartViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLShoppingCartViewController.h"

#import "LLShoppingCartTableViewCell.h"
#import "JSBadgeView.h"

#import "LLShoppingCartModel.h"

#import "PurchaseCarAnimationTool.h"

@interface LLShoppingCartViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIButton *cartButton;
@property (nonatomic, strong) JSBadgeView *badgeView;
@end

@implementation LLShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table];
    [self.view addSubview:self.cartButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.cartButton.frame = CGRectMake(200, self.view.height - LZY_TAB_BAR_SAFE_BOTTOM_MARGIN - 50, 50, 50);
}
- (void)addToCart {
    
    [[PurchaseCarAnimationTool shareTool] startAnimationandView:self.view rect:self.view.frame finisnPoint:CGPointMake(self.cartButton.x, self.cartButton.y)  finishBlock:^(BOOL finish) {
        
    }];
}
#pragma  mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"LLShoppingCartTableViewCell";
    LLShoppingCartTableViewCell *cell = (LLShoppingCartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[LLShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell updateData:self.dataArray[indexPath.row]];
    @LZY_weakify(self)
    cell.cellButtonBlock = ^(UIButton * _Nonnull addButton) {
     
        
        LLShoppingCartTableViewCell * wCell = (LLShoppingCartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        CGRect rect = wCell.frame;
        
        
        /// 获取当前cell 相对于self.view 当前的坐标
        rect.origin.y = rect.origin.y - tableView.contentOffset.y + LZY_IPHONE_NAV_STATUS_HEIGHT + addButton.y;
        CGPoint point = CGPointMake(addButton.x, rect.origin.y);
        
        [[PurchaseCarAnimationTool shareTool] startAnimationFrom:point to:CGPointMake(self.cartButton.right, self.cartButton.y + LZY_IPHONE_NAV_STATUS_HEIGHT) completion:^(BOOL finish) {
            @LZY_strongify(self)
            NSInteger count = self.badgeView.badgeText.integerValue;
            self.badgeView.badgeText = [NSString stringWithFormat:@"%zi",++count];
        }];
        
        
//        CGRect imageViewRect   = addButton.frame;
//        imageViewRect.origin.x = rect.origin.x;
//        imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y;
//        [[PurchaseCarAnimationTool shareTool] startAnimationandView:addButton rect:imageViewRect finisnPoint:CGPointMake(ScreenWidth / 4 * 2.5, ScreenHeight - 49)  finishBlock:^(BOOL finish) {
//               @LZY_strongify(self)
//            NSInteger count = self.badgeView.badgeText.integerValue;
//            self.badgeView.badgeText = [NSString stringWithFormat:@"%zi",++count];
//        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter
- (UITableView*)table{
    if(!_table){
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, LZY_SCREEN_HEIGHT - LZY_IPHONE_NAV_STATUS_HEIGHT - LZY_TAB_BAR_SAFE_BOTTOM_MARGIN) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        LLShoppingCartModel *model1 = [[LLShoppingCartModel alloc] init];
        model1.url = @"http://g.hiphotos.baidu.com/image/pic/item/6d81800a19d8bc3e770bd00d868ba61ea9d345f2.jpg";
        model1.name = @"苹果";
        model1.content = @"好吃又好看的苹果，又红又大的苹果";
        model1.price = @"9.99";
        model1.count = 2;
        
        LLShoppingCartModel *model2 = [[LLShoppingCartModel alloc] init];
        model2.url = @"http://c.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de1e296fa390eef01f3b29795a.jpg";
        model2.name = @"橘子";
        model2.content = @"电风扇的问第三个双方各担任财务水电费道森股份四川人万人次的风格分公司给对方个人我大锅饭是大法官";
        model2.price = @"6.99";
        model2.count = -2;
        
        LLShoppingCartModel *model3 = [[LLShoppingCartModel alloc] init];
        model3.url = @"http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg";
        model3.name = @"西瓜";
        model3.content = @"又红又大的西瓜，清凉解渴的西瓜";
        model3.price = @"2.99";
        model3.count = 2;
        
        LLShoppingCartModel *model4 = [[LLShoppingCartModel alloc] init];
        model4.url = @"http://a.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a292d2472199d25bc315d607c7c.jpg";
        model4.name = @"香蕉";
        model4.content = @"banana banana banana banana";
        model4.price = @"5.99";
        model4.count = 2;
        
        _dataArray = [NSMutableArray arrayWithArray:@[model1, model2, model3, model4, model1, model2, model3, model4]];
    }
    return _dataArray;
}

- (UIButton *)cartButton {
    if(!_cartButton){
        _cartButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cartButton setTitle:@"购物车" forState:UIControlStateNormal];
        [_cartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cartButton.titleLabel.font = LZY_FONT_FROM_NAME_SIZE(15);
        _cartButton.backgroundColor = [UIColor blueColor];
        [_cartButton bk_addEventHandler:^(id sender) {
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartButton;
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.cartButton alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeStrokeWidth = 0;
        _badgeView.badgeText = @"";
    }
    return _badgeView;
}

@end
