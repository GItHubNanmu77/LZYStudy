//
//  CustomTabBar.m
//  LZYStudy
//
//  Created by cisdi on 2019/4/30.
//  Copyright © 2019 lzy. All rights reserved.
//


#import "CustomTabBar.h"
#import "LZYMacro.h"

#define BADGETAG 999

@interface CustomTabBar ()
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) UIButton *btnCenter;
@end

@implementation CustomTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.barTintColor = [UIColor whiteColor];
        
      
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isManager) {
        [self refreshCenterButton];
        CGFloat buttonW = self.frame.size.width / 5;
        CGFloat buttonIndex = 0;
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                CGRect subviewRect = subview.frame;
                subviewRect.size.width = buttonW;
                subviewRect.origin.x = buttonIndex * buttonW;
                subview.frame = subviewRect;
                
                buttonIndex++;
                if (buttonIndex == 2) {
                    buttonIndex++;
                }
            }
        }
    }
   
}

- (void)refreshCenterButton {
    
    [self bringSubviewToFront:self.btnCenter];

    self.btnCenter.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 7.5);
    self.btnCenter.width = self.frame.size.width / 5;
    self.btnCenter.y = LZY_IS_IPHONEX ? - 15.0 : 0.0;
    self.btnCenter.height = self.frame.size.height;
    
    self.isManager = YES;
}

- (void)addCenterButton {
    self.btnCenter = [[UIButton alloc]init];
    [self.btnCenter setImage:[UIImage imageNamed:@"Publish_Normal"] forState:UIControlStateNormal];
    [self.btnCenter setImage:[UIImage imageNamed:@"Publish_Highlighted"] forState:UIControlStateSelected];
    [self.btnCenter addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnCenter];
}


- (void)pressedButton:(UIButton *)sender {
    if (self.tabBarDelegate && [self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickCenterButton:)]) {
        [self.tabBarDelegate tabBarDidClickCenterButton:self];
    }
}

/**
 *  显示小红点
 *
 *  @param index <#index description#>
 */
- (void)showBadgeOnItemIndex:(NSInteger)index {
    if (index >= self.items.count) {
        return;
    }
    
    // 移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    // 新建小红点
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = BADGETAG + index;
    badgeView.layer.cornerRadius = 5.0;
    badgeView.backgroundColor = [UIColor redColor];
    
    // 计算tabBarItem宽度 (有一个凸出按钮)
    CGFloat tabBarItemWidth = self.frame.size.width / (self.items.count + 1);
    
    // 确定小红点的位置，圆形大小为10
    CGFloat rectX = tabBarItemWidth * (index + 1) - (tabBarItemWidth / 2.0) + 10.0;
    if (index > 1) {
        // 有一个凸出按钮，不包含在tabBarItems中
        rectX = tabBarItemWidth * (index + 2) - (tabBarItemWidth / 2.0) + 10.0;
    }
    CGFloat rectY = ceilf(0.1 * self.frame.size.height);
    badgeView.frame = CGRectMake(rectX - 2.0, rectY - 2.0, 10.0, 10.0);
    [self addSubview:badgeView];
}

/**
 *  隐藏小红点
 *
 *  @param index <#index description#>
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index {
    [self removeBadgeOnItemIndex:index];
}

/**
 *  移除小红点
 *
 *  @param index <#index description#>
 */
- (void)removeBadgeOnItemIndex:(NSInteger)index {
    if (index >= self.items.count) {
        return;
    }
    
    // 移除 badgeValue
    UITabBarItem *item = self.items[index];
    item.badgeValue = nil;
    
    // 按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == BADGETAG + index) {
            [subView removeFromSuperview];
        }
    }
}
@end
