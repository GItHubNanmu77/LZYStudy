//
//  LLCategoryViewController.m
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LLCategoryViewController.h"

#import "LLMineViewController.h"
#import "LLUserInfoViewController.h"

#import "JXPagerView.h"
#import "JXCategoryView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>


@interface LLCategoryViewController ()<JXCategoryViewDelegate, JXPagerViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *jxTitleView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXPagerView *pagerView;

@property (nonatomic, strong) SDCycleScrollView *headerView;
@end

@implementation LLCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    
}

- (void)initSubviews {
    self.titles = [NSMutableArray arrayWithObjects:@"男装",@"女装",@"童装",@"手机数码",@"美妆护肤",@"电脑办公",@"电器",@"食品",@"图书", nil];
    
    JXCategoryTitleView *jxTitleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 44)];
    jxTitleView.titles = [NSArray arrayWithArray:self.titles];
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
    return self.headerView.height;
}


/**
 返回tableHeaderView
 
 @param pagerView pagerView description
 @return tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
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
    return self.titles.count;
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

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

#pragma mark - Getter
- (SDCycleScrollView *)headerView {
    if(!_headerView) {
        _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, LZY_SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"Tips_Error"]];
        _headerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        _headerView.imageURLStringsGroup = @[@"http://a.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a292d2472199d25bc315d607c7c.jpg",        @"http://g.hiphotos.baidu.com/image/pic/item/6d81800a19d8bc3e770bd00d868ba61ea9d345f2.jpg", @"http://c.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de1e296fa390eef01f3b29795a.jpg", @"http://b.hiphotos.baidu.com/image/pic/item/359b033b5bb5c9ea5c0e3c23d139b6003bf3b374.jpg"];
    }
    return _headerView;
}
@end
