//
//  LLHomeViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/6.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLHomeViewController.h"

#import "LLMineViewController.h"
#import "LLUserInfoViewController.h"
#import "JXPagerView.h"
#import "JXCategoryView.h"

@interface LLHomeViewController ()<JXCategoryViewDelegate,JXPagerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *jxTitleView;

@property (nonatomic, strong) JXPagerView *pagerView;
@end

@implementation LLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self initSubviews];
   
}

- (void)initSubviews {
    JXCategoryTitleView *jxTitleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 44)];
    jxTitleView.titles = @[@"动态",@"个人信息",@"照片",@"收藏"];
    jxTitleView.delegate = self;
    self.jxTitleView = jxTitleView;
    
    JXCategoryIndicatorLineView *jxLine = [[JXCategoryIndicatorLineView alloc] init];
    jxLine.indicatorWidth = 30;
    jxTitleView.indicators = @[jxLine];
    
    JXPagerView *pagerView = [[JXPagerView alloc] initWithDelegate:self];
    pagerView.frame = self.view.bounds;
    self.pagerView = pagerView;
    
    [self.view addSubview:self.pagerView];
    
    jxTitleView.contentScrollView = self.pagerView.listContainerView.collectionView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}


#pragma mark - JXPagerViewDelegate
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 
 @param pagerView pagerView description
 @return return tableHeaderView的高度
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 100;
}


/**
 返回tableHeaderView
 
 @param pagerView pagerView description
 @return tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor yellowColor];
    return view;
}


/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 
 @param pagerView pagerView description
 @return 悬浮HeaderView的高度
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 44;
}


/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
 
 @param pagerView pagerView description
 @return 悬浮HeaderView
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.jxTitleView;
}

/**
 返回列表的数量
 
 @param pagerView pagerView description
 @return 列表的数量 //和categoryView的item数量一致
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 4;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！
 
 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    LLUserInfoViewController *vc = [[LLUserInfoViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"第%li个",(long)index];
    if (index == 2) {
        [vc changeDataSource];
    }
    return vc;
    
}

#pragma mark - JXCategoryViewDelegate
/**
 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
 
 @param categoryView categoryView对象
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

@end
